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
# Recommended EKS VPC Configuration
############################################

module "vpc" {
  source = "../.."

  vpc_name = "eks-vpc"
  vpc_cidr = "10.0.0.0/16"

  # DNS Configuration
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Subnet configuration (2 AZs for minimal HA)
  availability_zones   = ["ap-southeast-2a", "ap-southeast-2b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

  # NAT Gateway for private subnets
  enable_nat_gateway = true
  nat_gateway_type   = "single"

  # Essential VPC Endpoints for EKS workloads
  enable_s3_endpoint      = true # Required for container images and logs
  enable_ecr_api_endpoint = true # Required for pulling images from ECR
  enable_ecr_dkr_endpoint = true # Required for ECR authentication

  # EKS Configuration
  enable_eks_tags  = true
  eks_cluster_name = "my-eks-cluster"

  # Tags
  tags = {
    Environment = "prod"
    Project     = "eks-demo"
    ManagedBy   = "terraform"
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

output "nat_gateway_ip" {
  description = "List of NAT Gateway public IPs"
  value       = module.vpc.nat_gateway_ip
}
