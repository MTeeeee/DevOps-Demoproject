# AWS Account Connect (Techstarter Student Account)
# ATTENTION 1: Do not Reload the Website or the Data will Change
# ATTENTION 1: DO NOT WRITE ACCESS DATA TO THE FILES. SAVE ACCESS DATA VIA THE AWS CLI IN THE CONSOLE.
# https://registry.terraform.io/providers/hashicorp/aws/latest
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  token      = var.aws_session_token
}