#!/bin/bash

# Script ends after Error
#set -e
set -x

# Create "ip_from_postgres.js" with IP and Export from PostgreSQL for Backend Server
echo -e "const ip = \"${ip_address_postgresql}\";\nexports.ip = ip;" > /home/ec2-user/ip_from_postgres.js

# EC2 Update
sudo yum update -y

# Install NodeJS
sudo yum install nodejs -y

# Copy "ip_from_postgres.js" to Folder /home/ec2-user/server/
cp /home/ec2-user/ip_from_postgres.js /home/ec2-user/server/ip_from_postgres.js

# Change Directory (In this folder are files for the backend)
cd /home/ec2-user/server/

# Install Dependencys
npm install

# Start NodeJS with Logging
node server.js >> output.log 2>> errors.log &

sleep 180

# Build Website Frontend
cd /home/ec2-user/client/src/ 
aws s3 cp s3://s3-bucket-aws-terraform-frontend/frontend_files/ip_from_backend.js /home/ec2-user/ip_from_backend.js &&
cp /home/ec2-user/ip_from_backend.js /home/ec2-user/client/src/ &&
cp /home/ec2-user/ip_from_postgres.js /home/ec2-user/client/src/ &&
npm install &&
npm run build &&
sleep 5

# Copy Frontend Files in AWS S3 Bucket
aws s3 sync /home/ec2-user/client/build/ s3://s3-bucket-aws-terraform-frontend/frontend_files/

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