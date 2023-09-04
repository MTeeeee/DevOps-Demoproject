resource "aws_subnet" "public_a" {
 vpc_id = aws_vpc.Demo_VPC.id
 cidr_block = "10.0.1.0/24"
 availability_zone = "eu-central-1a"
 map_public_ip_on_launch = "true"
 
 tags = {
  Name = "my_public_subnet_a"
 } 
}
resource "aws_subnet" "public_b" {
 vpc_id = aws_vpc.Demo_VPC.id
 cidr_block = "10.0.2.0/24"
 availability_zone = "eu-central-1b"
 
 tags = {
  Name = "my_private_subnet_b"
 }
}
resource "aws_subnet" "public_c" {
 vpc_id = aws_vpc.Demo_VPC.id
 cidr_block = "10.0.3.0/24"
 availability_zone = "eu-central-1c"
 
 tags = {
  Name = "my_private_subnet_b"
 }
}