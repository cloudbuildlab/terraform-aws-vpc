# # ===================================
# # Network ACLs
# # ===================================

# # Public Subnet Network ACL
resource "aws_network_acl" "public" {
  count = var.enable_nacls && length(var.public_subnet_cidrs) > 0 ? 1 : 0

  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.public[*].id

  # Inbound Rules
  # Allow all traffic from within the VPC
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  # Allow all traffic from internet
  ingress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Outbound: Allow all to anywhere
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-public"
      Type = "public"
    },
    var.tags
  )
}

# Private Subnet Network ACL
resource "aws_network_acl" "private" {
  count = var.enable_nacls && length(var.private_subnet_cidrs) > 0 ? 1 : 0

  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.private[*].id

  # Inbound Rules
  # Allow all traffic from within the VPC (for inter-subnet communication)
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  # Allow traffic from NAT Gateway(s)
  dynamic "ingress" {
    for_each = (
      var.nat_gateway_type == "one_per_az" || length(var.public_subnet_cidrs) == 0
      ? var.public_subnet_cidrs
      : slice(var.public_subnet_cidrs, 0, 1)
    )

    content {
      protocol   = "-1"
      rule_no    = 150 + index(var.public_subnet_cidrs, ingress.value)
      action     = "allow"
      cidr_block = ingress.value
      from_port  = 0
      to_port    = 0
    }
  }

  # Allow return traffic from internet (ephemeral ports)
  ingress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Outbound Rules
  # Allow all outbound traffic (for internet access via NAT Gateway)
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-private"
      Type = "private"
    },
    var.tags
  )
}

# # Isolated Subnet Network ACL
resource "aws_network_acl" "isolated" {
  count = var.enable_nacls && length(var.isolated_subnet_cidrs) > 0 ? 1 : 0

  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.isolated[*].id

  # Inbound: Allow all from within the VPC
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  # Outbound: Allow all to within the VPC
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-isolated"
      Type = "isolated"
    },
    var.tags
  )
}

# # Database Subnet Network ACL
resource "aws_network_acl" "database" {
  count = var.enable_nacls && length(var.database_subnet_cidrs) > 0 ? 1 : 0

  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.database[*].id

  # Inbound Rules
  # Allow all from within the VPC
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  # Allow traffic from any source through Transit Gateway
  ingress {
    protocol   = "-1"
    rule_no    = 150
    action     = "allow"
    cidr_block = "0.0.0.0/0" # Allow any source through TGW
    from_port  = 0
    to_port    = 0
  }

  # Outbound Rules
  # Allow all to within the VPC
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  # Allow traffic to any destination through Transit Gateway
  egress {
    protocol   = "-1"
    rule_no    = 150
    action     = "allow"
    cidr_block = "0.0.0.0/0" # Allow any destination through TGW
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-database"
      Type = "database"
    },
    var.tags
  )
}
