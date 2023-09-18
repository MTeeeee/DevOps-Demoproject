# provider variable
variable "aws_region" {
  description = "Configuring AWS as provider"
  type        = string
  default     = "eu-central-1"
}

# keys to the castle variable

variable "aws_user_id" {
  type = string
  sensitive = true
}

variable "aws_access_key" {
  type      = string
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "aws_session_token" {
  type      = string
  sensitive = true
}

# vpc variable
variable "vpc_cidr" {
  description = "CIDR block for main"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet" {
  description = "List of public subnets"
}

# availability zones variable
variable "availability_zones" {
  description = "List of availability zones"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
}

variable "app_name" {
  type        = string
  description = "Application Name"
}
