# ===================================
# Network ACLs
# ===================================
# NACLs are created without inline rules to avoid AWS provider set-correlation bugs
# ("Provider produced inconsistent final plan"). All rules use aws_network_acl_rule.

locals {
  # CIDRs used for private NACL ingress (traffic from NAT Gateway(s))
  private_nacl_nat_ingress_cidrs = var.enable_nacls && length(var.private_subnet_cidrs) > 0 ? (
    var.nat_gateway_type == "one_per_az" || length(var.public_subnet_cidrs) == 0
    ? var.public_subnet_cidrs
    : slice(var.public_subnet_cidrs, 0, 1)
  ) : []
}

# Public Subnet Network ACL
resource "aws_network_acl" "public" {
  count = var.enable_nacls && length(var.public_subnet_cidrs) > 0 ? 1 : 0

  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.public[*].id

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
  count = var.enable_nacls && length(var.isolated_subnet_cidrs) > 0 ? 1 : 0

  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.isolated[*].id

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
  count = var.enable_nacls && length(var.database_subnet_cidrs) > 0 ? 1 : 0

  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.database[*].id

  tags = merge(
    {
      Name = "${var.vpc_name}-database"
      Type = "database"
    },
    var.tags
  )
}

# ===================================
# Public NACL rules
# ===================================

