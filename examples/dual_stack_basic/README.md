# Dual-Stack VPC Example

This example demonstrates a basic dual-stack (IPv4 + IPv6) VPC configuration.

## Features

- VPC with IPv4 and IPv6 CIDR blocks
- Public and private subnets in 2 availability zones
- IPv6 CIDR blocks auto-assigned from VPC pool
- Internet Gateway for public subnets
- NAT Gateway for private subnets
- IPv6 routes configured automatically

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Outputs

- VPC ID and CIDR blocks (IPv4 and IPv6)
- Public and private subnet IDs
