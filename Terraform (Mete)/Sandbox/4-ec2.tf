  data "template_file" "userdata2" {
    template = "${file("userdata2.tpl")}"
    vars = {
      user_id = "${var.aws_user_id}"
      access_key = "${var.aws_access_key}"
      secret_key = "${var.aws_secret_key}"
      session_token = "${var.aws_session_token}"
      subnet = "${aws_subnet.subnet[0].id}"
    }
  }

resource "aws_instance" "ansible" {
  ami           = "ami-06fd5f7cfe0604468" #amazon linux 2 | ami-0b9094fa2b07038b8 amazon linux 2023
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.subnet[0].id}"
  associate_public_ip_address = true
  key_name      = "demo-key-1"
  user_data     = file("userdata2.tpl")
  iam_instance_profile = "${aws_iam_instance_profile.ec2_profile.name}"
  # user_data     = base64encode(templatefile("userdata2.tpl"), )
  # security_groups = [ "demo_sg" ]
  vpc_security_group_ids = [ "${aws_security_group.security_group.id}" ]

  tags = {
    Name = "Ansible-instance"
  }

  provisioner "file" {
    source = "./upload_playbook/"
    destination = "/home/ec2-user/launch_ec2.yml"

  


    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file(local_file.demo-key-1.filename)
      host = self.public_ip
      agent = false
    }
  }
}




resource "local_file" "upload_playbook" {
  filename = "./keys/demo-key-1.pem"
  content = tls_private_key.RSA.private_key_pem
}






# # launch template

# resource "aws_launch_template" "my_launch_template" {
#   name          = "my-launch-template"
#   description   = "My Launch Template"
#   image_id      = "ami-0b9094fa2b07038b8"
#   instance_type = "t2.micro"


#   # vpc_security_group_ids = [aws_security_group.security_group.id]

#   network_interfaces {
#     security_groups             = [aws_security_group.security_group.id]
#     associate_public_ip_address = true
#     delete_on_termination       = true
#     subnet_id                   = aws_subnet.subnet[0].id
#   }

#   key_name = "demo1"
#   #   user_data = filebase64("${path.module}/app1-install.sh")

#   monitoring {
#     enabled = true
#   }

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "${var.app_name}-ec2-instance"
#     }
#   }
# }

# output "subnets" {
#   value = aws_subnet.subnet
# }