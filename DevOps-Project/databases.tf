# Create Databases for DevOps Project

### Achtung: Bitte lesen! ###

# Leider ist es nicht möglich gewesen mit unseren AWS School Accounts
# eine AWS RDS Datenbank zu nutzen. Das Problem ist, das sich immer 
# nach kürzester Zeit die Login Credentials aus Sicherheisgründen 
# ändern und wir auch keine Zugriff auf IAM haben um Nutzer oder 
# Nutzer Rollen zu erstellen.

### Achtung: Bitte lesen! ###

# Create AWS RDS PostgreSQL Database
# resource "aws_db_instance" "DevOps-Project-DB" {
#   allocated_storage    = 10
#   engine               = "postgres"
#   engine_version       = "15"
#   instance_class       = "db.t3.micro"
#   db_name              = "usersdb"
#   username             = "Maik"
#   password             = "MeinPasswort2023"
#   parameter_group_name = "default.postgres15"
#   skip_final_snapshot  = true
#   publicly_accessible  = true

#   db_subnet_group_name   = aws_db_subnet_group.DevOps-Project-DB-Subnet-Group.name 
#   vpc_security_group_ids = [aws_security_group.DevOps-Project-SG.id]
#   multi_az               = false

#   tags = {
#     Name        = "DevOps-Project-DB"
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }

# resource "aws_db_subnet_group" "DevOps-Project-DB-Subnet-Group" {
#   name = "devops-project-db-subnet-group"
#   subnet_ids = ["aws_subnet.DevOps-Project-SubNet-1.id", "aws_subnet.DevOps-Project-SubNet-2.id", "aws_subnet.DevOps-Project-SubNet-3.id"]
# }

# output "rds_endpoint" {
#   value = aws_db_instance.DevOps-Project-DB.endpoint
# }