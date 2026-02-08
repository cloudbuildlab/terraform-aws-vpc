# terraform-aws-vpc

Terraform module for provisioning a VPC with networking components

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_egress_only_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/egress_only_internet_gateway) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_network_acl.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.isolated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_route.private_ipv6_egress_only_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_ipv6_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
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
| [aws_security_group.logs_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.monitoring_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.rds_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.secretsmanager_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.sns_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.sqs_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ssm_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.isolated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_endpoint.ecr_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecr_dkr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.secretsmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_generated_ipv6_cidr_block"></a> [assign\_generated\_ipv6\_cidr\_block](#input\_assign\_generated\_ipv6\_cidr\_block) | Whether to assign AWS-generated IPv6 CIDR block to VPC. Ignored if ipv6\_cidr\_block is set. | `bool` | `true` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones (including Auckland) | `list(string)` | n/a | yes |
| <a name="input_create_igw"></a> [create\_igw](#input\_create\_igw) | Whether to create an Internet Gateway for public subnets | `bool` | `true` | no |
| <a name="input_custom_routes"></a> [custom\_routes](#input\_custom\_routes) | Custom routes configuration per route table type | <pre>object({<br/>    public = optional(object({<br/>      use_only = bool<br/>      routes = list(object({<br/>        cidr_block                = string<br/>        gateway_id                = optional(string)<br/>        nat_gateway_id            = optional(string)<br/>        network_interface_id      = optional(string)<br/>        transit_gateway_id        = optional(string)<br/>        vpc_peering_connection_id = optional(string)<br/>      }))<br/>    }), null)<br/>    private = optional(object({<br/>      use_only = bool<br/>      routes = list(object({<br/>        cidr_block                = string<br/>        gateway_id                = optional(string)<br/>        nat_gateway_id            = optional(string)<br/>        network_interface_id      = optional(string)<br/>        transit_gateway_id        = optional(string)<br/>        vpc_peering_connection_id = optional(string)<br/>      }))<br/>    }), null)<br/>    isolated = optional(object({<br/>      use_only = bool<br/>      routes = list(object({<br/>        cidr_block                = string<br/>        gateway_id                = optional(string)<br/>        nat_gateway_id            = optional(string)<br/>        network_interface_id      = optional(string)<br/>        transit_gateway_id        = optional(string)<br/>        vpc_peering_connection_id = optional(string)<br/>      }))<br/>    }), null)<br/>    database = optional(object({<br/>      use_only = bool<br/>      routes = list(object({<br/>        cidr_block                = string<br/>        gateway_id                = optional(string)<br/>        nat_gateway_id            = optional(string)<br/>        network_interface_id      = optional(string)<br/>        transit_gateway_id        = optional(string)<br/>        vpc_peering_connection_id = optional(string)<br/>      }))<br/>    }), null)<br/>  })</pre> | `{}` | no |
| <a name="input_database_subnet_cidrs"></a> [database\_subnet\_cidrs](#input\_database\_subnet\_cidrs) | CIDR blocks for database subnets (one per AZ) | `list(string)` | `[]` | no |
| <a name="input_database_subnet_ipv6_cidrs"></a> [database\_subnet\_ipv6\_cidrs](#input\_database\_subnet\_ipv6\_cidrs) | IPv6 CIDR blocks for database subnets. Must match number of availability\_zones. | `list(string)` | `[]` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of the EKS cluster for subnet tagging | `string` | `""` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Whether to enable DNS hostnames in the VPC | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Whether to enable DNS support in the VPC | `bool` | `true` | no |
| <a name="input_enable_ecr_api_endpoint"></a> [enable\_ecr\_api\_endpoint](#input\_enable\_ecr\_api\_endpoint) | Whether to enable ECR API VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_ecr_dkr_endpoint"></a> [enable\_ecr\_dkr\_endpoint](#input\_enable\_ecr\_dkr\_endpoint) | Whether to enable ECR DKR VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_ecs_endpoint"></a> [enable\_ecs\_endpoint](#input\_enable\_ecs\_endpoint) | Whether to enable ECS VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_eks_tags"></a> [enable\_eks\_tags](#input\_enable\_eks\_tags) | Whether to add EKS-specific tags to public and private subnets | `bool` | `false` | no |
| <a name="input_enable_interface_endpoints"></a> [enable\_interface\_endpoints](#input\_enable\_interface\_endpoints) | Whether to enable interface VPC endpoints | `bool` | `false` | no |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Whether to enable IPv6 support | `bool` | `false` | no |
| <a name="input_enable_kms_endpoint"></a> [enable\_kms\_endpoint](#input\_enable\_kms\_endpoint) | Whether to enable KMS VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_logs_endpoint"></a> [enable\_logs\_endpoint](#input\_enable\_logs\_endpoint) | Whether to enable CloudWatch Logs VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_monitoring_endpoint"></a> [enable\_monitoring\_endpoint](#input\_enable\_monitoring\_endpoint) | Whether to enable CloudWatch Monitoring VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_nacls"></a> [enable\_nacls](#input\_enable\_nacls) | Whether to create default Network ACLs for subnets. Set to false to manage NACLs outside the module. | `bool` | `true` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Whether to create NAT Gateway for private subnets | `bool` | `true` | no |
| <a name="input_enable_rds_endpoint"></a> [enable\_rds\_endpoint](#input\_enable\_rds\_endpoint) | Whether to enable RDS VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_route_tables"></a> [enable\_route\_tables](#input\_enable\_route\_tables) | Whether to create and configure route tables for subnets | `bool` | `true` | no |
| <a name="input_enable_s3_endpoint"></a> [enable\_s3\_endpoint](#input\_enable\_s3\_endpoint) | Whether to enable S3 VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_secretsmanager_endpoint"></a> [enable\_secretsmanager\_endpoint](#input\_enable\_secretsmanager\_endpoint) | Whether to enable Secrets Manager VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_sns_endpoint"></a> [enable\_sns\_endpoint](#input\_enable\_sns\_endpoint) | Whether to enable SNS VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_sqs_endpoint"></a> [enable\_sqs\_endpoint](#input\_enable\_sqs\_endpoint) | Whether to enable SQS VPC endpoint | `bool` | `false` | no |
| <a name="input_enable_ssm_endpoint"></a> [enable\_ssm\_endpoint](#input\_enable\_ssm\_endpoint) | Whether to enable Systems Manager VPC endpoint | `bool` | `false` | no |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | A tenancy option for instances launched into the VPC | `string` | `"default"` | no |
| <a name="input_interface_endpoints"></a> [interface\_endpoints](#input\_interface\_endpoints) | List of interface endpoints to enable | `list(string)` | `[]` | no |
| <a name="input_ipv6_cidr_block"></a> [ipv6\_cidr\_block](#input\_ipv6\_cidr\_block) | IPv6 CIDR block for VPC. Note: This requires IPAM configuration. For custom IPv6 CIDRs without IPAM, use aws\_vpc\_ipv6\_cidr\_block\_association resource separately. If not provided and enable\_ipv6=true, AWS will auto-assign via assign\_generated\_ipv6\_cidr\_block. | `string` | `null` | no |
| <a name="input_isolated_subnet_cidrs"></a> [isolated\_subnet\_cidrs](#input\_isolated\_subnet\_cidrs) | CIDR blocks for isolated subnets (one per AZ) | `list(string)` | `[]` | no |
| <a name="input_isolated_subnet_ipv6_cidrs"></a> [isolated\_subnet\_ipv6\_cidrs](#input\_isolated\_subnet\_ipv6\_cidrs) | IPv6 CIDR blocks for isolated subnets. Must match number of availability\_zones. | `list(string)` | `[]` | no |
| <a name="input_nat_gateway_type"></a> [nat\_gateway\_type](#input\_nat\_gateway\_type) | NAT Gateway deployment type. 'single' for one NAT Gateway, 'one\_per\_az' for high availability | `string` | `"single"` | no |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | CIDR blocks for private subnets (one per AZ) | `list(string)` | `[]` | no |
| <a name="input_private_subnet_ipv6_cidrs"></a> [private\_subnet\_ipv6\_cidrs](#input\_private\_subnet\_ipv6\_cidrs) | IPv6 CIDR blocks for private subnets. Must match number of availability\_zones. | `list(string)` | `[]` | no |
| <a name="input_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#input\_public\_subnet\_cidrs) | CIDR blocks for public subnets (one per AZ) | `list(string)` | `[]` | no |
| <a name="input_public_subnet_ipv6_cidrs"></a> [public\_subnet\_ipv6\_cidrs](#input\_public\_subnet\_ipv6\_cidrs) | IPv6 CIDR blocks for public subnets. Must match number of availability\_zones. | `list(string)` | `[]` | no |
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
| <a name="output_database_subnet_ipv6_cidrs"></a> [database\_subnet\_ipv6\_cidrs](#output\_database\_subnet\_ipv6\_cidrs) | List of IPv6 CIDR blocks for database subnets |
| <a name="output_egress_only_internet_gateway_id"></a> [egress\_only\_internet\_gateway\_id](#output\_egress\_only\_internet\_gateway\_id) | The ID of the Egress-Only Internet Gateway (for IPv6) |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | The ID of the Internet Gateway |
| <a name="output_isolated_route_table_ids"></a> [isolated\_route\_table\_ids](#output\_isolated\_route\_table\_ids) | List of isolated route table IDs |
| <a name="output_isolated_subnet_cidrs"></a> [isolated\_subnet\_cidrs](#output\_isolated\_subnet\_cidrs) | List of isolated subnet CIDR blocks |
| <a name="output_isolated_subnet_ids"></a> [isolated\_subnet\_ids](#output\_isolated\_subnet\_ids) | List of isolated subnet IDs |
| <a name="output_isolated_subnet_ipv6_cidrs"></a> [isolated\_subnet\_ipv6\_cidrs](#output\_isolated\_subnet\_ipv6\_cidrs) | List of IPv6 CIDR blocks for isolated subnets |
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id) | The ID of the NAT Gateway |
| <a name="output_nat_gateway_ip"></a> [nat\_gateway\_ip](#output\_nat\_gateway\_ip) | The public IP of the NAT Gateway |
| <a name="output_nat_gateway_private_ip"></a> [nat\_gateway\_private\_ip](#output\_nat\_gateway\_private\_ip) | The private IP address of the NAT Gateway |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | List of private route table IDs |
| <a name="output_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#output\_private\_subnet\_cidrs) | List of private subnet CIDR blocks |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | List of private subnet IDs |
| <a name="output_private_subnet_ipv6_cidrs"></a> [private\_subnet\_ipv6\_cidrs](#output\_private\_subnet\_ipv6\_cidrs) | List of IPv6 CIDR blocks for private subnets |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | List of public route table IDs |
| <a name="output_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#output\_public\_subnet\_cidrs) | List of public subnet CIDR blocks |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | List of public subnet IDs |
| <a name="output_public_subnet_ipv6_cidrs"></a> [public\_subnet\_ipv6\_cidrs](#output\_public\_subnet\_ipv6\_cidrs) | List of IPv6 CIDR blocks for public subnets |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | The ARN of the VPC |
| <a name="output_vpc_cidr"></a> [vpc\_cidr](#output\_vpc\_cidr) | The CIDR block of the VPC |
| <a name="output_vpc_endpoint_dns_entries"></a> [vpc\_endpoint\_dns\_entries](#output\_vpc\_endpoint\_dns\_entries) | Map of VPC endpoint DNS entries by service name |
| <a name="output_vpc_endpoint_ids"></a> [vpc\_endpoint\_ids](#output\_vpc\_endpoint\_ids) | Map of VPC endpoint IDs by service name |
| <a name="output_vpc_endpoint_network_interface_ids"></a> [vpc\_endpoint\_network\_interface\_ids](#output\_vpc\_endpoint\_network\_interface\_ids) | Map of VPC endpoint network interface IDs by service name |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpc_ipv6_cidr"></a> [vpc\_ipv6\_cidr](#output\_vpc\_ipv6\_cidr) | The IPv6 CIDR block of the VPC |
<!-- END_TF_DOCS -->
