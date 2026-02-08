# Data source for current region
data "aws_region" "current" {}

# ===================================
# Local values for EKS tags
# ===================================
locals {
  # EKS tags for public subnets (internet-facing load balancers)
  eks_public_tags = var.enable_eks_tags ? {
    "kubernetes.io/role/elb"                        = "1"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  } : {}

  # EKS tags for private subnets (internal load balancers)
  eks_private_tags = var.enable_eks_tags ? {
    "kubernetes.io/role/internal-elb"               = "1"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  } : {}
}

# ===================================
# VPC Configuration
# ===================================
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  # Instance tenancy - dedicated for compliance requirements, default for cost efficiency
  instance_tenancy = var.instance_tenancy

  # IPv6 configuration
  # Note: ipv6_cidr_block attribute requires ipv6_ipam_pool_id (for IPAM)
  # For custom IPv6 CIDRs without IPAM, use aws_vpc_ipv6_cidr_block_association resource separately
  # Here we only support auto-assignment via assign_generated_ipv6_cidr_block
  assign_generated_ipv6_cidr_block = var.enable_ipv6 ? var.assign_generated_ipv6_cidr_block : false

  # Additional DNS settings
  enable_network_address_usage_metrics = true

  tags = merge(
    {
      Name = var.vpc_name
    },
    var.tags
  )
}

# ===================================
# Internet Gateway
# ===================================
resource "aws_internet_gateway" "this" {
  count = var.create_igw && length(var.public_subnet_cidrs) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name     = "${var.vpc_name}-igw"
      VPC_Type = var.vpc_type
    },
    var.tags
  )
}

# ===================================
# Elastic IPs for NAT Gateway
# ===================================
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? (var.nat_gateway_type == "single" ? 1 : length(var.availability_zones)) : 0

  domain = "vpc"

  tags = merge(
    {
      Name     = "${var.vpc_name}-nat-${count.index + 1}"
      VPC_Type = var.vpc_type
    },
    var.tags
  )
}

# ===================================
# NAT Gateway
# ===================================
resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? (var.nat_gateway_type == "single" ? 1 : length(var.availability_zones)) : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index % length(var.public_subnet_cidrs)].id

  tags = merge(
    {
      Name     = "${var.vpc_name}-nat-${count.index + 1}"
      VPC_Type = var.vpc_type
    },
    var.tags
  )

  depends_on = [aws_internet_gateway.this]
}

# ===================================
# Public Subnets
# ===================================
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  # IPv6 configuration
  ipv6_cidr_block                 = var.enable_ipv6 && length(var.public_subnet_ipv6_cidrs) > count.index ? var.public_subnet_ipv6_cidrs[count.index] : null
  assign_ipv6_address_on_creation = var.enable_ipv6 && length(var.public_subnet_ipv6_cidrs) > count.index ? true : false

  tags = merge(
    {
      Name     = "${var.vpc_name}-public-${count.index + 1}"
      Type     = "public"
      VPC_Type = var.vpc_type
    },
    var.tags,
    local.eks_public_tags
  )
}

# ===================================
# Public Route Tables
# ===================================
resource "aws_route_table" "public" {
  count = var.enable_route_tables ? length(var.public_subnet_cidrs) : 0

  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = var.create_igw && !try(var.custom_routes.public.use_only, false) ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.this[0].id
    }
  }

  dynamic "route" {
    for_each = try(var.custom_routes.public.routes, [])
    content {
      cidr_block                = route.value.cidr_block
      gateway_id                = route.value.gateway_id
      nat_gateway_id            = route.value.nat_gateway_id
      network_interface_id      = route.value.network_interface_id
      transit_gateway_id        = route.value.transit_gateway_id
      vpc_peering_connection_id = route.value.vpc_peering_connection_id
    }
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-public-${var.availability_zones[count.index]}"
      Type = "public"
      AZ   = var.availability_zones[count.index]
    },
    var.tags
  )
}

resource "aws_route_table_association" "public" {
  count = var.enable_route_tables ? length(var.public_subnet_cidrs) : 0

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

# ===================================
# Private Subnets
# ===================================
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  # IPv6 configuration
  ipv6_cidr_block                 = var.enable_ipv6 && length(var.private_subnet_ipv6_cidrs) > count.index ? var.private_subnet_ipv6_cidrs[count.index] : null
  assign_ipv6_address_on_creation = var.enable_ipv6 && length(var.private_subnet_ipv6_cidrs) > count.index ? true : false

  tags = merge(
    {
      Name = "${var.vpc_name}-private-${count.index + 1}"
      Type = "private"
    },
    var.tags,
    local.eks_private_tags
  )
}

