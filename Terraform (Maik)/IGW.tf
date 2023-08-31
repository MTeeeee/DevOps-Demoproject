resource "aws_internet_gateway" "DevOps-Project-IGW" {
  vpc_id = aws_vpc.DevOps-Project-VPC.id

  tags = {
    Name = "DevOps-Project-IGW"
    Terraform = "true"
    Environment = "dev"
  }
}
