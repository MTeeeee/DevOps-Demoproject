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
            'Content-Type': 'application/json',  # Ändern Sie den Content-Type
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,GET,PUT,POST,DELETE,PATCH,HEAD',
            'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'
        }
    }
    
    client = None  # Initialisieren Sie client mit None, damit Sie später überprüfen können, ob es definiert wurde.
    
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
    
            # Erstelle ein SSH-Client-Objekt mit dem temporären Schlüssel-Dateipfad
            key = paramiko.RSAKey(filename=temp_key_file.name)
            client = paramiko.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        
        # Verbindung zur EC2-Instanz herstellen
        client.connect(os.environ['EC2_INSTANCE_IP'], username='ec2-user', pkey=key)

        # Befehl ausführen, um eine Textdatei zu erstellen
        stdin, stdout, stderr = client.exec_command('echo "Hier ist mein Text" > /home/ec2-user/HelloFromLambda.txt')
        
        # Überprüfen, ob es Fehler in stderr gibt
        err = stderr.read().decode()
        if err:
            raise Exception(f"SSH command error: {err}")
        
        response['statusCode'] = 200
        response['body'] = json.dumps({  # Formatieren Sie die Antwort als JSON-String
            'message': 'Textdatei wurde erfolgreich erstellt!'
        })
        
    except Exception as e:
        response['statusCode'] = 500
        response['body'] = json.dumps({  # Formatieren Sie die Fehlermeldung als JSON-String
            'error': f"Ein Fehler ist aufgetreten: {str(e)}"
        })
        
    finally:
        if client:  # Überprüfen Sie, ob client tatsächlich erstellt wurde, bevor Sie versuchen, es zu schließen.
            client.close()
        
    return response
