terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

module "vpc" {
  source = "../../"

  vpc_name = "dual-stack-vpc"
  vpc_cidr = "10.0.0.0/16"

  availability_zones = ["ap-southeast-2a", "ap-southeast-2b"]

  # Enable IPv6
  assign_generated_ipv6_cidr_block = true

  # IPv4 subnets
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

  # Basic networking
  enable_nat_gateway = true
  create_igw         = true

  tags = {
    Environment = "example"
    Project     = "dual-stack"
  }
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_ipv4_cidr" {
  description = "VPC IPv4 CIDR"
  value       = module.vpc.vpc_cidr
}

output "vpc_ipv6_cidr" {
  description = "VPC IPv6 CIDR"
  value       = module.vpc.vpc_ipv6_cidr
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}
