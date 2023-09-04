# Auto Scaling Group
# https://aws.plainenglish.io/provisioning-aws-infrastructure-using-terraform-vpc-private-subnet-alb-asg-118b82c585f2

resource "aws_autoscaling_group" "DevOps-Project-ASG" {
  name             = "DevOps-Project-ASG"
  desired_capacity = 1
  max_size         = 2
  min_size         = 1
  force_delete     = true
  #
  #depends_on        = [aws_alb.DevOps-Project-Public-ALB]
  #target_group_arns = "${aws_alb.DevOps-Project-Public-ALB}"
  target_group_arns = [aws_alb.DevOps-Project-Public-ALB.arn]
  #
  health_check_type    = "EC2"
  launch_configuration = aws_launch_template.DevOps-Project-WebServer-Launch-Template.name
  vpc_zone_identifier  = ["${aws_subnet.DevOps-Project-SubNet-1.id}", "${aws_subnet.DevOps-Project-SubNet-2.id}", "${aws_subnet.DevOps-Project-SubNet-3.id}"]

  tag {
    key                 = "Name"
    value               = "DevOps-Project-ASG"
    propagate_at_launch = true
  }
}
