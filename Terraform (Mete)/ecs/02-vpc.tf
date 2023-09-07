resource "aws_vpc" "aws-vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    name = "${var.app_name}-vpc"
  }
}

# resource "aws_subnet" "subnet" {
#   vpc_id                  = aws_vpc.aws-vpc.id
#   cidr_block              = cidrsubnet(aws_vpc.aws-vpc.cidr_block, 8, 1) ## takes 10.0.0.0/16 --> 10.0.1.0/24
#   map_public_ip_on_launch = true
#   availability_zone       = var.availability_zones
# }

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.aws-vpc.id
  count                   = length(var.subnet)
  cidr_block              = element(var.subnet, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.app_name}-public-subnet-${count.index + 1}"
    Environment = var.app_environment
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.aws-vpc.id

  tags = {
    Name        = "${var.app_name}-igw"
    Environment = var.app_environment
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.aws-vpc.id

  ### ???
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

  tags = {
    Name        = "${var.app_name}-routing-table-public"
    Environment = var.app_environment
  }
}

resource "aws_route" "subnet" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# resource "aws_route_table_association" "subnet_route" {
#   subnet_id      = aws_subnet.subnet.id
#   route_table_id = aws_route_table.rt.id
# }

resource "aws_route_table_association" "subnet_route" {
  count          = length(var.subnet)
  subnet_id      = element(aws_subnet.subnet.*.id, count.index)
  route_table_id = aws_route_table.rt.id
}
