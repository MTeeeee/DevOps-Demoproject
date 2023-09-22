# Create Lambda Funktione on AWS
resource "aws_lambda_function" "Lambda_SSH_to_EC2" {
  function_name = "Lambda_SSH_to_EC2_ControlNode"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_iam_role.arn
  runtime       = "python3.7" 

  environment {
    variables = {
      EC2_INSTANCE_IP = aws_instance.DevOps-Project-EC2-ControlNode.public_ip
    }
  }

  #filename = "./lambda/LambdaSSHtoEC2-Example-Funktion.zip"
  filename = "./lambda/DevOps-Project-MyLambdaFunktion.zip"

  tags = {
    Name        = "Lambda_SSH_to_EC2"
    Terraform   = "true"
    Environment = "dev"
  }

  #layers = [ aws_lambda_layer_version.Lambda_SSH_to_EC2_Requirements ]
}

# # Create Lambda Layer for Requirements
# resource "aws_lambda_layer_version" "Lambda_SSH_to_EC2_Requirements" {
#   layer_name          = "Lambda_SSH_to_EC2_Requirements"
#   compatible_runtimes = ["python3.8"]

#   filename = "./lambda/LambdaSSHtoEC2-Example-Requirements.zip"
# }