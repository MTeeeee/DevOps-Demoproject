resource "aws_route_table" "Demo_RT" {
 vpc_id = aws_vpc.Demo_VPC.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.Demo_IG.id
 }
 
 tags = {
   Name = "Demo_RT"
 }
}

resource "aws_route_table_association" "public_subnet_asso_a" {
 subnet_id      = aws_subnet.public_a.id
 route_table_id = aws_route_table.Demo_RT.id
}

resource "aws_route_table_association" "public_subnet_asso_b" {
 subnet_id      = aws_subnet.public_b.id
 route_table_id = aws_route_table.Demo_RT.id
}

resource "aws_route_table_association" "public_subnet_asso_c" {
 subnet_id      = aws_subnet.public_c.id
 route_table_id = aws_route_table.Demo_RT.id
}