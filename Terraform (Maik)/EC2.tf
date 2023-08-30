# Infrastructure as Code (IaC)
resource "aws_instance" "Terraform-EC2-Dev" {
  ami = "ami-04e601abe3e1a910f"
  instance_type = "t2.micro"
  security_groups = [ "launch-wizard-2" ]
  

  tags = {
    Name = "Terraform-EC2-AWS-22.10-Dev"
  }
}