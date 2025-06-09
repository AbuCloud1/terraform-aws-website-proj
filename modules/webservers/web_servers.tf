data "aws_ami" "amzlinux2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon
}

resource "aws_security_group" "ec2_security_group" {
  description = "Allow traffic for EC2 Webservers"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.sg_ingress_ports
    iterator = sg_ingress

    content {
      description = sg_ingress.value["description"]
      from_port   = sg_ingress.value["port"]
      to_port     = sg_ingress.value["port"]
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.environment}-sg-ngix"
    ManagedBy = "Terraform"
  }
}


resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-lt-"
  image_id      = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    security_groups = [aws_security_group.ec2_security_group.id]
    subnet_id       = null # Don't specify subnet here, will specify in ASG
  }

  user_data = base64encode(var.user_data)

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name      = "asg-nginx-instance"
      ManagedBy = "Terraform"
    }
  }
}
