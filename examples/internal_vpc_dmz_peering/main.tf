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

# DMZ VPC (for internet access)
module "dmz_vpc" {
  source = "../../"

  vpc_name = "dmz-vpc"
  vpc_cidr = "10.1.0.0/16"

  availability_zones = ["ap-southeast-2a", "ap-southeast-2b"]

  vpc_type = "dmz" # Just for tagging

  public_subnet_cidrs = ["10.1.1.0/24"]

  enable_nat_gateway = true

  tags = {
    Environment = "dmz"
  }
}

# Internal VPC (no public subnets)
module "internal_vpc" {
  source = "../../"

  vpc_name = "internal-vpc"
  vpc_cidr = "10.0.0.0/16"

  availability_zones = ["ap-southeast-2a", "ap-southeast-2b"]

  vpc_type = "internal" # Just for tagging

  # Only private subnets
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

  enable_nat_gateway = false # No NAT Gateway needed

  tags = {
    Environment = "internal"
  }
}

# VPC Peering Connection
resource "aws_vpc_peering_connection" "dmz_to_internal" {
  vpc_id      = module.dmz_vpc.vpc_id
  peer_vpc_id = module.internal_vpc.vpc_id
  auto_accept = true
}

# Route table updates to route internet traffic through DMZ
resource "aws_route" "internal_to_dmz" {
  route_table_id            = module.internal_vpc.private_route_table_ids[0]
  destination_cidr_block    = "0.0.0.0/0"
  vpc_peering_connection_id = aws_vpc_peering_connection.dmz_to_internal.id
}
