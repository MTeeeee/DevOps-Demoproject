# Create Lambda Funktione on AWS
resource "aws_lambda_function" "MY_LAMBDA_FUNKTION" {
  function_name = "my_python_lambda_function_name" # Benennen Sie Ihre Funktion entsprechend
  handler       = "lambda_function.lambda_handler" # Stellen Sie sicher, dass dies mit Ihrem Python-Handler übereinstimmt
  role          = aws_iam_role.lambda_iam_role.arn
  runtime       = "python3.11" # Wählen Sie die gewünschte Python Runtime-Version

  filename = "./lambda/DevOps-Project-MyLambdaFunktion.zip" # Ersetzen Sie dies durch den Pfad zu Ihrem Deployment-Paket
}

