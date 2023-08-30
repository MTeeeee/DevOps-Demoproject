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

# AWS Account Connect (Techstarter Student Account)
# ATTENTION 1: Do not Reload the Website or the Data will Change
# ATTENTION 1: DO NOT WRITE ACCESS DATA TO THE FILES. SAVE ACCESS DATA VIA THE AWS CLI IN THE CONSOLE.
# https://registry.terraform.io/providers/hashicorp/aws/latest
provider "aws" {
  region     = "eu-central-1"
  access_key = "ASIAYHF3CURHZLRTAQ52"
  secret_key = "a2QWg1lWOiGZwB4EIcfWo8xND8VhY9xVQ7V0yF3X"
  token      = "IQoJb3JpZ2luX2VjEEwaDGV1LWNlbnRyYWwtMSJGMEQCIAK6cGdyWuyF34g7uRYC+L8PyQaM7Y+Y+PphtsMjBg6qAiAZIQjW7FrjM0lGfEz65yrClCJbAflI+3ROwog7svnarSqaAwgVEAEaDDU2NTE4MDUzOTk4MyIMeULzOn5TGfmQqI8fKvcCp/ABbsDfZAqlgnJ7niiA1hrJcR01xnol8TBPvn9aAFeQEVP5BPqEklez8SlPXSIbuNGkVATk6a9L3N2F8INrtA3cLItwu0k3UBMB6YG61Py3sYJd/ebT0uqMaz+y/UAr52pPT2zy0LMT6y6bS8cjiLHic7uXOwAEG7E+xf9/bbMGWTu0NPt3YV8T1fIuQZzkvq6xF9eV2CA0rLt+YlBw2/QL/gTPJU2vQ3w4CLCVceGqeJfvFjsl9oDsoLR80/nOTqniTXW+1sIQ1vvXeivjYRwk1EDv/ZPLmsQr7/k1EivpYdDgPiodjr9EP05ozjSiy1spJ1vuyzmEXHHXEKqqNum7/RtaOkC549zmkg34DbE5czoUDdqG3/GfsQh2DfMubfaXue3kL/kQoRR5LEpqqJqOMYfvLYYVrvbh0T0gGo4pQfFpz30nDdCM/zh8irq4B9HwrsLoieGeYTOxUhWp+yH1BpXTsdRtP/oY7j5tWWKOWZ14m/z9MM7vl6cGOqcBwEDiRhLBoj0ApP3aqIPQWWmautW430BlCI9lgp7/XmvcRvjae+FRE0u+LPXH+7Uc6nywY004XnEjY2wnSKb9E1xtWndmyZ0FkydgAMmkzFYSQGL8LjvyBR5RxMu6UlaCPR1d+mOOClQUu23iqZnSQ79PKGf8wSWe86b5UT+msmb6ETlmV2BRtp2kGtp6L+YGhjGSFWMp0frw7kodmfj4jwNQah8RM80="
}

# Infrastructure as Code (IaC)
resource "aws_instance" "Terraform-EC2-Dev" {
  ami = "ami-04e601abe3e1a910f"
  instance_type = "t2.micro"
  security_groups = [ "launch-wizard-2" ]
  

  tags = {
    Name = "Terraform-EC2-AWS-22.10-Dev"
  }
}

resource "aws_s3_bucket" "terraform-s3-bucket" {
  bucket = "s3-bucket-aws-terraform"

  tags = {
    Name = "S3-Bucket-Terraform-AWS-22.10"
  }
}
