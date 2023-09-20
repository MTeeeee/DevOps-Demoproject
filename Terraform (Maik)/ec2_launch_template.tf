# Create EC2 Launch Template for DevOps Project
resource "aws_launch_template" "DevOps-Project-WebServer-Launch-Template" {
  name          = "DevOps-Project-WebServer-Launch-Template"
  image_id      = "ami-0b9094fa2b07038b8"
  instance_type = "t2.micro"
  key_name      = "DevOps-Project-Key"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_iam_instance_profile.name
  }

  #depends_on = [aws_instance.DevOps-Project-EC2-PostgreSQL] # <--BITTE BEACHTEN / EVTL LÖSCHEN BEI PROBLEMEN
  #depends_on = [aws_instance.DevOps-Project-EC2-Backend] # <--BITTE BEACHTEN / EVTL LÖSCHEN BEI PROBLEMEN
  #user_data  = filebase64("init-ec2-webserver.sh")
  user_data = base64encode(templatefile("init-ec2-webserver.sh.tpl", { ip_address_backend = aws_instance.DevOps-Project-EC2-Backend.public_ip }))

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

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "DevOps-Project-WebServer"
      Environment = "dev"
      Terraform   = "true"
    }
  }
}

# Create Network Interface and start EC2 Instance for PostgreSQL in DevOps Project
resource "aws_network_interface" "DevOps-Project-EC2-PostgreSQL" {
  security_groups = [aws_security_group.DevOps-Project-SG.id]
  subnet_id       = aws_subnet.DevOps-Project-SubNet-1.id
}

# Create EC2 Instance DevOps-Project-EC2-PostgreSQL
resource "aws_instance" "DevOps-Project-EC2-PostgreSQL" {
  ami                  = "ami-0b9094fa2b07038b8"
  instance_type        = "t2.micro"
  key_name             = "DevOps-Project-Key"
  iam_instance_profile = aws_iam_instance_profile.ec2_iam_instance_profile.name

  user_data = filebase64("init-ec2-postgresql.sh")

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
    iops        = 3000
  }

  network_interface {
    network_interface_id = aws_network_interface.DevOps-Project-EC2-PostgreSQL.id
    device_index         = 0
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "optional"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "DevOps-Project-EC2-PostgreSQL"
    Terraform   = "true"
    Environment = "dev"
  }
}

# Output: Shows the Public IP from Postgres as Terminal Output
output "postgresql_ip" {
  value = aws_instance.DevOps-Project-EC2-PostgreSQL.public_ip
}

# Create Network Interface and start EC2 Instance for Backend in DevOps Project
resource "aws_network_interface" "DevOps-Project-EC2-Backend" {
  security_groups = [aws_security_group.DevOps-Project-SG.id]
  subnet_id       = aws_subnet.DevOps-Project-SubNet-1.id
}

# Create EC2 Instance for Backend
resource "aws_instance" "DevOps-Project-EC2-Backend" {
  ami                  = "ami-0b9094fa2b07038b8"
  instance_type        = "t2.micro"
  key_name             = "DevOps-Project-Key"
  iam_instance_profile = aws_iam_instance_profile.ec2_iam_instance_profile.name

  #depends_on = [aws_instance.DevOps-Project-EC2-PostgreSQL]
  user_data = base64encode(templatefile("init-ec2-backend.sh.tpl", { ip_address_postgresql = aws_instance.DevOps-Project-EC2-PostgreSQL.public_ip, API_GATEWAY_URL = "https://${aws_api_gateway_rest_api.DevOps-Project-REST-API.id}.execute-api.${var.aws_region}.amazonaws.com/dev/DevOps-Project-API-RESOURCE" }))

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
    iops        = 3000
  }

  network_interface {
    network_interface_id = aws_network_interface.DevOps-Project-EC2-Backend.id
    device_index         = 0
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "optional"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "DevOps-Project-EC2-Backend"
    Terraform   = "true"
    Environment = "dev"
  }

  provisioner "file" {
    source      = "./upload/"
    destination = "/home/ec2-user/"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(local_file.DevOps-Project-Key.filename)
    host        = self.public_ip
  }
}

resource "local_file" "private_key" {
  filename = "./keys/DevOps-Project-Key.pem"
  content  = tls_private_key.RSA.private_key_pem
}

# Output: Shows the Public IP from Backend as Terminal Output
output "backend_ip" {
  value = aws_instance.DevOps-Project-EC2-Backend.public_ip
}

###############################################

