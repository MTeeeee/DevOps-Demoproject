####################################
# Create SSH Keys for AWS Services #
####################################

# Create SSH Public Key
resource "aws_key_pair" "demo-key-1" {
  key_name   = "demo-key-1"
  public_key = tls_private_key.RSA.public_key_openssh
}

# RSA key of size 4096 bits
resource "tls_private_key" "RSA" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create SSH Private Key File Local on EC2 Instance
resource "local_file" "demo-key-1" {
  content  = tls_private_key.RSA.private_key_pem
  filename = "${path.module}/keys/demo-key-1.pem"
}
