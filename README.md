# terraform-aws-vpc

Terraform module for provisioning a VPC with networking components

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.96.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_network_acl.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.isolated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_route_table.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.isolated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.isolated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.ecr_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ecs_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.kms_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.rds_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.secretsmanager_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.sns_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.sqs_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.isolated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_endpoint.ecr_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecr_dkr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.secretsmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones (including Auckland) | `list(string)` | n/a | yes |
| <a name="input_create_igw"></a> [create\_igw](#input\_create\_igw) | Whether to create an Internet Gateway for public subnets | `bool` | `true` | no |
| <a name="input_database_subnet_cidrs"></a> [database\_subnet\_cidrs](#input\_database\_subnet\_cidrs) | CIDR blocks for database subnets (one per AZ) | `list(string)` | `[]` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Whether to enable DNS hostnames in the VPC | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Whether to enable DNS support in the VPC | `bool` | `true` | no |
| <a name="input_enable_ecr_api_endpoint"></a> [enable\_ecr\_api\_endpoint](#input\_enable\_ecr\_api\_endpoint) | Whether to enable ECR API VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_ecr_dkr_endpoint"></a> [enable\_ecr\_dkr\_endpoint](#input\_enable\_ecr\_dkr\_endpoint) | Whether to enable ECR DKR VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_ecs_endpoint"></a> [enable\_ecs\_endpoint](#input\_enable\_ecs\_endpoint) | Whether to enable ECS VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_interface_endpoints"></a> [enable\_interface\_endpoints](#input\_enable\_interface\_endpoints) | Whether to enable interface VPC endpoints | `bool` | `false` | no |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Whether to enable IPv6 support | `bool` | `true` | no |
| <a name="input_enable_kms_endpoint"></a> [enable\_kms\_endpoint](#input\_enable\_kms\_endpoint) | Whether to enable KMS VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_logs_endpoint"></a> [enable\_logs\_endpoint](#input\_enable\_logs\_endpoint) | Whether to enable CloudWatch Logs VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_monitoring_endpoint"></a> [enable\_monitoring\_endpoint](#input\_enable\_monitoring\_endpoint) | Whether to enable CloudWatch Monitoring VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Whether to create NAT Gateway for private subnets | `bool` | `true` | no |
| <a name="input_enable_rds_endpoint"></a> [enable\_rds\_endpoint](#input\_enable\_rds\_endpoint) | Whether to enable RDS VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_s3_endpoint"></a> [enable\_s3\_endpoint](#input\_enable\_s3\_endpoint) | Whether to enable S3 VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_secretsmanager_endpoint"></a> [enable\_secretsmanager\_endpoint](#input\_enable\_secretsmanager\_endpoint) | Whether to enable Secrets Manager VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_sns_endpoint"></a> [enable\_sns\_endpoint](#input\_enable\_sns\_endpoint) | Whether to enable SNS VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_sqs_endpoint"></a> [enable\_sqs\_endpoint](#input\_enable\_sqs\_endpoint) | Whether to enable SQS VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_ssm_endpoint"></a> [enable\_ssm\_endpoint](#input\_enable\_ssm\_endpoint) | Whether to enable Systems Manager VPC endpoint | `bool` | `false` | no |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | A tenancy option for instances launched into the VPC | `string` | `"default"` | no |
| <a name="input_interface_endpoints"></a> [interface\_endpoints](#input\_interface\_endpoints) | List of interface endpoints to enable | `list(string)` | `[]` | no |
| <a name="input_isolated_subnet_cidrs"></a> [isolated\_subnet\_cidrs](#input\_isolated\_subnet\_cidrs) | CIDR blocks for isolated subnets (one per AZ) | `list(string)` | `[]` | no |
| <a name="input_nat_gateway_type"></a> [nat\_gateway\_type](#input\_nat\_gateway\_type) | NAT Gateway deployment type. 'single' for one NAT Gateway, 'one\_per\_az' for high availability | `string` | `"single"` | no |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | CIDR blocks for private subnets (one per AZ) | `list(string)` | `[]` | no |
| <a name="input_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#input\_public\_subnet\_cidrs) | CIDR blocks for public subnets (one per AZ) | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the VPC | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name tag for the VPC | `string` | n/a | yes |
| <a name="input_vpc_type"></a> [vpc\_type](#input\_vpc\_type) | Type of VPC to create. Allowed values: 'internal' (no public subnets, no NAT Gateway), 'dmz' (public subnets and NAT Gateway allowed). | `string` | `"dmz"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_zones"></a> [availability\_zones](#output\_availability\_zones) | List of availability zones used in the VPC |
| <a name="output_database_route_table_ids"></a> [database\_route\_table\_ids](#output\_database\_route\_table\_ids) | List of database route table IDs |
| <a name="output_database_subnet_cidrs"></a> [database\_subnet\_cidrs](#output\_database\_subnet\_cidrs) | List of database subnet CIDR blocks |
| <a name="output_database_subnet_ids"></a> [database\_subnet\_ids](#output\_database\_subnet\_ids) | List of database subnet IDs |
| <a name="output_isolated_route_table_ids"></a> [isolated\_route\_table\_ids](#output\_isolated\_route\_table\_ids) | List of isolated route table IDs |
| <a name="output_isolated_subnet_cidrs"></a> [isolated\_subnet\_cidrs](#output\_isolated\_subnet\_cidrs) | List of isolated subnet CIDR blocks |
| <a name="output_isolated_subnet_ids"></a> [isolated\_subnet\_ids](#output\_isolated\_subnet\_ids) | List of isolated subnet IDs |
| <a name="output_nat_gateway_ips"></a> [nat\_gateway\_ips](#output\_nat\_gateway\_ips) | List of NAT Gateway public IPs |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | List of private route table IDs |
| <a name="output_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#output\_private\_subnet\_cidrs) | List of private subnet CIDR blocks |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | List of private subnet IDs |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | List of public route table IDs |
| <a name="output_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#output\_public\_subnet\_cidrs) | List of public subnet CIDR blocks |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | List of public subnet IDs |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | The ARN of the VPC |
| <a name="output_vpc_cidr"></a> [vpc\_cidr](#output\_vpc\_cidr) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpc_ipv6_cidr"></a> [vpc\_ipv6\_cidr](#output\_vpc\_ipv6\_cidr) | The IPv6 CIDR block of the VPC |
<!-- END_TF_DOCS -->
