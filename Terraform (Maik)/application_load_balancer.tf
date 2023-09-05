# Create Aplication Load Balancer
resource "aws_alb" "DevOps-Project-Public-ALB" {
  #internal = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.DevOps-Project-SubNet-1.id, aws_subnet.DevOps-Project-SubNet-2.id, aws_subnet.DevOps-Project-SubNet-3.id]
  security_groups    = [aws_security_group.DevOps-Project-SG.id]
  ip_address_type    = "ipv4"

  tags = {
    Name        = "DevOps-Project-Public-ALB"
    Terraform   = "true"
    Environment = "dev"
  }
}

# Create Listener
resource "aws_lb_listener" "DevOps-Project-Public-Listener" {
  load_balancer_arn = aws_alb.DevOps-Project-Public-ALB.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.DevOps-Project-Public-TG.id
    type             = "forward"
  }
}

# # Attaching the required EC2 Instances
# resource "aws_lb_target_group_attachment" "DevOps-Project-Public-TG-EC2-Attachment" {

#   #count = length(aws_autoscaling_group.example.names)
#   #count = length(aws_autoscaling_group.DevOps-Project-ASG-WebServer-.names)

#   #depends_on = [aws_autoscaling_group.DevOps-Project-ASG-WebServer-]
#   target_group_arn = aws_lb_target_group.DevOps-Project-Public-TG.arn

#   #target_id        = aws_autoscaling_group.example.names[count.index]

#   port             = "80"
# }

