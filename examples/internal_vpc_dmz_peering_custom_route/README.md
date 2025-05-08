# Internal VPC to DMZ VPC Peering Example

This example demonstrates how to set up two VPCs (an internal VPC and a DMZ VPC) and connect them using a VPC peering connection. The DMZ VPC provides internet access, while the internal VPC is isolated from direct internet access. Routing is configured using the `custom_routes` input to send outbound traffic from the internal VPC through the DMZ VPC via the peering connection.

## Features Demonstrated

* Creation of two VPCs: one DMZ (with public subnet and NAT Gateway) and one internal (private subnets only)
* Use of `vpc_type` for tagging/documentation (does not restrict resources)
* VPC peering connection between DMZ and internal VPCs
* **Custom routing from internal VPC to DMZ using `custom_routes`**
* Multi-AZ deployment

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

* **DMZ VPC:**

  * Name: `dmz-vpc`
  * CIDR: `10.1.0.0/16`
  * Public Subnet: `10.1.1.0/24`
  * NAT Gateway: Enabled
  * Tags: `Environment = "dmz"`

* **Internal VPC:**

  * Name: `internal-vpc`
  * CIDR: `10.0.0.0/16`
  * Private Subnets: `10.0.11.0/24`, `10.0.12.0/24`
  * NAT Gateway: Disabled
  * Tags: `Environment = "internal"`
  * `custom_routes.private` includes a route for `0.0.0.0/0` via the VPC peering connection

* **Peering:**

  * VPC peering connection from DMZ to internal VPC
  * Return route in DMZ VPC to `10.0.0.0/16` to allow bidirectional communication

## Notes

* The `custom_routes` variable enables clean and flexible definition of routing logic per route table type.
* `use_only = true` disables default NAT/IGW routing and ensures only custom routes are used for internal VPC private subnets.
* This pattern allows the internal VPC to access the internet via the DMZ VPC, while remaining isolated from direct internet access.
* You can customize subnet CIDRs and availability zones as needed for your environment.
