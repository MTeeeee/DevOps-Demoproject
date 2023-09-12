# Create SSH Keys for AWS Services

resource "aws_key_pair" "DevOps-Project-Keys" {
  key_name   = "DevOps-Project-Keys" 
  public_key = file("C:/.ssh/id_rsa.pub")
}

# Wenn eine PPK oder PEM Datei benötigt wird, können
# diese mit dem Tool PuTTyGEN und der id_rsa.pup 
# erstellt werden.
