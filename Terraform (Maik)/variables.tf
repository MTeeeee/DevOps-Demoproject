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
