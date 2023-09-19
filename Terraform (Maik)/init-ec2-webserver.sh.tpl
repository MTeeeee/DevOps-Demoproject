#!/bin/bash

#set -e
set -x

# Holt sich die IP vom Backend
#echo 'const ip = "${ip_address_backend}";' > /home/ec2-user/ip_from_backend.js
echo "const ip = \"${ip_address_backend}\";" > /home/ec2-user/ip_from_backend.js &&
echo "export default ip;" >> /home/ec2-user/ip_from_backend.js  &&

# Copy "ip_from_backend.js" in AWS S3 Bucket
aws s3 cp /home/ec2-user/ip_from_backend.js s3://s3-bucket-aws-terraform-frontend/frontend_files/


# hier weitere Befehle hinzufügen

# Variablen
nginx_log_dir="/var/log/nginx"
nginx_conf_dir="/etc/nginx/conf.d"
nginx_html_dir="/usr/share/nginx/html"

# Updates und Installationen
sudo yum check-update 
sudo yum update 
sudo yum install nginx -y
sudo yum clean metadata


# Erstelle die Nginx-Konfigurationsdatei
# Um einen Error auszulösen kann folgender Befehl im der Konsole genutzt werden:
# curl -I http://0.0.0.0/WOBINICH.html

# Starte Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Lösche die Standard-Index.html Datei
# sudo rm -rf "$nginx_html_dir/index.html"

# Starte Nginx neu
sudo systemctl restart nginx.service

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

# Kopiert die Dateien der WebSite in den richtigen Ordner
sleep 400
sudo aws s3 cp s3://s3-bucket-aws-terraform-frontend/frontend_files/ /usr/share/nginx/html/ --recursive

# Finished
echo "Finished ... "