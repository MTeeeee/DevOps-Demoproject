resource "aws_instance" "web" {
  ami           = "ami-0c4c4bd6cf0c5fe52"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}