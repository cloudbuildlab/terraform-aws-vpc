# ===================================
# VPC Configuration
# ===================================
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  
  # Instance tenancy - dedicated for compliance requirements, default for cost efficiency
  instance_tenancy = var.instance_tenancy
  
  # Enable IPv6 support
  assign_generated_ipv6_cidr_block = var.enable_ipv6
  
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
      Name = "${var.vpc_name}-igw"
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
      Name = "${var.vpc_name}-nat-${count.index + 1}"
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
      Name = "${var.vpc_name}-nat-${count.index + 1}"
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

  tags = merge(
    {
      Name = "${var.vpc_name}-public-${count.index + 1}"
      Type = "public"
    },
    var.tags
  )
}

# ===================================
# Public Route Tables
# ===================================
resource "aws_route_table" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = var.create_igw ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.this[0].id
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
  count = length(var.public_subnet_cidrs)

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

  tags = merge(
    {
      Name = "${var.vpc_name}-private-${count.index + 1}"
      Type = "private"
    },
    var.tags
  )
}

# ===================================
# Private Route Tables
# ===================================
resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.this[var.nat_gateway_type == "single" ? 0 : count.index].id
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
  count = length(var.private_subnet_cidrs)

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
  count = length(var.isolated_subnet_cidrs)

  vpc_id = aws_vpc.this.id

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
  count = length(var.isolated_subnet_cidrs)

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
  count = length(var.database_subnet_cidrs)

  vpc_id = aws_vpc.this.id

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
  count = length(var.database_subnet_cidrs)

  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database[count.index].id
}