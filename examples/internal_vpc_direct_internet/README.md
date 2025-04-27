# Internal VPC with Direct Internet Access Example

This example demonstrates how to deploy an "internal" VPC that still allows direct internet access for private resources using a NAT Gateway. The `vpc_type` variable is used for tagging and documentation only; all subnet types are available regardless of VPC type.

## Features Demonstrated

- VPC with IPv4 CIDR block
- `vpc_type` set to `internal` (for informational tagging)
- Public subnet for NAT Gateway
- Private subnets for application workloads
- NAT Gateway for outbound internet access from private subnets
- Multi-AZ deployment

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

- **VPC Name:** internal-vpc
- **VPC CIDR:** 10.0.0.0/16
- **Availability Zones:** ap-southeast-2a, ap-southeast-2b
- **Public Subnets:** ["10.0.1.0/24"] (for NAT Gateway)
- **Private Subnets:** ["10.0.11.0/24", "10.0.12.0/24"]
- **NAT Gateway:** Enabled (for private subnet internet access)
- **Tags:** Environment = "internal"

## Notes

- The `vpc_type` variable is used for tagging/documentation only and does not restrict subnet or NAT Gateway creation.
- This example shows how an "internal" VPC can still provide internet access to private subnets via a NAT Gateway in a public subnet.
- You can customize subnet CIDRs and availability zones as needed for your environment.
