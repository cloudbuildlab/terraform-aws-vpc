############################################
# Provider Configuration
############################################

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.12.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-6"
}

data "aws_availability_zones" "available" {
  state = "available"
}

############################################
# VPC Module
############################################

module "vpc" {
  source = "../.."

  vpc_name = "example-vpc"
  vpc_cidr = "10.0.0.0/16"

  # Enable IPv6
  enable_ipv6 = false

  # DNS Configuration
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Subnet configuration - (ap-southeast-6 has 3 availability zones)
  availability_zones = data.aws_availability_zones.available.names

  # Subnet CIDRs for 3 AZs (ap-southeast-6 has 3 availability zones)
  public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs  = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  isolated_subnet_cidrs = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
  database_subnet_cidrs = ["10.0.31.0/24", "10.0.32.0/24", "10.0.33.0/24"]

  # NAT Gateway configuration
  enable_nat_gateway = true
  nat_gateway_type   = "single" # Options: "single" or "one_per_az"

  # VPC Endpoints configuration
  enable_ecr_api_endpoint        = true
  enable_ecr_dkr_endpoint        = true
  enable_ecs_endpoint            = true
  enable_kms_endpoint            = true
  enable_logs_endpoint           = true
  enable_monitoring_endpoint     = true
  enable_rds_endpoint            = true
  enable_s3_endpoint             = true
  enable_secretsmanager_endpoint = true
  enable_sns_endpoint            = true
  enable_sqs_endpoint            = true
  enable_ssm_endpoint            = true

  # Tags
  tags = {
    Environment = "dev"
    Project     = "demo"
    ManagedBy   = "terraform"
  }

  # EKS Configuration (optional)
  enable_eks_tags  = true
  eks_cluster_name = "example-cluster"
}

############################################
# Outputs
############################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.vpc.vpc_arn
}

output "vpc_ipv6_cidr" {
  description = "The IPv6 CIDR block of the VPC"
  value       = module.vpc.vpc_ipv6_cidr
}

output "availability_zones" {
  description = "List of availability zones used in the VPC"
  value       = module.vpc.availability_zones
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "isolated_subnet_ids" {
  description = "List of isolated subnet IDs"
  value       = module.vpc.isolated_subnet_ids
}

output "database_subnet_ids" {
  description = "List of database subnet IDs"
  value       = module.vpc.database_subnet_ids
}

output "nat_gateway_ip" {
  description = "List of NAT Gateway public IPs"
  value       = module.vpc.nat_gateway_ip
}
