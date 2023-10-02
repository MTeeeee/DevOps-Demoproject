# Create Routing Table for DevOps Project

resource "aws_route_table" "DevOps-Project-Public-RT" {
  vpc_id = aws_vpc.DevOps-Project-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.DevOps-Project-IGW.id
  }

  tags = {
    Name = "DevOps-Project-Public-RT"
    Terraform = "true"
    Environment = "dev"
  }
}


# aws_route_table_association:- This resource is used to create an association between the route table and a subnet/internet gateway.
resource "aws_route_table_association" "PublicSubnetRouteTableAssociation1" {
  subnet_id      = aws_subnet.DevOps-Project-SubNet-1.id
  route_table_id = aws_route_table.DevOps-Project-Public-RT.id
  #route_table_id = aws_default_route_table.DevOps-Project-Public-RT.id
}

resource "aws_route_table_association" "PublicSubnetRouteTableAssociation2" {
  subnet_id      = aws_subnet.DevOps-Project-SubNet-2.id
  route_table_id = aws_route_table.DevOps-Project-Public-RT.id
  #route_table_id = aws_default_route_table.DevOps-Project-Public-RT.id
}

resource "aws_route_table_association" "PublicSubnetRouteTableAssociation3" {
  subnet_id      = aws_subnet.DevOps-Project-SubNet-3.id
  route_table_id = aws_route_table.DevOps-Project-Public-RT.id
  #route_table_id = aws_default_route_table.DevOps-Project-Public-RT.id
}