# Complete VPC Example

This example demonstrates a complete VPC setup with all available features of the VPC module.

## Features Demonstrated

- VPC with IPv4 CIDR block
- DNS configuration (hostnames and support enabled)
- Subnets across multiple availability zones:
  - 4 Public subnets with Internet Gateway access
  - 4 Private subnets with NAT Gateway access
  - 4 Isolated subnets with no internet access
  - 4 Database subnets
- Single NAT Gateway for cost efficiency
- VPC Endpoints for commonly used services:
  - S3 (Gateway endpoint)
  - SSM (Interface endpoint)
  - CloudWatch Logs (Interface endpoint)
  - CloudWatch Monitoring (Interface endpoint)
- Resource tagging for better management

## Usage

1. Initialize Terraform:

    ```bash
    terraform init
    ```

2. Review the execution plan:

    ```bash
    terraform plan
    ```

3. Apply the configuration:

    ```bash
    terraform apply
    ```

## Configuration Details

### VPC Configuration

- CIDR Block: 10.0.0.0/16
- IPv6: Disabled
- DNS: Hostnames and support enabled
- Availability Zones: ap-southeast-2a, ap-southeast-2b, ap-southeast-2c, ap-southeast-2-akl-1a
- Route Tables: Enabled by default, can be disabled to manage route tables externally

### Subnet Configuration

- Public Subnets: 10.0.1.0/24 to 10.0.4.0/24
- Private Subnets: 10.0.11.0/24 to 10.0.14.0/24
- Isolated Subnets: 10.0.21.0/24 to 10.0.24.0/24
- Database Subnets: 10.0.31.0/24 to 10.0.34.0/24

### NAT Gateway

- Type: Single (cost-efficient)
- Location: First public subnet

### VPC Endpoints

Enabled endpoints:

- S3 (Gateway)
- SSM (Interface)
- CloudWatch Logs (Interface)
- CloudWatch Monitoring (Interface)

## Outputs

The example provides the following outputs:

- VPC ID and CIDR
- Subnet IDs for each type
- NAT Gateway IPs
- Availability zones used
- VPC ARN
- IPv6 CIDR (empty in this example)
- Route table IDs for each subnet type (when enabled)

## Notes

- This example uses the ap-southeast-2 region
- Some VPC endpoints are disabled as they are not supported in the ap-southeast-2-akl-1a availability zone
- The NAT Gateway is configured as "single" for cost efficiency, but can be changed to "one_per_az" for high availability
- Route tables can be disabled by setting `enable_route_tables = false` to manage them externally
