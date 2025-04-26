output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.this.arn
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "vpc_ipv6_cidr" {
  description = "The IPv6 CIDR block of the VPC"
  value       = aws_vpc.this.ipv6_cidr_block
}

output "availability_zones" {
  description = "List of availability zones used in the VPC"
  value       = var.availability_zones
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "isolated_subnet_ids" {
  description = "List of isolated subnet IDs"
  value       = aws_subnet.isolated[*].id
}

output "database_subnet_ids" {
  description = "List of database subnet IDs"
  value       = aws_subnet.database[*].id
}

output "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  value       = aws_subnet.private[*].cidr_block
}

output "isolated_subnet_cidrs" {
  description = "List of isolated subnet CIDR blocks"
  value       = aws_subnet.isolated[*].cidr_block
}

output "database_subnet_cidrs" {
  description = "List of database subnet CIDR blocks"
  value       = aws_subnet.database[*].cidr_block
}

output "nat_gateway_ips" {
  description = "List of NAT Gateway public IPs"
  value       = aws_nat_gateway.this[*].public_ip
} 