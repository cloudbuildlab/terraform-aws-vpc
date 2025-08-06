############################################
# Provider Configuration
############################################

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

############################################
# EKS VPC Configuration
############################################

module "vpc" {
  source = "../.."

  vpc_name = "eks-vpc"
  vpc_cidr = "10.0.0.0/16"

  # DNS Configuration
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Subnet configuration (2 AZs minimum for EKS)
  availability_zones   = ["ap-southeast-2a", "ap-southeast-2b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

  # NAT Gateway (required for private subnets)
  enable_nat_gateway = true
  nat_gateway_type   = "single"

  # EKS Configuration
  enable_eks_tags  = true
  eks_cluster_name = "my-eks-cluster"

  # Tags
  tags = {
    Environment = "dev"
    Project     = "eks-demo"
  }
}

############################################
# Outputs
############################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs (for Load Balancers)"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs (for EKS nodes)"
  value       = module.vpc.private_subnet_ids
}
