# Erstellen des API Gateways
resource "aws_api_gateway_rest_api" "DevOps-Project-REST-API" {
  name        = "DevOps-Project-REST-API-GW"
  description = "DevOps-Project-REST-API-GW"
}

# Erstellen einer API-Ressource für DevOps-Project-REST-API
resource "aws_api_gateway_resource" "DevOps-Project-REST-API-Resource" {
  rest_api_id = aws_api_gateway_rest_api.DevOps-Project-REST-API.id
  parent_id   = aws_api_gateway_rest_api.DevOps-Project-REST-API.root_resource_id
  path_part   = "DevOps-Project-REST-API" #MODIFIED
}

# Erstellen einer API-Ressource für starting
resource "aws_api_gateway_resource" "DevOps-Project-Starting-RESOURCE" {
  rest_api_id = aws_api_gateway_rest_api.DevOps-Project-REST-API.id
  parent_id   = aws_api_gateway_resource.DevOps-Project-REST-API-Resource.id
  path_part   = "starting" #MODIFIED
}

# Erstellen einer API-Methode (GET) für starting
resource "aws_api_gateway_method" "DevOps-Project-METHOD" {
  rest_api_id   = aws_api_gateway_rest_api.DevOps-Project-REST-API.id
  resource_id   = aws_api_gateway_resource.DevOps-Project-Starting-RESOURCE.id #MODIFIED
  http_method   = "GET"
  authorization = "NONE"
}

# Methode für den 200-Statuscode definieren für starting
resource "aws_api_gateway_method_response" "DevOps-Project-METHOD-RESPONSE-200" {
  rest_api_id = aws_api_gateway_rest_api.DevOps-Project-REST-API.id
  resource_id = aws_api_gateway_resource.DevOps-Project-Starting-RESOURCE.id #MODIFIED
  http_method = aws_api_gateway_method.DevOps-Project-METHOD.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Content-Type" = true
  }
}

# Methode für den 500-Statuscode definieren für starting
resource "aws_api_gateway_method_response" "DevOps-Project-METHOD-RESPONSE-500" {
  rest_api_id = aws_api_gateway_rest_api.DevOps-Project-REST-API.id
  resource_id = aws_api_gateway_resource.DevOps-Project-Starting-RESOURCE.id #MODIFIED
  http_method = aws_api_gateway_method.DevOps-Project-METHOD.http_method
  status_code = "500"
  response_parameters = {
    "method.response.header.Content-Type" = true
  }
}

# Integration der Lambda-Funktion mit dem API Gateway für starting
resource "aws_api_gateway_integration" "DevOps-Project-INTEGRATION" {
  rest_api_id             = aws_api_gateway_rest_api.DevOps-Project-REST-API.id
  resource_id             = aws_api_gateway_resource.DevOps-Project-Starting-RESOURCE.id #MODIFIED
  http_method             = aws_api_gateway_method.DevOps-Project-METHOD.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.Lambda_SSH_to_EC2.invoke_arn
}

# Integration für den 200-Statuscode definieren für starting
resource "aws_api_gateway_integration_response" "DevOps-Project-INTEGRATION-RESPONSE-200" {
  rest_api_id       = aws_api_gateway_rest_api.DevOps-Project-REST-API.id
  resource_id       = aws_api_gateway_resource.DevOps-Project-Starting-RESOURCE.id #MODIFIED
  http_method       = aws_api_gateway_method.DevOps-Project-METHOD.http_method
  status_code       = "200"
  selection_pattern = "2[0-9][0-9]"
  depends_on = [
    aws_api_gateway_integration.DevOps-Project-INTEGRATION,
    aws_api_gateway_method_response.DevOps-Project-METHOD-RESPONSE-200
  ]
  response_parameters = {
    "method.response.header.Content-Type" = "'application/json'"
  }
}

# Integration für den 500-Statuscode definieren für starting
resource "aws_api_gateway_integration_response" "DevOps-Project-INTEGRATION-RESPONSE-500" {
  rest_api_id       = aws_api_gateway_rest_api.DevOps-Project-REST-API.id
  resource_id       = aws_api_gateway_resource.DevOps-Project-Starting-RESOURCE.id #MODIFIED
  http_method       = aws_api_gateway_method.DevOps-Project-METHOD.http_method
  status_code       = "500"
  selection_pattern = "5[0-9][0-9]"
  depends_on = [
    aws_api_gateway_integration.DevOps-Project-INTEGRATION,
    aws_api_gateway_method_response.DevOps-Project-METHOD-RESPONSE-500
  ]
  response_parameters = {
    "method.response.header.Content-Type" = "'application/json'"
  }
}

