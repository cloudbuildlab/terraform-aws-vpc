############################################
# Provider Configuration
############################################

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

############################################
# VPC Module
############################################

module "internal_vpc" {
  source = "../../"

  vpc_name = "internal-vpc"
  vpc_cidr = "10.0.0.0/16"

  vpc_type = "internal" # Just for tagging

  availability_zones = ["ap-southeast-2a", "ap-southeast-2b"]

  # Required for internet access:
  public_subnet_cidrs = ["10.0.1.0/24"] # For NAT Gateway

  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

  enable_nat_gateway = true # This creates NAT Gateway in public subnet

  tags = {
    Environment = "internal"
  }
}
