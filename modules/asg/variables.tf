variable "vpc_zone_ids" {
  type = list(string)
}

variable "lt_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
}