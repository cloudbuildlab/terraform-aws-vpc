variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must be a valid IPv4 CIDR block."
  }
}

variable "availability_zones" {
  description = "List of availability zones (including Auckland)"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) > 0
    error_message = "At least one availability zone must be specified."
  }
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"

  validation {
    condition     = contains(["default", "dedicated"], var.instance_tenancy)
    error_message = "Instance tenancy must be either 'default' or 'dedicated'."
  }
}

variable "enable_ipv6" {
  description = "Whether to enable IPv6 support"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Whether to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Whether to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "vpc_type" {
  description = "Type of VPC to create. Allowed values: 'internal' (no public subnets, no NAT Gateway), 'dmz' (public subnets and NAT Gateway allowed)."
  type        = string
  default     = "dmz"

  validation {
    condition     = contains(["internal", "dmz"], var.vpc_type)
    error_message = "vpc_type must be either 'internal' or 'dmz'."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.public_subnet_cidrs) > 0 || var.enable_nat_gateway == false
    error_message = "You must provide at least one public subnet CIDR if NAT Gateway is enabled."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (one per AZ)"
  type        = list(string)
  default     = []
}

variable "isolated_subnet_cidrs" {
  description = "CIDR blocks for isolated subnets (one per AZ)"
  type        = list(string)
  default     = []
}

variable "database_subnet_cidrs" {
  description = "CIDR blocks for database subnets (one per AZ)"
  type        = list(string)
  default     = []
}

variable "create_igw" {
  description = "Whether to create an Internet Gateway for public subnets"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "nat_gateway_type" {
  description = "NAT Gateway deployment type. 'single' for one NAT Gateway, 'one_per_az' for high availability"
  type        = string
  default     = "single"

  validation {
    condition     = contains(["single", "one_per_az"], var.nat_gateway_type)
    error_message = "NAT Gateway type must be either 'single' or 'one_per_az'."
  }
}

variable "enable_s3_endpoint" {
  description = "Whether to enable S3 VPC endpoint"
  type        = bool
  default     = false
}

variable "enable_rds_endpoint" {
  description = "Whether to enable RDS VPC endpoint"
  type        = bool
  default     = false
}

variable "enable_logs_endpoint" {
  description = "Whether to enable CloudWatch Logs VPC endpoint"
  type        = bool
  default     = false
}

variable "enable_monitoring_endpoint" {
  description = "Whether to enable CloudWatch Monitoring VPC endpoint"
  type        = bool
  default     = false
}

variable "enable_ssm_endpoint" {
  description = "Whether to enable Systems Manager VPC endpoint"
  type        = bool
  default     = false
}

variable "enable_interface_endpoints" {
  description = "Whether to enable interface VPC endpoints"
  type        = bool
  default     = false
}

variable "interface_endpoints" {
  description = "List of interface endpoints to enable"
  type        = list(string)
  default     = []
}

variable "enable_sqs_endpoint" {
  description = "Whether to enable SQS VPC endpoint"
  type        = bool
  default     = false
}

variable "enable_sns_endpoint" {
  description = "Whether to enable SNS VPC endpoint"
  type        = bool
  default     = false
}

variable "enable_secretsmanager_endpoint" {
  description = "Whether to enable Secrets Manager VPC endpoint"
  type        = bool
  default     = false
}

variable "enable_ecr_api_endpoint" {
  description = "Whether to enable ECR API VPC endpoint"
  type        = bool
  default     = false
}

variable "enable_ecr_dkr_endpoint" {
  description = "Whether to enable ECR DKR VPC endpoint"
  type        = bool
  default     = false
}

variable "enable_kms_endpoint" {
  description = "Whether to enable KMS VPC endpoint"
  type        = bool
  default     = false
}

variable "enable_ecs_endpoint" {
  description = "Whether to enable ECS VPC endpoint"
  type        = bool
  default     = false
}

variable "enable_nacls" {
  description = "Whether to create default Network ACLs for subnets. Set to false to manage NACLs outside the module."
  type        = bool
  default     = true
}
