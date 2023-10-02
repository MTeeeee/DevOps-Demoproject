#!/bin/bash

# Script ends after Error
#set -e
set -x

# EC2 Update
sudo yum update -y

# Install Terraform
sudo yum install yum-utils -y
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum install terraform -y

# Python
sudo yum install python3.11 -y
sudo yum install python-pip -y

# Dependencies (boto & boto3 & passlib)
pip3 install boto boto3
pip3 install passlib

# Install Ansible (NOT FOR AMAZON LINUX 2)
pip install ansible

# Reinstall Ansible AWS Collection
sudo ansible-galaxy collection install amazon.aws --force

# Reinstall Ansible Community Collection
sudo ansible-galaxy collection install community.aws --force

# Create AWS Credentials
mkdir /home/ec2-user/.aws
touch /home/ec2-user/.aws/credentials

# Copies the Content of the variables to ~/.aws/credentials
echo "${user_id}" >> /home/ec2-user/.aws/credentials
echo "aws_access_key_id=${access_key_id}" >> /home/ec2-user/.aws/credentials
echo "aws_secret_access_key=${secret_access_key}" >> /home/ec2-user/.aws/credentials
echo "aws_session_token=${session_token}" >> /home/ec2-user/.aws/credentials

# Change ownership to AWS Credentials
sudo chown ec2-user:ec2-user /home/ec2-user/.aws
sudo chown ec2-user:ec2-user /home/ec2-user/.aws/credentials

# Ansible Variables
echo "target_subnet: ${subnet}" >> /home/ec2-user/ansible_vars

# AWS Cloud Control Collection for Ansible
ansible-galaxy collection install amazon.aws
sudo -u ec2-user ansible-galaxy collection install amazon.aws

# Change ownership to File for Ansible Variables
sudo chown ec2-user:ec2-user /home/ec2-user/ansible_vars

# Change Rights for Key File
sudo chmod 400 /home/ec2-user/keys/Ansible-DEV-Envirement.pem

# Installiere und aktiviere "CRON"
sudo yum install cronie -y
sudo systemctl start crond
sudo systemctl enable crond

# Erstellen Sie das "EC2toS3" Log-Synchronisationsskript in /usr/local/bin/
generate_sync_logs="
#!/bin/bash

LOG_DIR=\"/var/log\"
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
S3_BUCKET=\"s3-bucket-aws-terraform-logs\"

cat <<EOL > /usr/local/bin/sync_logs.sh
#!/bin/bash

LOG_DIR=\"$LOG_DIR\"
INSTANCE_ID=\"$INSTANCE_ID\"
S3_BUCKET=\"$S3_BUCKET\"

# Erstellen Sie den Instanzordner im S3-Bucket, wenn er noch nicht existiert
aws s3api head-object --bucket "\$S3_BUCKET" --key "\$INSTANCE_ID/" || aws s3api put-object --bucket "\$S3_BUCKET" --key "\$INSTANCE_ID/"

# Synchronisieren Sie die Logdateien mit dem Instanzordner im S3-Bucket
aws s3 sync "\$LOG_DIR" "s3://\$S3_BUCKET/\$INSTANCE_ID/"
EOL

"

echo "$generate_sync_logs" | sudo tee "/usr/local/bin/generate_sync_logs.sh"


# Setzen Sie die Berechtigungen für die Skripte und führen sie direkt aus
sudo chmod +x /usr/local/bin/generate_sync_logs.sh &&
sudo /usr/bin/bash /usr/local/bin/generate_sync_logs.sh

sudo chmod +x /usr/local/bin/sync_logs.sh &&
sudo /usr/bin/bash /usr/local/bin/sync_logs.sh

# Fügen Sie den Cron-Job hinzu, um das Skript alle 5 Minuten auszuführen
(crontab -l 2>/dev/null; echo "* * * * * /usr/bin/bash /usr/local/bin/sync_logs.sh") | crontab -

# Installiert das Tool "stress" mit dem man die CPU von EC2 Instanzen auslasten kann um Autoscaling zu testen
sudo yum install stress -y
# Folgender Auskommentierter Befehl startet das Tool "stress" und lastet die Instanz für 900 Sekungen (15 Min.) aus
# stress --cpu $(nproc) --timeout 900s

# Finished
echo "Finished ... "