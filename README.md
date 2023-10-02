# AWS DevOps Final Project from Mete, Maik & Thomas


This project creates an AWS infrastructure using Terraform. 

The purpose behind this is that e.g. web developers can easily 
start up a development environment to test their projects.

The developer can set up the development environment as he needs it.

You can see the setup of the infrastructure in the screenshot.


Steps for using this Project:

In File "variable.auto.tfvars" insert your AWS Credentials:
```
aws_access_key_id="YOUR-AWS-ACCESS-KEY-ID"
aws_secret_access_key="YOUR-SECRET-ACCESS-KEY"
aws_session_token="YOUR-AWS-SESSION-TOKEN"
```
Install Terraform (https://developer.hashicorp.com/)

On Terminal navigate to Project Folder.
and use this commands in order.
```
terraform init
terraform validate
terraform plan
terraform apply
```
