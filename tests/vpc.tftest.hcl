# Run setup to create a VPC
run "setup_vpc" {
  module {
    source = "./tests/setup"
  }
}

# Main test block to create and test the VPC, subnets, and NAT gateway
run "test_vpc_configuration" {
  variables {
    vpc_name = "example-vpc"
    vpc_cidr = "10.0.0.0/16"

    # Enable IPv6
    enable_ipv6 = false

    # DNS Configuration
    enable_dns_hostnames = true
    enable_dns_support   = true

    # Subnet configuration - including Auckland (ap-southeast-2-akl-1a)
    availability_zones = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c", "ap-southeast-2-akl-1a"]

    # Subnet CIDRs for all 4 AZs
    public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
    private_subnet_cidrs  = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24", "10.0.14.0/24"]
    isolated_subnet_cidrs = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24", "10.0.24.0/24"]
    database_subnet_cidrs = ["10.0.31.0/24", "10.0.32.0/24", "10.0.33.0/24", "10.0.34.0/24"]

    # NAT Gateway configuration
    enable_nat_gateway = true
    nat_gateway_type   = "single" # Options: "single" or "one_per_az"

    # VPC Endpoints configuration
    enable_logs_endpoint           = true
    enable_monitoring_endpoint     = true
    enable_s3_endpoint             = true
    enable_ssm_endpoint            = true

    # Tags
    tags = {
      Environment = "dev"
      Project     = "demo"
      ManagedBy   = "terraform"
    }
  }

  # Assert that the created VPC ID matches the expected output
  assert {
    condition     = length(aws_vpc.this) > 0
    error_message = "VPC was not created as expected."
  }

  # Assert that the public subnets were created
  assert {
    condition     = length(aws_subnet.public) == 4
    error_message = "Expected 4 public subnets but found different count"
  }

  # Assert that the private subnets were created
  assert {
    condition     = length(aws_subnet.private) == 4
    error_message = "Expected 4 private subnets but found different count"
  }

  # Assert that the isolated subnets were created
  assert {
    condition     = length(aws_subnet.isolated) == 4
    error_message = "Expected 4 isolated subnets but found different count"
  }

  # Assert that the database subnets were created
  assert {
    condition     = length(aws_subnet.database) == 4
    error_message = "Expected 4 database subnets but found different count"
  }

  # Assert that NAT Gateway(s) were created
  assert {
    condition     = length(aws_nat_gateway.this) == 1
    error_message = "Expected one NAT Gateway per AZ, but count does not match"
  }

  # Assert that the Internet Gateway was created when enabled
  assert {
    condition     = aws_internet_gateway.this[0].id != null
    error_message = "Internet Gateway was not created as expected"
  }

  # Assert that the route table for public subnets contains a route to the Internet Gateway
  assert {
    condition = anytrue(flatten([
      for rt in aws_route_table.public : [
        for route in rt.route : route.cidr_block == "0.0.0.0/0" && route.gateway_id != null
      ]
    ]))
    error_message = "Public subnets are missing an Internet Gateway route"
  }

  # Assert that the route table for private subnets contains a route to a NAT Gateway
  assert {
    condition = anytrue(flatten([
      for rt in aws_route_table.private : [
        for route in rt.route : route.cidr_block == "0.0.0.0/0" && route.nat_gateway_id != null
      ]
    ]))
    error_message = "Private subnets are missing a NAT Gateway route"
  }
}
