data "aws_caller_identity" "current" {}

resource "aws_iam_role" "ec2_iam_role" {
  name = "ec2_iam_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com",
      }
    }]
  })
}

resource "aws_iam_role" "lambda_iam_role" {
  name = "lambda_iam_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com",
      }
    }]
  })
}

resource "aws_iam_policy" "ec2_s3_policy" {
  name        = "ec2_s3_policy"
  path        = "/"
  description = "Policy for EC2 to LIST/GET/PUT on specific S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Effect = "Allow",
        Resource = [
          "arn:aws:s3:::s3-bucket-aws-terraform-logs",
          "arn:aws:s3:::s3-bucket-aws-terraform-logs/*",
          "arn:aws:s3:::s3-bucket-aws-terraform-frontend",
          "arn:aws:s3:::s3-bucket-aws-terraform-frontend/*"
        ]
      },
      {
        Action = [
          "cloudwatch:PutMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics"
        ],
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "ec2:DescribeTags",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions"
        ],
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_execute_api_policy" {
  name        = "lambda_execute_api_policy"
  path        = "/"
  description = "Policy for Lambda to execute API"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "execute-api:Invoke"
        ],
        Effect = "Allow",
        Resource = [
          "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.DevOps-Project-REST-API.id}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_s3_policy_attachment" {
  policy_arn = aws_iam_policy.ec2_s3_policy.arn
  role       = aws_iam_role.ec2_iam_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_execute_api_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_execute_api_policy.arn
  role       = aws_iam_role.lambda_iam_role.name
}

resource "aws_iam_instance_profile" "ec2_iam_instance_profile" {
  name = "ec2_iam_instance_profile"
  role = aws_iam_role.ec2_iam_role.name
}


# # Create IAM Role and IAM Policy
# # https://skundunotes.com/2021/11/16/attach-iam-role-to-aws-ec2-instance-using-terraform/

# data "aws_caller_identity" "current" {}

# resource "aws_iam_role" "DevOps-Project-IAM-ROLE" {
#   name = "DevOps-Project-IAM-ROLE"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Action = "sts:AssumeRole",
#       Effect = "Allow",
#       Principal = {
#         Service = "ec2.amazonaws.com",
#         Service = "lambda.amazonaws.com"
#       }
#     }]
#   })
# }

# resource "aws_iam_policy" "DevOps-Project-IAM-POLICY" {
#   name        = "DevOps-Project-IAM-POLICY"
#   path        = "/"
#   description = "Policy for LIST/GET/PUT on S3 - LIST/GET/PUT Cloudwatch Metrics - Allow Reading Tags from Instances Regions from EC2 - Lambda execute API"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = [
#           "s3:PutObject",
#           "s3:GetObject",
#           "s3:ListBucket"
#         ],
#         Effect = "Allow",
#         Resource = [
#           "arn:aws:s3:::s3-bucket-aws-terraform-logs",
#           "arn:aws:s3:::s3-bucket-aws-terraform-logs/*"
#         ]
#       },
#       {
#         Action = [
#           "s3:PutObject",
#           "s3:GetObject",
#           "s3:ListBucket"
#         ],
#         Effect = "Allow",
#         Resource = [
#           "arn:aws:s3:::s3-bucket-aws-terraform-frontend",
#           "arn:aws:s3:::s3-bucket-aws-terraform-frontend/*"
#         ]
#       },
#       {
#         Action = [
#           "cloudwatch:PutMetricData",
#           "cloudwatch:GetMetricStatistics",
#           "cloudwatch:ListMetrics"
#         ],
#         Effect   = "Allow",
#         Resource = "*"
#       },
#       {
#         Action = [
#           "ec2:DescribeTags",
#           "ec2:DescribeInstances",
#           "ec2:DescribeRegions"
#         ],
#         Effect   = "Allow",
#         Resource = "*"
#       },
#       {
#         Action = [
#           "logs:CreateLogGroup",
#           "logs:CreateLogStream",
#           "logs:PutLogEvents"
#         ],
#         Effect   = "Allow",
#         Resource = "arn:aws:logs:*:*:*",
#       },
#       {
#         Action = [
#           "execute-api:Invoke"
#         ],
#         Effect = "Allow",
#         Resource = [
#           "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.DevOps-Project-REST-API.id}/*"
#         ],
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "DevOps-Project-IAM-ATTACHMENT" {
#   policy_arn = aws_iam_policy.DevOps-Project-IAM-POLICY.arn
#   role       = aws_iam_role.DevOps-Project-IAM-ROLE.name
# }

# resource "aws_iam_instance_profile" "EC2toS3-Profile" {
#   name = "EC2toS3-Profile"
#   role = aws_iam_role.DevOps-Project-IAM-ROLE.name
# }
