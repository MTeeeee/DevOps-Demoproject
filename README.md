# AWS DevOps Final Project from Mete, Maik & Thomas


This project creates an AWS infrastructure using Terraform. 

We would like to enable developers to easily log in / register on a website.
The purpose behind this is that e.g. web developers can easily start up a 
development environment to test their projects.
The environment can be configured as desired after creation.

The development environment is located in its own network and is not connected to the initial infrastructure

The developer can set up the development environment as he needs it.

You can see the setup of the infrastructure in the screenshot (bottom).

**Created the following AWS services in the region "eu-central-1":**<br /> 
- **Network 1 (DevOps-Project):** <br /> 
_"VPC, Subnets, Internet Gateway & Routing Tables"_<br /> 
- **Load Balancer:** <br /> 
_"Application Load Balancer"_<br /> 
- **EC2 Instances (started via a launch template):** <br /> 
_5 Instances, "Backend", "PostgreSQL DB", "Control Node" and "2x Frontend"_<br /> 
- **Auto Scaling Group:** <br /> 
_Autoscaling Group scales the frontend which is a React app running on a NGINX web server_<br /> 
- **Amazon Cloudwatch Alarme:**<br /> 
_2 Alarms: ScaleIN @ >80% CPU or ScaleOUT @ 20% CPU_<br /> 
- **API Gateway:**<br /> 
_To control function calls via the REACT app_<br /> 
- **S3 Buckets:**
_2 Pieces (for log files & build files from frontend)_
- **AWS Lambda:**<br /> 
_2 Lambda Functions with Layers<br />_



- **Network 2 (Dev Environment):**<br /> 
_"VPC, Subnets, Internet Gateway & Routing Tables"_<br /> 
- **EC2 Instances (is started and configured entirely via Ansible.):**<br /> 
_1 Instance_<br /> 


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
**Graphical representation of Infrastructure**

![Alt text](/DevOps-Project/images/DevOps-Project.png?raw=true "DevOps-Project")
![Alt text](/DevOps-Project/images/Dev-Environment.png?raw=true "Dev Environment")