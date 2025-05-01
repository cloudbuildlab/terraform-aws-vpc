output "availability_zones" {
  description = "List of availability zones used in the VPC"
  value       = var.availability_zones
}

output "database_route_table_ids" {
  description = "List of database route table IDs"
  value       = var.enable_route_tables ? try(aws_route_table.database[*].id, []) : []
}

output "database_subnet_cidrs" {
  description = "List of database subnet CIDR blocks"
  value       = aws_subnet.database[*].cidr_block
}

output "database_subnet_ids" {
  description = "List of database subnet IDs"
  value       = aws_subnet.database[*].id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = try(aws_internet_gateway.this[0].id, null)
}

output "isolated_route_table_ids" {
  description = "List of isolated route table IDs"
  value       = var.enable_route_tables ? try(aws_route_table.isolated[*].id, []) : []
}

output "isolated_subnet_cidrs" {
  description = "List of isolated subnet CIDR blocks"
  value       = aws_subnet.isolated[*].cidr_block
}

output "isolated_subnet_ids" {
  description = "List of isolated subnet IDs"
  value       = aws_subnet.isolated[*].id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = try(aws_nat_gateway.this[0].id, null)
}

output "nat_gateway_ips" {
  description = "List of NAT Gateway public IPs"
  value       = aws_nat_gateway.this[*].public_ip
}

output "nat_gateway_private_ip" {
  description = "The private IP address of the NAT Gateway"
  value       = try(aws_nat_gateway.this[0].private_ip, null)
}

output "private_route_table_ids" {
  description = "List of private route table IDs"
  value       = var.enable_route_tables ? aws_route_table.private[*].id : []
}

output "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  value       = aws_subnet.private[*].cidr_block
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "public_route_table_ids" {
  description = "List of public route table IDs"
  value       = var.enable_route_tables ? try(aws_route_table.public[*].id, []) : []
}

output "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  value       = aws_subnet.public[*].cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.this.arn
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "vpc_endpoint_dns_entries" {
  description = "Map of VPC endpoint DNS entries by service name"
  value = {
    s3             = try(aws_vpc_endpoint.s3[0].dns_entry, null)
    rds            = try(aws_vpc_endpoint.rds[0].dns_entry, null)
    logs           = try(aws_vpc_endpoint.logs[0].dns_entry, null)
    monitoring     = try(aws_vpc_endpoint.monitoring[0].dns_entry, null)
    ssm            = try(aws_vpc_endpoint.ssm[0].dns_entry, null)
    sqs            = try(aws_vpc_endpoint.sqs[0].dns_entry, null)
    sns            = try(aws_vpc_endpoint.sns[0].dns_entry, null)
    secretsmanager = try(aws_vpc_endpoint.secretsmanager[0].dns_entry, null)
    ecr_api        = try(aws_vpc_endpoint.ecr_api[0].dns_entry, null)
    ecr_dkr        = try(aws_vpc_endpoint.ecr_dkr[0].dns_entry, null)
    kms            = try(aws_vpc_endpoint.kms[0].dns_entry, null)
    ecs            = try(aws_vpc_endpoint.ecs[0].dns_entry, null)
  }
}

output "vpc_endpoint_ids" {
  description = "Map of VPC endpoint IDs by service name"
  value = {
    s3             = try(aws_vpc_endpoint.s3[0].id, null)
    rds            = try(aws_vpc_endpoint.rds[0].id, null)
    logs           = try(aws_vpc_endpoint.logs[0].id, null)
    monitoring     = try(aws_vpc_endpoint.monitoring[0].id, null)
    ssm            = try(aws_vpc_endpoint.ssm[0].id, null)
    sqs            = try(aws_vpc_endpoint.sqs[0].id, null)
    sns            = try(aws_vpc_endpoint.sns[0].id, null)
    secretsmanager = try(aws_vpc_endpoint.secretsmanager[0].id, null)
    ecr_api        = try(aws_vpc_endpoint.ecr_api[0].id, null)
    ecr_dkr        = try(aws_vpc_endpoint.ecr_dkr[0].id, null)
    kms            = try(aws_vpc_endpoint.kms[0].id, null)
    ecs            = try(aws_vpc_endpoint.ecs[0].id, null)
  }
}

output "vpc_endpoint_network_interface_ids" {
  description = "Map of VPC endpoint network interface IDs by service name"
  value = {
    rds            = try(aws_vpc_endpoint.rds[0].network_interface_ids, [])
    logs           = try(aws_vpc_endpoint.logs[0].network_interface_ids, [])
    monitoring     = try(aws_vpc_endpoint.monitoring[0].network_interface_ids, [])
    ssm            = try(aws_vpc_endpoint.ssm[0].network_interface_ids, [])
    sqs            = try(aws_vpc_endpoint.sqs[0].network_interface_ids, [])
    sns            = try(aws_vpc_endpoint.sns[0].network_interface_ids, [])
    secretsmanager = try(aws_vpc_endpoint.secretsmanager[0].network_interface_ids, [])
    ecr_api        = try(aws_vpc_endpoint.ecr_api[0].network_interface_ids, [])
    ecr_dkr        = try(aws_vpc_endpoint.ecr_dkr[0].network_interface_ids, [])
    kms            = try(aws_vpc_endpoint.kms[0].network_interface_ids, [])
    ecs            = try(aws_vpc_endpoint.ecs[0].network_interface_ids, [])
  }
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_ipv6_cidr" {
  description = "The IPv6 CIDR block of the VPC"
  value       = aws_vpc.this.ipv6_cidr_block
}
