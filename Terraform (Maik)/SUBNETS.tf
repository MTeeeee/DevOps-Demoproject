# Public Subnet 1
resource "aws_subnet" "DevOps-Project-SubNet-1" {
  vpc_id                  = aws_vpc.DevOps-Project-VPC.id
  cidr_block              = "10.0.1.0/24"

  tags = {
    Name = "DevOps-Project-SubNet-1"
    Terraform = "true"
    Environment = "dev"
  }
}

# Public Subnet 2
resource "aws_subnet" "DevOps-Project-SubNet-2" {
  vpc_id                  = aws_vpc.DevOps-Project-VPC.id
  cidr_block              = "10.0.2.0/24"

  tags = {
    Name = "DevOps-Project-SubNet-2"
    Terraform = "true"
    Environment = "dev"
  }
}

# Public Subnet 3
resource "aws_subnet" "DevOps-Project-SubNet-3" {
  vpc_id                  = aws_vpc.DevOps-Project-VPC.id
  cidr_block              = "10.0.3.0/24"

  tags = {
    Name = "DevOps-Project-SubNet-3"
    Terraform = "true"
    Environment = "dev"
  }
}