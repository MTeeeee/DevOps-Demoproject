# Create Auto Scaling Group for DevOps Project
# https://aws.plainenglish.io/provisioning-aws-infrastructure-using-terraform-vpc-private-subnet-alb-asg-118b82c585f2
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group

resource "aws_autoscaling_group" "DevOps-Project-ASG-WebServer" {
  #name_prefix      = "DevOps-Project-ASG-WebServer-"
  name                      = "DevOps-Project-ASG-WebServer"
  desired_capacity          = 2 
  max_size                  = 5
  min_size                  = 2
  force_delete              = true
  target_group_arns         = ["${aws_lb_target_group.DevOps-Project-Public-TG.arn}"]
  health_check_grace_period = 300
  health_check_type         = "EC2"

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
