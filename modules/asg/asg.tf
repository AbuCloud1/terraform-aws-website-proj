resource "aws_autoscaling_group" "web_asg" {
  name                = "${var.environment}-web-asg"
  max_size            = 6
  min_size            = 2
  desired_capacity    = 2
  vpc_zone_identifier = var.vpc_zone_ids

  launch_template {
    id      = var.lt_id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "${var.environment}-Name"
    value               = "asg-nginx-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_out_cpu" {
  alarm_name          = "${var.environment}-scale-out-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2 # Check over 2 periods (e.g., 2 minutes)
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60 # 1-minute granularity
  statistic           = "Average"
  threshold           = 70 # Scale out when avg CPU > 70%
  alarm_description   = "Scale out when CPU utilization > 70% for 2 minutes"
  alarm_actions       = [aws_autoscaling_policy.scale_out_policy.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_in_cpu" {
  alarm_name          = "${var.environment}-scale-in-cpu"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 5 # Check over 5 periods (e.g., 5 minutes)
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60 # 1-minute granularity
  statistic           = "Average"
  threshold           = 30 # Scale in when avg CPU < 30%
  alarm_description   = "Scale in when CPU utilization < 30% for 5 minutes"
  alarm_actions       = [aws_autoscaling_policy.scale_in_policy.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}


resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "${var.environment}-scale-out-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300 # 5 minutes cooldown
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "${var.environment}-scale-in-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 600 # 10 minutes cooldown
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}
