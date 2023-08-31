# Infrastructure as Code (IaC)
resource "aws_instance" "DevOps-Project-WebServer" {
  ami                     = "ami-04e601abe3e1a910f"
  instance_type           = "t2.micro"
  security_groups         = [ "DevOps-Project-SQ" ]
  key_name                = "DevOps-Project-Key"
  monitoring              = true
  #vpc_security_group_ids  = ["sg-12345678"]
  #subnet_id               = "subnet-eddcdzz4"
  

  tags = {
    Name = "DevOps-Project-WebServer"
    Terraform = "true"
    Environment = "dev"
  }
}