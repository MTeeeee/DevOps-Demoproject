resource "aws_internet_gateway" "Demo_IG" {
 vpc_id = aws_vpc.Demo_VPC.id
 
 tags = { 
  Name = "Demo_IG"
 }
}