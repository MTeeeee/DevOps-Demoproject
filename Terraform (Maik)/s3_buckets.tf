# Create S3 Bucket for DevOps Project
# This Bucket is for Metrics and Log Files

resource "aws_s3_bucket" "terraform-s3-bucket-logs" {
  bucket = "s3-bucket-aws-terraform-logs"

  tags = {
    Name        = "S3-Bucket-Terraform-AWS-22.10-LOGs"
    Terraform   = "true"
    Environment = "dev"
  }
}

# Create S3 Bucket for DevOps Project
# This Bucket is for Frontend Files

resource "aws_s3_bucket" "terraform-s3-bucket-frontend" {
  bucket = "s3-bucket-aws-terraform-frontend"

  tags = {
    Name        = "S3-Bucket-Terraform-AWS-22.10-Frontend-Files"
    Terraform   = "true"
    Environment = "dev"
  }
}