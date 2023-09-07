# Create IAM Role and IAM Policy
# https://skundunotes.com/2021/11/16/attach-iam-role-to-aws-ec2-instance-using-terraform/

resource "aws_iam_role" "DevOps-Project-IAM-ROLE" {
  name = "DevOps-Project-IAM-ROLE"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "DevOps-Project-IAM-POLICY" {
  name        = "DevOps-Project-IAM-POLICY"
  path        = "/"
  description = "Example policy for writing to S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      Effect = "Allow",
      Resource = [
        "arn:aws:s3:::s3-bucket-aws-terraform",
        "arn:aws:s3:::s3-bucket-aws-terraform/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "DevOps-Project-IAM-ATTACHMENT" {
  policy_arn = aws_iam_policy.DevOps-Project-IAM-POLICY.arn
  role       = aws_iam_role.DevOps-Project-IAM-ROLE.name
}

resource "aws_iam_instance_profile" "EC2toS3-Profile" {
  name = "EC2toS3-Profile"
  role = aws_iam_role.DevOps-Project-IAM-ROLE.name
}