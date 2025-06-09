
variable "vpc_cidr_block" {
  type    = string
  default = ""
}

variable "availability_zones" {
  description = "List of Availability Zones to deploy subnets into"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}

variable "subnet_name" {
  description = "Base name for the subnets"
  type        = string
}

