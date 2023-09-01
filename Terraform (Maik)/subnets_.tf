# Public Subnet 1
resource "aws_subnet" "DevOps-Project-SubNet-1" {
  vpc_id                  = aws_vpc.DevOps-Project-VPC.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
  # map_public_ip_on_launch = false

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
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true
  # map_public_ip_on_launch = false

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
  availability_zone       = "eu-central-1c"
  map_public_ip_on_launch = true
  # map_public_ip_on_launch = false

  tags = {
    Name = "DevOps-Project-SubNet-3"
    Terraform = "true"
    Environment = "dev"
  }
}