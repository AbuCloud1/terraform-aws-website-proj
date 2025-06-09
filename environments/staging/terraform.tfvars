vpc_name             = "Main VPC"
region               = "eu-west-1"
vpc_cidr_block       = "10.0.0.0/16"
availability_zones   = ["eu-west-1a", "eu-west-1b"]
subnet_name          = "subnet"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

environment = "staging"
key_name    = "master-key"

instance_type = "t3.micro"
user_data     = <<-EOF
  #!/bin/bash
  sudo amazon-linux-extras install -y nginx1.12
  sudo systemctl start nginx
  sudo systemctl enable nginx
  EOF
