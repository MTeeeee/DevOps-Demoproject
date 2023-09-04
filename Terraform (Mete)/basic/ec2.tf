resource "aws_instance" "aws_ubuntu" {
  ami           = "ami-04e601abe3e1a910f"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.public_a.id}"
  associate_public_ip_address = true
  key_name      = "demo1"
  user_data     = file("userdata.tpl")
 # security_groups = [ "demo_sg" ]
  vpc_security_group_ids = [ "${aws_security_group.demo_sg.id}" ]

  tags = {
    Name = "HelloWorld"
  }
}