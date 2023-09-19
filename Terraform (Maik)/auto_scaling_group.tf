# Create Auto Scaling Group for DevOps Project
# https://aws.plainenglish.io/provisioning-aws-infrastructure-using-terraform-vpc-private-subnet-alb-asg-118b82c585f2
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group

resource "aws_autoscaling_group" "DevOps-Project-ASG-WebServer" {
  name                      = "DevOps-Project-ASG-WebServer"
  desired_capacity          = 2
  max_size                  = 5
  min_size                  = 2
  force_delete              = true
  target_group_arns         = ["${aws_lb_target_group.DevOps-Project-Public-TG.arn}"]
  health_check_grace_period = 300
  health_check_type         = "EC2"
  default_cooldown          = 300

  launch_template {
    id      = aws_launch_template.DevOps-Project-WebServer-Launch-Template.id
    version = "$Latest"
  }

  vpc_zone_identifier = ["${aws_subnet.DevOps-Project-SubNet-1.id}", "${aws_subnet.DevOps-Project-SubNet-2.id}", "${aws_subnet.DevOps-Project-SubNet-3.id}"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "DevOps-Project-WebServer"
    propagate_at_launch = true
  }
}

# Create Auto Scaling Group Policy
resource "aws_autoscaling_policy" "DevOps-Project-ASG-Policy-START" {
  name               = "DevOps-Project-ASG-Policy-START"
  scaling_adjustment = 1
  adjustment_type    = "ChangeInCapacity"
  cooldown           = 60

  autoscaling_group_name = aws_autoscaling_group.DevOps-Project-ASG-WebServer.name
}

resource "aws_autoscaling_policy" "DevOps-Project-ASG-Policy-STOP" {
  name               = "DevOps-Project-ASG-Policy-STOP"
  scaling_adjustment = -1
  adjustment_type    = "ChangeInCapacity"
  cooldown           = 60

  autoscaling_group_name = aws_autoscaling_group.DevOps-Project-ASG-WebServer.name
}

# Create AWS Cloudwatch Metrics Alarme
# Alarm 1: CPU Utilization HIGH (Over 80%)
resource "aws_cloudwatch_metric_alarm" "DevOps-Project-CW-Metric-Alarm-CPU-HIGH" {
  alarm_name          = "DevOps-Project-CW-Metric-Alarm-CPU-HIGH"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "CPU Utilization is greater than or equal to 80%"

  alarm_actions = [aws_autoscaling_policy.DevOps-Project-ASG-Policy-START.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.DevOps-Project-ASG-WebServer.name
  }
}

# Alarm 2: CPU Utilization NORMAL (Under 80%)
resource "aws_cloudwatch_metric_alarm" "DevOps-Project-CW-Metric-Alarm-CPU-LOW" {
  alarm_name          = "DevOps-Project-CW-Metric-Alarm-CPU-LOW"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 5
  alarm_description   = "CPU Utilization is less than 80%"

  alarm_actions = [aws_autoscaling_policy.DevOps-Project-ASG-Policy-STOP.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.DevOps-Project-ASG-WebServer.name
  }
}