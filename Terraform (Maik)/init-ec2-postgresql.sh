#!/bin/bash

#!/bin/bash

#set -e
set -x

# Wechsel zum User "ROOT"
# sudo su

# Aktualisieren Sie die Paketquellen
sudo yum update -y

# Wechseln Sie zurück in das ursprüngliche Arbeitsverzeichnis
cd ~

# Installieren Sie PostgreSQL
sudo yum install postgresql15-server.x86_64 postgresql15-contrib.x86_64 -y

# Initialisieren Sie die PostgreSQL-Datenbank
sudo /usr/bin/postgresql-setup --initdb &&

# Starten Sie den PostgreSQL-Dienst
sudo systemctl start postgresql &&

# Aktivieren Sie den PostgreSQL-Dienst, um ihn nach dem Neustart automatisch zu starten
sudo systemctl enable postgresql &&

# Setzen Sie das Passwort für den PostgreSQL-Benutzer 'postgres' mit PGPASSWORD
export PGPASSWORD=AwS_22.10 &&

# Ändern Sie das Passwort für den Benutzer 'postgres' ohne Passwortabfrage
(cd /tmp && echo "ALTER USER postgres PASSWORD '$PGPASSWORD';" | sudo -u postgres psql) &&

# Ändern Sie die PostgreSQL-Konfiguration, um externe Verbindungen zuzulassen (nur für Testzwecke)
# Bitte stellen Sie sicher, dass Sie die Sicherheitsaspekte berücksichtigen, wenn Sie dies in einer Produktionsumgebung verwenden.
echo "host all all 0.0.0.0/0 md5" | sudo tee -a /var/lib/pgsql/data/pg_hba.conf &&

# Erlauben Sie dem PostgreSQL-Dienst, Verbindungen von externen IPs anzunehmen
echo "listen_addresses = '*'" | sudo tee -a /var/lib/pgsql/data/postgresql.conf &&

# Starte den PostgreSQL Dienst neu
sudo systemctl restart postgresql

# Erstellen Sie einen neuen PostgreSQL-Benutzer und eine neue Datenbank
export NEW_USERNAME=admindb &&
export NEW_PASSWORD=admin-pw &&
export NEW_DATABASE=usersdb &&
export TABLE_NAME=users

sudo -u postgres psql -c "CREATE USER $NEW_USERNAME WITH PASSWORD '$NEW_PASSWORD';" &&
sudo -u postgres psql -c "CREATE DATABASE $NEW_DATABASE;" &&

sudo -u postgres psql -d $NEW_DATABASE -c "CREATE TABLE users (
    id serial PRIMARY KEY,
    username VARCHAR(255),
    password VARCHAR(255)
);" &&

# Fügen Sie Datensätze in die Tabelle ein
#sudo -u postgres psql -d $NEW_DATABASE -c "INSERT INTO $TABLE_NAME (username, password) VALUES ('Admin', 'aws2210');"
#sudo -u postgres psql -d $NEW_DATABASE -c "INSERT INTO $TABLE_NAME (username, password) VALUES ('Mete', 'Passwort2');"
#sudo -u postgres psql -d $NEW_DATABASE -c "INSERT INTO $TABLE_NAME (username, password) VALUES ('Demo', 'Passwort3');"

sudo su - postgres -c "psql -d ${NEW_DATABASE} -c \"GRANT USAGE, SELECT ON SEQUENCE users_id_seq TO ${NEW_USERNAME};\"" &&
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $NEW_DATABASE TO $NEW_USERNAME;" &&
sudo -u postgres psql -d $NEW_DATABASE -c "GRANT ALL PRIVILEGES ON TABLE $TABLE_NAME TO $NEW_USERNAME;" &&

# Löschen der Variablen mit denen der neue User erstellt wurde
unset NEW_USERNAME &&
unset NEW_PASSWORD &&
unset NEW_DATABASE &&
unset PGPASSWORD &&

# Starte den PostgreSQL Dienst neu
sudo systemctl restart postgresql

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