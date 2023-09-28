import boto3
import paramiko
import tempfile
import json
import os

def lambda_handler(event, context):
    ssm_client = boto3.client('ssm')
    
    # Standard-Antwortobjekt erstellen
    response = {
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,GET,PUT,POST,DELETE,PATCH,HEAD',
            'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'
        }
    }
    
    client = None
    
    try:
        # Hole den privaten Schlüssel aus dem Parameter Store
        private_key_str = ssm_client.get_parameter(
            Name='DevOps-Project-Key-Control-Node',
            WithDecryption=True
        )['Parameter']['Value']
        
        # Schreibe den privaten Schlüssel in eine temporäre Datei
        with tempfile.NamedTemporaryFile('w', delete=True) as temp_key_file:
            temp_key_file.write(private_key_str)
            temp_key_file.flush()
    
            # Erstelle ein SSH-Client-Objekt
            key = paramiko.RSAKey(filename=temp_key_file.name)
            client = paramiko.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        
        # Verbindung zur EC2-Instanz herstellen
        client.connect(os.environ['EC2_INSTANCE_IP'], username='ec2-user', pkey=key)

        # Überprüfe, ob die Datei /tmp/ssh_data.txt existiert
        sftp = client.open_sftp()
        if not sftp.file('/tmp/ssh_data.txt'):
            raise Exception("Die Datei /tmp/ssh_data.txt existiert nicht.")
        
        # Lese den Inhalt der Datei
        with sftp.file('/tmp/ssh_data.txt', 'r') as file:
            ssh_data = file.read().decode()
        
        sftp.close()

        response['statusCode'] = 200
        response['body'] = json.dumps({
            'message': 'SSH Daten erfolgreich abgerufen',
            'ssh_data': ssh_data
        })
        
    except Exception as e:
        response['statusCode'] = 500
        response['body'] = json.dumps({
            'error': f"Ein Fehler ist aufgetreten: {str(e)}"
        })
        
    finally:
        if client:
            client.close()
        
    return response
