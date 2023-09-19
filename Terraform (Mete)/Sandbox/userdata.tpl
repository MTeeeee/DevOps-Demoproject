#!/bin/bash
sudo apt update -y &&
sudo apt upgrade -y

sudo dnf install python3-pip -y

pip install ansible

sudo su

cd /home/ec2-user

ansible-galaxy init ec2-provision

cd ec2-provision/tasks/


pip3 install boto


