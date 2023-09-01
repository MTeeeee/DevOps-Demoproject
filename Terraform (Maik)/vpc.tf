resource "aws_vpc" "DevOps-Project-VPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name

  tags = {
    Name = "DevOps-Project-VPC"
    Terraform = "true"
    Environment = "dev"
  }
}