# Berechtigung für das API Gateway, um die Lambda-Funktion aufzurufen
resource "aws_lambda_permission" "APIGW_LAMBDA_PERMISSION" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.Lambda_SSH_to_EC2.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.DevOps-Project-REST-API.execution_arn}/*/*" #MODIFIED
}

# Erstellen einer API-Bereitstellung (Deployment)
resource "aws_api_gateway_deployment" "DevOps-Project-DEPLOYMENT" {
  #depends_on        = [aws_api_gateway_integration.DevOps-Project-INTEGRATION] #MAIK
  depends_on = [
    aws_api_gateway_integration.DevOps-Project-INTEGRATION,
    aws_api_gateway_integration.DevOps-Project-Getdata-INTEGRATION
  ]
  rest_api_id       = aws_api_gateway_rest_api.DevOps-Project-REST-API.id
  stage_name        = "dev"
  stage_description = "Development"
  description       = "DevOps-Project-DEPLOYMENT"
}

############################ BUTTON 2 ##############################

# Der bestehende Code bleibt unverändert; dies ist nur die Ergänzung:

# Erstellen einer API-Ressource für getdata
resource "aws_api_gateway_resource" "DevOps-Project-Getdata-RESOURCE" {
  rest_api_id = aws_api_gateway_rest_api.DevOps-Project-REST-API.id
  parent_id   = aws_api_gateway_resource.DevOps-Project-REST-API-Resource.id
  path_part   = "getdata"
}

# Erstellen einer API-Methode (GET) für getdata
resource "aws_api_gateway_method" "DevOps-Project-Getdata-METHOD" {
  rest_api_id   = aws_api_gateway_rest_api.DevOps-Project-REST-API.id
  resource_id   = aws_api_gateway_resource.DevOps-Project-Getdata-RESOURCE.id
  http_method   = "GET"
  authorization = "NONE"
}

# Methode für den 200-Statuscode definieren für getdata
resource "aws_api_gateway_method_response" "DevOps-Project-Getdata-METHOD-RESPONSE-200" {
  rest_api_id = aws_api_gateway_rest_api.DevOps-Project-REST-API.id
  resource_id = aws_api_gateway_resource.DevOps-Project-Getdata-RESOURCE.id
  http_method = aws_api_gateway_method.DevOps-Project-Getdata-METHOD.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Content-Type" = true
  }
}

# Methode für den 500-Statuscode definieren für getdata
resource "aws_api_gateway_method_response" "DevOps-Project-Getdata-METHOD-RESPONSE-500" {
  rest_api_id = aws_api_gateway_rest_api.DevOps-Project-REST-API.id
  resource_id = aws_api_gateway_resource.DevOps-Project-Getdata-RESOURCE.id
  http_method = aws_api_gateway_method.DevOps-Project-Getdata-METHOD.http_method
  status_code = "500"
  response_parameters = {
    "method.response.header.Content-Type" = true
  }
}

# Integration der Lambda-Funktion mit dem API Gateway für getdata
resource "aws_api_gateway_integration" "DevOps-Project-Getdata-INTEGRATION" {
  rest_api_id             = aws_api_gateway_rest_api.DevOps-Project-REST-API.id
  resource_id             = aws_api_gateway_resource.DevOps-Project-Getdata-RESOURCE.id
  http_method             = aws_api_gateway_method.DevOps-Project-Getdata-METHOD.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.Lambda_SSH_get_Data.invoke_arn
}

# Integration für den 200-Statuscode definieren für getdata
resource "aws_api_gateway_integration_response" "DevOps-Project-Getdata-INTEGRATION-RESPONSE-200" {
  rest_api_id       = aws_api_gateway_rest_api.DevOps-Project-REST-API.id
  resource_id       = aws_api_gateway_resource.DevOps-Project-Getdata-RESOURCE.id
  http_method       = aws_api_gateway_method.DevOps-Project-Getdata-METHOD.http_method
  status_code       = "200"
  selection_pattern = "2[0-9][0-9]"
  depends_on = [
    aws_api_gateway_integration.DevOps-Project-Getdata-INTEGRATION,
    aws_api_gateway_method_response.DevOps-Project-Getdata-METHOD-RESPONSE-200
  ]
  response_parameters = {
    "method.response.header.Content-Type" = "'application/json'"
  }
}

# Integration für den 500-Statuscode definieren für getdata
resource "aws_api_gateway_integration_response" "DevOps-Project-Getdata-INTEGRATION-RESPONSE-500" {
  rest_api_id       = aws_api_gateway_rest_api.DevOps-Project-REST-API.id
  resource_id       = aws_api_gateway_resource.DevOps-Project-Getdata-RESOURCE.id
  http_method       = aws_api_gateway_method.DevOps-Project-Getdata-METHOD.http_method
  status_code       = "500"
  selection_pattern = "5[0-9][0-9]"
  depends_on = [
    aws_api_gateway_integration.DevOps-Project-Getdata-INTEGRATION,
    aws_api_gateway_method_response.DevOps-Project-Getdata-METHOD-RESPONSE-500
  ]
  response_parameters = {
    "method.response.header.Content-Type" = "'application/json'"
  }
}

# Berechtigung für das API Gateway, um die Lambda-Funktion für getdata aufzurufen
resource "aws_lambda_permission" "APIGW_Getdata_LAMBDA_PERMISSION" {
  statement_id  = "AllowAPIGatewayGetdataInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.Lambda_SSH_get_Data.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.DevOps-Project-REST-API.execution_arn}/*/*"
}

