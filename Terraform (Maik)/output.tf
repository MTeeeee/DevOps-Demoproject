# Output: Show DNS Name from Aplication Load Balancer
output "DevOps-Project-Public-ALB" {
  value = aws_alb.DevOps-Project-Public-ALB.dns_name
}

# Output: Shows URL from REST API Gateway
output "invoke_url" {
  value = "https://${aws_api_gateway_rest_api.DevOps-Project-REST-API.id}.execute-api.${var.aws_region}.amazonaws.com/dev/DevOps-Project-API-RESOURCE"
}

# Output: Shows the Public IP from Postgres as Terminal Output
output "control_node_ip" {
  value = aws_instance.DevOps-Project-EC2-ControlNode.public_ip
}

# Output: Shows the Public IP from Backend as Terminal Output
output "backend_ip" {
  value = aws_instance.DevOps-Project-EC2-Backend.public_ip
}

# Output: Shows the Public IP from Postgres as Terminal Output
output "postgresql_ip" {
  value = aws_instance.DevOps-Project-EC2-PostgreSQL.public_ip
}