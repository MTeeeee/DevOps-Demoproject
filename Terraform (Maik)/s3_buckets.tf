# Create S3 Bucket for DevOps Project
# This Bucket is for Metrics and Log Files

resource "aws_s3_bucket" "terraform-s3-bucket" {
  bucket = "s3-bucket-aws-terraform"

  tags = {
    Name = "S3-Bucket-Terraform-AWS-22.10"
    Terraform   = "true"
    Environment = "dev"
  }
}
