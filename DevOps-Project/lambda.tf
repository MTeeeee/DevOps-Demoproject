# Create Lambda Funktione on AWS (For Button Start DEV Enviroment)
resource "aws_lambda_function" "Lambda_SSH_to_EC2" {
  function_name = "Lambda_SSH_to_EC2_ControlNode"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_iam_role.arn
  runtime       = "python3.7" 
  timeout       = 25

  environment {
    variables = {
      EC2_INSTANCE_IP = aws_instance.DevOps-Project-EC2-ControlNode.public_ip
    }
  }

  filename = "./lambda/Lambda_SSH_to_EC2_Funktion.zip"

  tags = {
    Name        = "Lambda_SSH_to_EC2"
    Terraform   = "true"
    Environment = "dev"
  }

  layers = [ aws_lambda_layer_version.Lambda_SSH_to_EC2_Requirements.arn ]
}

# Create Lambda Funktione on AWS (For Button Start DEV Enviroment)
resource "aws_lambda_function" "Lambda_SSH_get_Data" {
  function_name = "Lambda_SSH_get_Data_from_ControlNode"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_iam_role.arn
  runtime       = "python3.7" 
  timeout       = 25

  environment {
    variables = {
      EC2_INSTANCE_IP = aws_instance.DevOps-Project-EC2-ControlNode.public_ip
    }
  }

  filename = "./lambda/Lambda_SSH_get_Data.zip"

  tags = {
    Name        = "Lambda_SSH_get_Data"
    Terraform   = "true"
    Environment = "dev"
  }

  layers = [ aws_lambda_layer_version.Lambda_SSH_to_EC2_Requirements.arn ]
}

# Create Lambda Layer for Requirements
resource "aws_lambda_layer_version" "Lambda_SSH_to_EC2_Requirements" {
  layer_name          = "Lambda_SSH_to_EC2_Requirements"
  compatible_runtimes = ["python3.8"]

  filename = "./lambda/Lambda_SSH_to_EC2_Layer.zip"
}