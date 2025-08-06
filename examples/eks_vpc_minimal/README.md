# Minimal EKS VPC Configuration

This example demonstrates the **absolute minimum** VPC configuration needed for Amazon EKS.

## Features

- **EKS Subnet Tagging**: Automatically adds EKS-specific tags to public and private subnets
- **No VPC Endpoints**: Minimal configuration for testing/development
- **Multi-AZ Setup**: Creates subnets across 2 availability zones (minimal HA)
- **NAT Gateway**: Provides internet access for private subnets

## EKS Tags Added

When `enable_eks_tags = true`, the following tags are added to **public and private subnets only**:

- `kubernetes.io/role/internal-elb = "1"`: Indicates the subnet can be used for internal load balancers
- `kubernetes.io/cluster/{cluster_name} = "shared"`: Indicates the subnet is shared with the EKS cluster

## Usage

```bash
cd examples/eks_vpc_minimal
terraform init
terraform plan
terraform apply
```

## Cleanup

```bash
terraform destroy
```

## Note

This configuration is suitable for testing and development. For production workloads, consider using the recommended configuration with VPC endpoints.
