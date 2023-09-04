# EC2 Launch Template
resource "aws_launch_template" "DevOps-Project-WebServer-Launch-Template" {
  name                   = "DevOps-Project-WebServer-Launch-Template"
  image_id               = "ami-0766f68f0b06ab145"
  instance_type          = "t2.micro"
  key_name               = "DevOps-Project-Key"
  vpc_security_group_ids = ["${aws_security_group.DevOps-Project-SG.id}"]

  user_data = filebase64("init.sh")

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 8
    }
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
