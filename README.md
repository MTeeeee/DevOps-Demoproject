# AWS DevOps Final Project from Mete, Maik & Thomas


This project creates an AWS infrastructure using Terraform. 

We would like to enable developers to easily log in / register on a website.
The purpose behind this is that e.g. web developers can easily start up a 
development environment to test their projects.
The environment can be configured as desired after creation.

The developer can set up the development environment as he needs it.

You can see the setup of the infrastructure in the screenshot.

**Created the following AWS services in the region "eu-central-1":**
**Network 1:** 
>"VPC, Subnets, Internet Gateway & Routing Tables"
**Load Balancer:** 
>"Application Load Balancer"
**EC2 Instances (started via a launch template):** 
>5 Instances, "Backend", "PostgreSQL DB", "Control Node" and "2x Frontend"
**Auto Scaling Group:** 
>Autoscalinggroup scales the frontend which is a React app running on a NGINX web server
**Amazon Cloudwatch Alarme:**
>2 Alarms: ScaleIN @ >80% CPU or ScaleOUT @ 20% CPU
**API Gateway:**
>To control function calls via the REACT app
**AWS Lambda:**
>2 Lambda Funktions

**Network 2:**
"VPC, Subnets, Internet Gateway & Routing Tables"
**EC2 Instances (is started and configured entirely via Ansible.):**
1 Instance


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
