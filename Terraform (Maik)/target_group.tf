# Create Target Group for DevOps Project

resource "aws_lb_target_group" "DevOps-Project-Public-TG" {
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.DevOps-Project-VPC.id

  health_check {
    healthy_threshold   = "3"
    interval            = "90"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "DevOps-Project-Public-TG"
    Terraform   = "true"
    Environment = "dev"
  }
}
