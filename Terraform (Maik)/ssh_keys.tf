####################################
# Create SSH Keys for AWS Services #
####################################

# Creates an SSH Public Key for the Standard EC2 Instances of the DevOps Project.
resource "aws_key_pair" "DevOps-Project-Key" {
  key_name   = "DevOps-Project-Key"
  public_key = tls_private_key.RSA.public_key_openssh
}

# Create / Save  SSH Private Key File Local for all Standard EC2 Instances of the DevOps Project.
resource "local_file" "DevOps-Project-Key" {
  content  = tls_private_key.RSA.private_key_pem
  filename = "${path.module}/keys/DevOps-Project-Key.pem"
}

# Creates an SSH Public Key for the Control Node EC2 Instance of the DevOps Project.
resource "aws_key_pair" "DevOps-Project-Key-Control-Node" {
  key_name   = "DevOps-Project-Key-Control-Node"
  public_key = tls_private_key.RSA.public_key_openssh
}

# Create / Save SSH Private Key File Local for Control Node EC2 Instance of the DevOps Project.
resource "local_file" "DevOps-Project-Key-Control-Node" {
  content  = tls_private_key.RSA.private_key_pem
  filename = "${path.module}/keys/DevOps-Project-Key-Control-Node.pem"
}

# RSA key of size 4096 bits
resource "tls_private_key" "RSA" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

