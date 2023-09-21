# AWS Login Variables for DevOps Project

variable "aws_region" {
  type = string
  default = "eu-central-1"
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

# AMI (Amazon Linux 2 AMI (HVM)
variable "ec2_ami_al2" {
  type = string
  default = "ami-0f845a2bba44d24b2"
}