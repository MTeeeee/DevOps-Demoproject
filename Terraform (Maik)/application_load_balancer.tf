# Create Aplication Load Balancer
resource "aws_alb" "DevOps-Project-Public-ALB" {
  #internal = false
  load_balancer_type = "application"
  subnets = [ aws_subnet.DevOps-Project-SubNet-1.id, aws_subnet.DevOps-Project-SubNet-2.id, aws_subnet.DevOps-Project-SubNet-3.id ]
  security_groups = [ aws_security_group.DevOps-Project-SG.id ]
  ip_address_type = "ipv4"

  tags = {
    Name = "DevOps-Project-Public-ALB"
    Terraform   = "true"
    Environment = "dev"
  }
}

# Create Target Group
# resource "aws_lb_target_group" "DevOps-Project-Public-TG" {
#   target_type = "instance"
#   port = 80
#   protocol = "HTTP"
#   vpc_id = aws_vpc.DevOps-Project-VPC.id
#   depends_on = [ aws_vpc.DevOps-Project-VPC.main ]
#   #vpc_id = "DevOps-Project-VPC"
  

#   health_check {
#     healthy_threshold   = "3"
#     interval            = "90"
#     protocol            = "HTTP"
#     matcher             = "200"
#     timeout             = "3"
#     path                = "/v1/status"
#     unhealthy_threshold = "2"
#   }

#   tags = {
#     Name = "DevOps-Project-Public-TG"
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }

# Create Listener
resource "aws_lb_listener" "DevOps-Project-Public-Listener" {
  load_balancer_arn = aws_alb.DevOps-Project-Public-ALB.id
  port = "80"
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.DevOps-Project-Public-TG.id
    type = "forward"
  }
}

# # Attaching the required EC2 Instances
# resource "aws_lb_target_group_attachment" "DevOps-Project-Public-TG-EC2-Attachment" {
#   target_group_arn = aws_lb_target_group.DevOps-Project-Public-TG.arn
#   target_id = "HIER GEHT ES WEITER"
#   port = "80"
# }