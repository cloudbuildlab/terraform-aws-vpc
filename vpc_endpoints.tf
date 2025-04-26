# ===================================
# VPC Endpoints
# ===================================

# Gateway Endpoints
resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_endpoint ? 1 : 0

  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = concat(
    aws_route_table.private[*].id,
    aws_route_table.isolated[*].id,
    aws_route_table.database[*].id
  )

  tags = merge(
    {
      Name = "${var.vpc_name}-s3-endpoint"
      Type = "gateway"
    },
    var.tags
  )
}

# Interface Endpoints - Individual Resources
resource "aws_vpc_endpoint" "rds" {
  count = var.enable_rds_endpoint ? 1 : 0

  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.rds"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.database[*].id

  security_group_ids = [
    aws_security_group.rds_endpoint[0].id
  ]

  tags = merge(
    {
      Name = "${var.vpc_name}-rds-endpoint"
      Type = "interface"
    },
    var.tags
  )
}

resource "aws_vpc_endpoint" "sqs" {
  count = var.enable_sqs_endpoint ? 1 : 0

  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.sqs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private[*].id

  security_group_ids = [
    aws_security_group.sqs_endpoint[0].id
  ]

  tags = merge(
    {
      Name = "${var.vpc_name}-sqs-endpoint"
      Type = "interface"
    },
    var.tags
  )
}

resource "aws_vpc_endpoint" "sns" {
  count = var.enable_sns_endpoint ? 1 : 0

  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.sns"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private[*].id

  security_group_ids = [
    aws_security_group.sns_endpoint[0].id
  ]

  tags = merge(
    {
      Name = "${var.vpc_name}-sns-endpoint"
      Type = "interface"
    },
    var.tags
  )
}

resource "aws_vpc_endpoint" "secretsmanager" {
  count = var.enable_secretsmanager_endpoint ? 1 : 0

  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private[*].id

  security_group_ids = [
    aws_security_group.secretsmanager_endpoint[0].id
  ]

  tags = merge(
    {
      Name = "${var.vpc_name}-secretsmanager-endpoint"
      Type = "interface"
    },
    var.tags
  )
}

resource "aws_vpc_endpoint" "ecr_api" {
  count = var.enable_ecr_api_endpoint ? 1 : 0

  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private[*].id

  security_group_ids = [
    aws_security_group.ecr_endpoint[0].id
  ]

  tags = merge(
    {
      Name = "${var.vpc_name}-ecr-api-endpoint"
      Type = "interface"
    },
    var.tags
  )
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  count = var.enable_ecr_dkr_endpoint ? 1 : 0

  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private[*].id

  security_group_ids = [
    aws_security_group.ecr_endpoint[0].id
  ]

  tags = merge(
    {
      Name = "${var.vpc_name}-ecr-dkr-endpoint"
      Type = "interface"
    },
    var.tags
  )
}

resource "aws_vpc_endpoint" "kms" {
  count = var.enable_kms_endpoint ? 1 : 0

  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.kms"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private[*].id

  security_group_ids = [
    aws_security_group.kms_endpoint[0].id
  ]

  tags = merge(
    {
      Name = "${var.vpc_name}-kms-endpoint"
      Type = "interface"
    },
    var.tags
  )
}

resource "aws_vpc_endpoint" "ecs" {
  count = var.enable_ecs_endpoint ? 1 : 0

  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private[*].id

  security_group_ids = [
    aws_security_group.ecs_endpoint[0].id
  ]

  tags = merge(
    {
      Name = "${var.vpc_name}-ecs-endpoint"
      Type = "interface"
    },
    var.tags
  )
}

# Security Groups for Individual Endpoints
resource "aws_security_group" "rds_endpoint" {
  count = var.enable_rds_endpoint ? 1 : 0

  name        = "${var.vpc_name}-rds-endpoint"
  description = "Security group for RDS endpoint"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-rds-endpoint"
    },
    var.tags
  )
}

resource "aws_security_group" "sqs_endpoint" {
  count = var.enable_sqs_endpoint ? 1 : 0

  name        = "${var.vpc_name}-sqs-endpoint"
  description = "Security group for SQS endpoint"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-sqs-endpoint"
    },
    var.tags
  )
}

resource "aws_security_group" "sns_endpoint" {
  count = var.enable_sns_endpoint ? 1 : 0

  name        = "${var.vpc_name}-sns-endpoint"
  description = "Security group for SNS endpoint"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-sns-endpoint"
    },
    var.tags
  )
}

resource "aws_security_group" "secretsmanager_endpoint" {
  count = var.enable_secretsmanager_endpoint ? 1 : 0

  name        = "${var.vpc_name}-secretsmanager-endpoint"
  description = "Security group for Secrets Manager endpoint"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-secretsmanager-endpoint"
    },
    var.tags
  )
}

resource "aws_security_group" "ecr_endpoint" {
  count = var.enable_ecr_api_endpoint || var.enable_ecr_dkr_endpoint ? 1 : 0

  name        = "${var.vpc_name}-ecr-endpoint"
  description = "Security group for ECR endpoints"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-ecr-endpoint"
    },
    var.tags
  )
}

resource "aws_security_group" "kms_endpoint" {
  count = var.enable_kms_endpoint ? 1 : 0

  name        = "${var.vpc_name}-kms-endpoint"
  description = "Security group for KMS endpoint"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-kms-endpoint"
    },
    var.tags
  )
}

resource "aws_security_group" "ecs_endpoint" {
  count = var.enable_ecs_endpoint ? 1 : 0

  name        = "${var.vpc_name}-ecs-endpoint"
  description = "Security group for ECS endpoint"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-ecs-endpoint"
    },
    var.tags
  )
}

# Data source for current region
data "aws_region" "current" {} 