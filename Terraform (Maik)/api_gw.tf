# Create API Gateway on AWS
resource "aws_api_gateway_rest_api" "DevOps-Project-REST-API" {
  name        = "DevOps-Project-REST-API-GW"
  description = "DevOps-Project-REST-API-GW"
}

resource "aws_api_gateway_resource" "DevOps-Project-API-RESOURCE" {
  rest_api_id = aws_api_gateway_rest_api.DevOps-Project-REST-API.id
  parent_id   = aws_api_gateway_rest_api.DevOps-Project-REST-API.root_resource_id
  path_part   = "DevOps-Project-API-RESOURCE"
}

resource "aws_api_gateway_method" "DevOps-Project-METHOD" {
  rest_api_id   = aws_api_gateway_rest_api.DevOps-Project-REST-API.id
  resource_id   = aws_api_gateway_resource.DevOps-Project-API-RESOURCE.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_deployment" "DevOps-Project-DEPLOYMENT" {
  depends_on = [aws_api_gateway_integration.DevOps-Project-INTEGRATION]

  rest_api_id       = aws_api_gateway_rest_api.DevOps-Project-REST-API.id
  stage_name        = "dev"
  stage_description = "Development"
  description       = "DevOps-Project-DEPLOYMENT"
}

resource "aws_api_gateway_integration" "DevOps-Project-INTEGRATION" {
  rest_api_id = aws_api_gateway_rest_api.DevOps-Project-REST-API.id
  resource_id = aws_api_gateway_resource.DevOps-Project-API-RESOURCE.id
  http_method = aws_api_gateway_method.DevOps-Project-METHOD.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.Lambda_SSH_to_EC2.invoke_arn // WICHTIG MUSS GEÄNDERT WERDEN
}

resource "aws_lambda_permission" "APIGW_LAMBDA_PERMISSION" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.Lambda_SSH_to_EC2.function_name // WICHTIG MUSS GEÄNDERT WERDEN
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.DevOps-Project-REST-API.execution_arn}/*/*"
}
