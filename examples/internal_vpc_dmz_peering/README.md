# Internal VPC to DMZ VPC Peering Example

This example demonstrates how to set up two VPCs (an internal VPC and a DMZ VPC) and connect them using a VPC peering connection. The DMZ VPC provides internet access, while the internal VPC is isolated from direct internet access. Routing is configured so that the internal VPC can send outbound traffic through the DMZ VPC via the peering connection.

## Features Demonstrated

- Creation of two VPCs: one DMZ (with public subnet and NAT Gateway) and one internal (private subnets only)
- Use of `vpc_type` for tagging/documentation (does not restrict resources)
- VPC peering connection between DMZ and internal VPCs
- Route table update in the internal VPC to send internet-bound traffic through the DMZ VPC
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

- **DMZ VPC:**
  - Name: dmz-vpc
  - CIDR: 10.1.0.0/16
  - Public Subnet: 10.1.1.0/24
  - NAT Gateway: Enabled
  - Tags: Environment = "dmz"

- **Internal VPC:**
  - Name: internal-vpc
  - CIDR: 10.0.0.0/16
  - Private Subnets: 10.0.11.0/24, 10.0.12.0/24
  - NAT Gateway: Disabled
  - Tags: Environment = "internal"

- **Peering:**
  - VPC peering connection from DMZ to internal VPC
  - Route in internal VPC's private route table to send 0.0.0.0/0 traffic via the peering connection

## Notes

- The `vpc_type` variable is used for tagging/documentation only and does not restrict subnet or NAT Gateway creation.
- This pattern allows the internal VPC to access the internet via the DMZ VPC, while remaining isolated from direct internet access.
- You can customize subnet CIDRs and availability zones as needed for your environment.
