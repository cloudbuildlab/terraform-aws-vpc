# ===================================
# Network ACLs
# ===================================

# Public Subnet Network ACL
resource "aws_network_acl" "public" {
  count = length(var.public_subnet_cidrs) > 0 ? 1 : 0

  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.public[*].id

  # Inbound Rules
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Outbound Rules
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
  count = length(var.private_subnet_cidrs) > 0 ? 1 : 0

  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.private[*].id

  # Inbound Rules
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  # Allow ephemeral ports for return traffic
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # Outbound Rules
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

# Isolated Subnet Network ACL
resource "aws_network_acl" "isolated" {
  count = length(var.isolated_subnet_cidrs) > 0 ? 1 : 0

  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.isolated[*].id

  # Inbound Rules
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  # Outbound Rules
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

# Database Subnet Network ACL
resource "aws_network_acl" "database" {
  count = length(var.database_subnet_cidrs) > 0 ? 1 : 0

  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.database[*].id

  # Inbound Rules
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  # Outbound Rules
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
      Name = "${var.vpc_name}-database"
      Type = "database"
    },
    var.tags
  )
} 