resource "aws_network_acl_rule" "public_ingress_vpc" {
  count = var.enable_nacls && length(var.public_subnet_cidrs) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.public[0].id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "public_ingress_all" {
  count = var.enable_nacls && length(var.public_subnet_cidrs) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.public[0].id
  rule_number    = 200
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "public_egress_all" {
  count = var.enable_nacls && length(var.public_subnet_cidrs) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.public[0].id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  egress         = true
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "public_ingress_ipv6_vpc" {
  count = var.enable_nacls && length(var.public_subnet_cidrs) > 0 && var.assign_generated_ipv6_cidr_block && aws_vpc.this.ipv6_cidr_block != null ? 1 : 0

  network_acl_id  = aws_network_acl.public[0].id
  rule_number     = 300
  protocol        = "-1"
  rule_action     = "allow"
  ipv6_cidr_block = aws_vpc.this.ipv6_cidr_block
  from_port       = 0
  to_port         = 0
}

resource "aws_network_acl_rule" "public_ingress_ipv6_all" {
  count = var.enable_nacls && length(var.public_subnet_cidrs) > 0 && var.assign_generated_ipv6_cidr_block ? 1 : 0

  network_acl_id  = aws_network_acl.public[0].id
  rule_number     = 400
  protocol        = "-1"
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
  from_port       = 0
  to_port         = 0
}

resource "aws_network_acl_rule" "public_egress_ipv6_all" {
  count = var.enable_nacls && length(var.public_subnet_cidrs) > 0 && var.assign_generated_ipv6_cidr_block ? 1 : 0

  network_acl_id  = aws_network_acl.public[0].id
  rule_number     = 200
  protocol        = "-1"
  rule_action     = "allow"
  egress          = true
  ipv6_cidr_block = "::/0"
  from_port       = 0
  to_port         = 0
}

# ===================================
# Private NACL rules
# ===================================

resource "aws_network_acl_rule" "private_ingress_vpc" {
  count = var.enable_nacls && length(var.private_subnet_cidrs) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.private[0].id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "private_ingress_nat" {
  for_each = var.enable_nacls && length(var.private_subnet_cidrs) > 0 ? { for i, c in local.private_nacl_nat_ingress_cidrs : i => c } : {}

  network_acl_id = aws_network_acl.private[0].id
  rule_number    = 150 + each.key
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = each.value
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "private_ingress_all" {
  count = var.enable_nacls && length(var.private_subnet_cidrs) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.private[0].id
  rule_number    = 200
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "private_egress_all" {
  count = var.enable_nacls && length(var.private_subnet_cidrs) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.private[0].id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  egress         = true
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "private_ingress_ipv6_vpc" {
  count = var.enable_nacls && length(var.private_subnet_cidrs) > 0 && var.assign_generated_ipv6_cidr_block && aws_vpc.this.ipv6_cidr_block != null ? 1 : 0

  network_acl_id  = aws_network_acl.private[0].id
  rule_number     = 300
  protocol        = "-1"
  rule_action     = "allow"
  ipv6_cidr_block = aws_vpc.this.ipv6_cidr_block
  from_port       = 0
  to_port         = 0
}

resource "aws_network_acl_rule" "private_ingress_ipv6_all" {
  count = var.enable_nacls && length(var.private_subnet_cidrs) > 0 && var.assign_generated_ipv6_cidr_block ? 1 : 0

  network_acl_id  = aws_network_acl.private[0].id
  rule_number     = 400
  protocol        = "-1"
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
  from_port       = 0
  to_port         = 0
}

resource "aws_network_acl_rule" "private_egress_ipv6_all" {
  count = var.enable_nacls && length(var.private_subnet_cidrs) > 0 && var.assign_generated_ipv6_cidr_block ? 1 : 0

  network_acl_id  = aws_network_acl.private[0].id
  rule_number     = 200
  protocol        = "-1"
  rule_action     = "allow"
  egress          = true
  ipv6_cidr_block = "::/0"
  from_port       = 0
  to_port         = 0
}

# ===================================
# Isolated NACL rules
# ===================================

resource "aws_network_acl_rule" "isolated_ingress_vpc" {
  count = var.enable_nacls && length(var.isolated_subnet_cidrs) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.isolated[0].id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "isolated_egress_vpc" {
  count = var.enable_nacls && length(var.isolated_subnet_cidrs) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.isolated[0].id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  egress         = true
  cidr_block     = var.vpc_cidr
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "isolated_ingress_ipv6_vpc" {
  count = var.enable_nacls && length(var.isolated_subnet_cidrs) > 0 && var.assign_generated_ipv6_cidr_block && aws_vpc.this.ipv6_cidr_block != null ? 1 : 0

  network_acl_id  = aws_network_acl.isolated[0].id
  rule_number     = 200
  protocol        = "-1"
  rule_action     = "allow"
  ipv6_cidr_block = aws_vpc.this.ipv6_cidr_block
  from_port       = 0
  to_port         = 0
}

resource "aws_network_acl_rule" "isolated_egress_ipv6_vpc" {
  count = var.enable_nacls && length(var.isolated_subnet_cidrs) > 0 && var.assign_generated_ipv6_cidr_block && aws_vpc.this.ipv6_cidr_block != null ? 1 : 0

  network_acl_id  = aws_network_acl.isolated[0].id
  rule_number     = 200
  protocol        = "-1"
  rule_action     = "allow"
  egress          = true
  ipv6_cidr_block = aws_vpc.this.ipv6_cidr_block
  from_port       = 0
  to_port         = 0
}

# ===================================
# Database NACL rules
# ===================================

resource "aws_network_acl_rule" "database_ingress_vpc" {
  count = var.enable_nacls && length(var.database_subnet_cidrs) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.database[0].id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "database_ingress_all" {
  count = var.enable_nacls && length(var.database_subnet_cidrs) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.database[0].id
  rule_number    = 150
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "database_egress_vpc" {
  count = var.enable_nacls && length(var.database_subnet_cidrs) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.database[0].id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  egress         = true
  cidr_block     = var.vpc_cidr
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "database_egress_all" {
  count = var.enable_nacls && length(var.database_subnet_cidrs) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.database[0].id
  rule_number    = 150
  protocol       = "-1"
  rule_action    = "allow"
  egress         = true
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "database_ingress_ipv6_vpc" {
  count = var.enable_nacls && length(var.database_subnet_cidrs) > 0 && var.assign_generated_ipv6_cidr_block && aws_vpc.this.ipv6_cidr_block != null ? 1 : 0

  network_acl_id  = aws_network_acl.database[0].id
  rule_number     = 200
  protocol        = "-1"
  rule_action     = "allow"
  ipv6_cidr_block = aws_vpc.this.ipv6_cidr_block
  from_port       = 0
  to_port         = 0
}

resource "aws_network_acl_rule" "database_ingress_ipv6_all" {
  count = var.enable_nacls && length(var.database_subnet_cidrs) > 0 && var.assign_generated_ipv6_cidr_block ? 1 : 0

  network_acl_id  = aws_network_acl.database[0].id
  rule_number     = 250
  protocol        = "-1"
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
  from_port       = 0
  to_port         = 0
}

resource "aws_network_acl_rule" "database_egress_ipv6_vpc" {
  count = var.enable_nacls && length(var.database_subnet_cidrs) > 0 && var.assign_generated_ipv6_cidr_block && aws_vpc.this.ipv6_cidr_block != null ? 1 : 0

  network_acl_id  = aws_network_acl.database[0].id
  rule_number     = 200
  protocol        = "-1"
  rule_action     = "allow"
  egress          = true
  ipv6_cidr_block = aws_vpc.this.ipv6_cidr_block
  from_port       = 0
  to_port         = 0
}

resource "aws_network_acl_rule" "database_egress_ipv6_all" {
  count = var.enable_nacls && length(var.database_subnet_cidrs) > 0 && var.assign_generated_ipv6_cidr_block ? 1 : 0

  network_acl_id  = aws_network_acl.database[0].id
  rule_number     = 250
  protocol        = "-1"
  rule_action     = "allow"
  egress          = true
  ipv6_cidr_block = "::/0"
  from_port       = 0
  to_port         = 0
}
