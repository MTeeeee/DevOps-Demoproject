# Terraform Reason Configuration
# https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.13.1"
    }
  }
}
