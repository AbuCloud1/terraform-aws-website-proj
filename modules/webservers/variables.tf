variable "vpc_id" {
  type = string
}

variable "availability_zones" {
  default = ["eu-west-1a", "eu-west-1b"]
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "sg_ingress_ports" {
  type = list(object({
    description = string
    port        = number
  }))
  default = [
    {
      description = "Allows HTTP traffic"
      port        = 80
    },
  ]
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 Key pair name"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
}

variable "user_data" {
  description = "User data script to bootstrap EC2"
  type        = string
  default     = <<-EOF
    #!/bin/bash
    sudo amazon-linux-extras install -y nginx1.12
    sudo systemctl start nginx
    sudo systemctl enable nginx
  EOF
}