# ===================================
# Private Route Tables
# ===================================
resource "aws_route_table" "private" {
  count = var.enable_route_tables ? length(var.private_subnet_cidrs) : 0

  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = var.enable_nat_gateway && !try(var.custom_routes.private.use_only, false) ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.this[var.nat_gateway_type == "single" ? 0 : count.index].id
    }
  }

  dynamic "route" {
    for_each = try(var.custom_routes.private.routes, [])
    content {
      cidr_block                = route.value.cidr_block
      gateway_id                = route.value.gateway_id
      nat_gateway_id            = route.value.nat_gateway_id
      network_interface_id      = route.value.network_interface_id
      transit_gateway_id        = route.value.transit_gateway_id
      vpc_peering_connection_id = route.value.vpc_peering_connection_id
    }
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-private-${var.availability_zones[count.index]}"
      Type = "private"
      AZ   = var.availability_zones[count.index]
    },
    var.tags
  )
}

resource "aws_route_table_association" "private" {
  count = var.enable_route_tables ? length(var.private_subnet_cidrs) : 0

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# ===================================
# Isolated Subnets
# ===================================
resource "aws_subnet" "isolated" {
  count = length(var.isolated_subnet_cidrs)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.isolated_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  # IPv6 configuration
  ipv6_cidr_block                 = var.enable_ipv6 && length(var.isolated_subnet_ipv6_cidrs) > count.index ? var.isolated_subnet_ipv6_cidrs[count.index] : null
  assign_ipv6_address_on_creation = var.enable_ipv6 && length(var.isolated_subnet_ipv6_cidrs) > count.index ? true : false

  tags = merge(
    {
      Name = "${var.vpc_name}-isolated-${count.index + 1}"
      Type = "isolated"
    },
    var.tags
  )
}

# ===================================
# Isolated Route Tables
# ===================================
resource "aws_route_table" "isolated" {
  count = var.enable_route_tables ? length(var.isolated_subnet_cidrs) : 0

  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = try(var.custom_routes.isolated.routes, [])
    content {
      cidr_block                = route.value.cidr_block
      gateway_id                = route.value.gateway_id
      nat_gateway_id            = route.value.nat_gateway_id
      network_interface_id      = route.value.network_interface_id
      transit_gateway_id        = route.value.transit_gateway_id
      vpc_peering_connection_id = route.value.vpc_peering_connection_id
    }
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-isolated-${var.availability_zones[count.index]}"
      Type = "isolated"
      AZ   = var.availability_zones[count.index]
    },
    var.tags
  )
}

resource "aws_route_table_association" "isolated" {
  count = var.enable_route_tables ? length(var.isolated_subnet_cidrs) : 0

  subnet_id      = aws_subnet.isolated[count.index].id
  route_table_id = aws_route_table.isolated[count.index].id
}

# ===================================
# Database Subnets
# ===================================
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.database_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  # IPv6 configuration
  ipv6_cidr_block                 = var.enable_ipv6 && length(var.database_subnet_ipv6_cidrs) > count.index ? var.database_subnet_ipv6_cidrs[count.index] : null
  assign_ipv6_address_on_creation = var.enable_ipv6 && length(var.database_subnet_ipv6_cidrs) > count.index ? true : false

  tags = merge(
    {
      Name = "${var.vpc_name}-database-${count.index + 1}"
      Type = "database"
    },
    var.tags
  )
}

# ===================================
# Database Route Tables
# ===================================
resource "aws_route_table" "database" {
  count = var.enable_route_tables ? length(var.database_subnet_cidrs) : 0

  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = try(var.custom_routes.database.routes, [])
    content {
      cidr_block                = route.value.cidr_block
      gateway_id                = route.value.gateway_id
      nat_gateway_id            = route.value.nat_gateway_id
      network_interface_id      = route.value.network_interface_id
      transit_gateway_id        = route.value.transit_gateway_id
      vpc_peering_connection_id = route.value.vpc_peering_connection_id
    }
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-database-${var.availability_zones[count.index]}"
      Type = "database"
      AZ   = var.availability_zones[count.index]
    },
    var.tags
  )
}

resource "aws_route_table_association" "database" {
  count = var.enable_route_tables ? length(var.database_subnet_cidrs) : 0

  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database[count.index].id
}

# ===================================
# Egress-Only Internet Gateway (for IPv6)
# ===================================
resource "aws_egress_only_internet_gateway" "this" {
  count  = var.enable_ipv6 && length(var.private_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name     = "${var.vpc_name}-egw"
      VPC_Type = var.vpc_type
    },
    var.tags
  )
}

# ===================================
# IPv6 Routes
# ===================================
# Public subnet IPv6 route to Internet Gateway
resource "aws_route" "public_ipv6_internet_gateway" {
  count = var.enable_ipv6 && var.enable_route_tables && var.create_igw && length(var.public_subnet_cidrs) > 0 && length(var.public_subnet_ipv6_cidrs) > 0 ? length(aws_route_table.public) : 0

  route_table_id              = aws_route_table.public[count.index].id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this[0].id
}

# Private subnet IPv6 route to Egress-Only Internet Gateway
resource "aws_route" "private_ipv6_egress_only_gateway" {
  count = var.enable_ipv6 && var.enable_route_tables && length(var.private_subnet_cidrs) > 0 && length(var.private_subnet_ipv6_cidrs) > 0 ? length(aws_route_table.private) : 0

  route_table_id              = aws_route_table.private[count.index].id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.this[0].id
}
