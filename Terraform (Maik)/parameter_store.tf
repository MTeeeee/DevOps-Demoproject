# Private Key to Connect Control Node EC2 Instance
resource "aws_ssm_parameter" "private_key_control_node" {
  name  = "DevOps-Project-Key-Control-Node"
  type  = "SecureString"
  value = tls_private_key.RSA.private_key_pem
}

