# launch template

resource "aws_launch_template" "my_launch_template" {
  name          = "my-launch-template"
  description   = "My Launch Template"
  image_id      = "ami-0766f68f0b06ab145"
  instance_type = "t2.micro"


  # vpc_security_group_ids = [aws_security_group.security_group.id]

  network_interfaces {
    security_groups             = [aws_security_group.security_group.id]
    associate_public_ip_address = true
    delete_on_termination       = true
    subnet_id                   = aws_subnet.subnet[0].id
  }

  key_name = "demo1"
  #   user_data = filebase64("${path.module}/app1-install.sh")

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.app_name}-ec2-instance"
    }
  }
}

output "subnets" {
  value = aws_subnet.subnet
}