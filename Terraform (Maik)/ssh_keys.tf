####################################
# Create SSH Keys for AWS Services #
####################################

# Create SSH Public Key
resource "aws_key_pair" "DevOps-Project-Key" {
  key_name   = "DevOps-Project-Key"
  public_key = tls_private_key.RSA.public_key_openssh
}

# RSA key of size 4096 bits
resource "tls_private_key" "RSA" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create SSH Private Key File Local on EC2 Instance
resource "local_file" "DevOps-Project-Key" {
  content  = tls_private_key.RSA.private_key_pem
  filename = "${path.module}/keys/DevOps-Project-Key.pem"
}
