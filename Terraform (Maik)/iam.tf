data "aws_caller_identity" "current" {}

# IAM Role Minimum Rights EC2 
# Role for EC2 and S3 LIST/GET/PUT on specific S3 buckets
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

# IAM Role for Node with Maximum Rights for EC2 & S3
resource "aws_iam_role" "ec2_iam_role-control_node" {
  name = "RoleForEC2WithMaxPermissions"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

# IAM Role "Lambda Basic Execution" to execute Lambda Funktion in AWS
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

# IAM Policy Minimum Rights EC2 
# Policy for EC2 and S3 LIST/GET/PUT on specific S3 buckets
resource "aws_iam_policy" "ec2_s3_policy" {
  name        = "ec2_s3_policy"
  path        = "/"
  description = "Policy for EC2 and S3 LIST/GET/PUT on specific S3 buckets"

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

# IAM Policy for Node with Maximum Rights for EC2 & S3
resource "aws_iam_policy" "max_ec2_s3_permissions" {
  name        = "max_ec2_s3_permissions"
  description = "IAM policy with maximum permissions for EC2 and S3."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["ec2:*", "s3:*"],
        Resource = "*"
      }
    ]
  })
}

# IAM Role to Read Private Key for Lambda Funktion in Parameter Store
resource "aws_iam_role_policy" "ssm_policy" {
  name = "SSMReadPolicy"
  role = aws_iam_role.lambda_iam_role.id
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "ssm:GetParameter",
        Resource = aws_ssm_parameter.private_key_control_node.arn
      }
    ]
  })
}

# IAM Policy for sonding Logs to AWS Cloudwatch
resource "aws_iam_role_policy" "lambda_basic_execution" {
  name = "LambdaBasicExecution"
  role = aws_iam_role.ec2_iam_role.id
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# IAM Policy for Lambda to execute API
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

resource "aws_iam_role_policy_attachment" "attach_max_permissions" {
  policy_arn = aws_iam_policy.max_ec2_s3_permissions.arn
  role       = aws_iam_role.ec2_iam_role-control_node.name
}

resource "aws_iam_role_policy_attachment" "lambda_execute_api_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_execute_api_policy.arn
  role       = aws_iam_role.lambda_iam_role.name
}

# Instance Profile for Minimum Rights on Standard EC2
resource "aws_iam_instance_profile" "ec2_iam_instance_profile" {
  name = "ec2_iam_instance_profile"
  role = aws_iam_role.ec2_iam_role.name
}

# Instance Profile for Maximum Rights on EC2 Instance Control Node
resource "aws_iam_instance_profile" "ec2_iam_instance_profile_cn" {
  name = "ec2_iam_instance_profile_cn"
  role = aws_iam_role.ec2_iam_role-control_node.name
}
