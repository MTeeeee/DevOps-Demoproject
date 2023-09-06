# Create Security Group for DevOps Project

resource "aws_security_group" "DevOps-Project-SG" {
  name = "DevOps-Project-SQ"
  description = "Allow HTTP/HTTPS and SSH Traffic via Terraform"
  vpc_id = aws_vpc.DevOps-Project-VPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DevOps-Project-SG"
    Terraform = "true"
    Environment = "dev"
  }
}