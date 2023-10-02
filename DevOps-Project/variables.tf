# AWS Login Variables for DevOps Project

variable "aws_region" {
  type = string
  default = "eu-central-1"
}

variable "aws_user_id" {
  type = string
  default = "[565180539983_Student]"
}

variable "aws_access_key_id" {
  type = string
}

variable "aws_secret_access_key" {
  type = string
}

variable "aws_session_token" {
  type = string
}

# AMI (Amazon Linux 2023 AMI)
variable "ec2_ami" {
  type = string
  default = "ami-01342111f883d5e4e"
}
