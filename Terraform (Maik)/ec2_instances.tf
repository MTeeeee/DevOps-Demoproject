# Infrastructure as Code (IaC)
resource "aws_instance" "DevOps-Project-WebServer" {
  ami                         = "ami-0766f68f0b06ab145"
  instance_type               = "t2.micro"
  subnet_id                   = "${aws_subnet.DevOps-Project-SubNet-1.id}"
  vpc_security_group_ids      = [ "${aws_security_group.DevOps-Project-SG.id}" ]
  key_name                    = "DevOps-Project-Key"
  associate_public_ip_address = true
  monitoring                  = true

  user_data                   = file("init.sh")

  metadata_options {
      http_protocol_ipv6          = "disabled"
      http_endpoint               = "enabled"
      http_put_response_hop_limit = 2
      http_tokens                 = "optional"
      instance_metadata_tags      = "enabled"
  }

  tags = {
    Name        = "DevOps-Project-WebServer"
    Terraform   = "true"
    Environment = "dev"
  }
}
