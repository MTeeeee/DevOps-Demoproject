# Create EC2 Launch Template for DevOps Project
# https://github.com/hashicorp/terraform-provider-aws/issues/19911

resource "aws_launch_template" "DevOps-Project-WebServer-Launch-Template" {
  name          = "DevOps-Project-WebServer-Launch-Template"
  image_id      = "ami-0766f68f0b06ab145"
  instance_type = "t2.micro"
  key_name      = "DevOps-Project-Key"

  iam_instance_profile {
    name = aws_iam_instance_profile.EC2toS3-Profile.name
  }

  user_data = filebase64("init.sh")

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 15
      volume_type = "gp3"
      iops        = 3000
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [aws_security_group.DevOps-Project-SG.id]
    subnet_id                   = aws_subnet.DevOps-Project-SubNet-1.id
  }

  metadata_options {
    http_protocol_ipv6          = "disabled"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "optional"
    instance_metadata_tags      = "enabled"
  }

  lifecycle {
    create_before_destroy = true
  }

  monitoring {
    enabled = true
  }
}
