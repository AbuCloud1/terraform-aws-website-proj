resource "aws_lb" "alb" {
  name               = "${var.environment}-app-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.aws-sg-load-balancer.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name      = "${var.environment}-app-lb-tf"
    ManagedBy = "Terraform"
  }
}


resource "aws_security_group" "aws-sg-load-balancer" {
  description = "Allow incoming connections for load balancer"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-alb-sg"
  }
}


resource "aws_lb_target_group" "alb_target_group" {
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name      = "${var.environment}-app-lb-target-group-tf"
    ManagedBy = "Terraform"
  }
}

resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.alb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.id
  }
}


