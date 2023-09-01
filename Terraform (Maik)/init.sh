#!/bin/bash

sudo yum check-update 
sudo yum update 
sudo yum install nginx -y

sudo yum clean metadata

sudo yum install php php-cli php-mysqlnd php-pdo php-common php-fpm -y
sudo yum install php-gd php-mbstring php-xml php-dom php-intl php-simplexml -y

sudo systemctl start nginx
sudo systemctl enable nginx

sudo systemctl start php-fpm
sudo systemctl enable php-fpm

sudo rm -r /usr/share/nginx/html/index.html

echo '

<?php
$context = stream_context_create([
    'http' => [
        'method' => 'PUT',
        'header' => 'X-aws-ec2-metadata-token-ttl-seconds: 21600'
    ]
]);
$token = file_get_contents('http://169.254.169.254/latest/api/token', false, $context);
$localIPv4 = file_get_contents('http://169.254.169.254/latest/meta-data/local-ipv4');
$local_hostname = file_get_contents('http://169.254.169.254/latest/meta-data/local-hostname');
$ami_id = file_get_contents('http://169.254.169.254/latest/meta-data/ami-id');
$ami_launch_index = file_get_contents('http://169.254.169.254/latest/meta-data/ami-launch-index');
$ami_manifest_path = file_get_contents('http://169.254.169.254/latest/meta-data/ami-manifest-path');
$block_device_mapping = file_get_contents('http://169.254.169.254/latest/meta-data/block-device-mapping');
$events = file_get_contents('http://169.254.169.254/latest/meta-data/events');
$hostname = file_get_contents('http://169.254.169.254/latest/meta-data/hostname');
$iam = file_get_contents('http://169.254.169.254/latest/meta-data/iam');
$instance_action = file_get_contents('http://169.254.169.254/latest/meta-data/instance-action');
$instance_id = file_get_contents('http://169.254.169.254/latest/meta-data/instance-id');
$instance_life_cycle = file_get_contents('http://169.254.169.254/latest/meta-data/instance-life-cycle');
$instance_type = file_get_contents('http://169.254.169.254/latest/meta-data/instance-type');
$mac = file_get_contents('http://169.254.169.254/latest/meta-data/mac');
$metrics = file_get_contents('http://169.254.169.254/latest/meta-data/metrics');
$network = file_get_contents('http://169.254.169.254/latest/meta-data/network');
$placement = file_get_contents('http://169.254.169.254/latest/meta-data/placement');
$profile = file_get_contents('http://169.254.169.254/latest/meta-data/profile');
$public_hostname = file_get_contents('http://169.254.169.254/latest/meta-data/public-hostname');
$public_ipv4 = file_get_contents('http://169.254.169.254/latest/meta-data/public-ipv4');
$public_keys = file_get_contents('http://169.254.169.254/latest/meta-data/public-keys');
$reservation_id = file_get_contents('http://169.254.169.254/latest/meta-data/reservation-id');
$security_groups = file_get_contents('http://169.254.169.254/latest/meta-data/security-groups');
$services = file_get_contents('http://169.254.169.254/latest/meta-data/services');
?>

' | sudo tee /usr/share/nginx/html/metadata.php

echo '

<!DOCTYPE html>
<html lang="de">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EC2 Instance Metadaten</title>
    <style>
        p {
            color: white;
            font-family: "Lucida Console", "Courier New", monospace;
        }

        h1 {
            color: green;
            font-family: Helvetica;
        }
    </style>
</head>

<body style="background-color:rgb(0, 42, 48);">
    <?php include 'metadata.php'?>
    <center>
        <h1>EC2 Metadaten für die Maschine mit der IP: <?php echo $localIPv4; ?></h1>
    </center>
    <div style="text-align: center;">
        <div style="display: inline-block; text-align: left; border: 1px solid white; padding:10px;">
            <p>Token: <?php echo $token; ?></p>
            <p>Local IPv4: <?php echo $localIPv4; ?></p>
            <p>Local Hostname: <?php echo $local_hostname; ?></p>
            <p>AMI ID: <?php echo $ami_id; ?></p>
            <p>AMI Launch Index: <?php echo $ami_launch_index; ?></p>
            <p>AMI MANIFEST PATH: <?php echo $ami_manifest_path; ?></p>
            <p>Block Device Mapping: <?php echo $block_device_mapping; ?></p>
            <p>Events: <?php echo $events; ?></p>
            <p>Hostname: <?php echo $hostname; ?></p>
            <p>IAM: <?php echo $iam; ?></p>
            <p>Instance Action: <?php echo $instance_action; ?></p>
            <p>Instance ID: <?php echo $instance_id; ?></p>
            <p>Instance Life Cycle: <?php echo $instance_life_cycle; ?></p>
            <p>Instance Typ: <?php echo $instance_type; ?></p>
            <p>MAC: <?php echo $mac; ?></p>
            <p>Metrics: <?php echo $metrics; ?></p>
            <p>Network: <?php echo $network; ?></p>
            <p>Placement: <?php echo $placement; ?></p>
            <p>Profile: <?php echo $profile; ?></p>
            <p>Public Hostname: <?php echo $public_hostname; ?></p>
            <p>Public IPv4: <?php echo $public_ipv4; ?></p>
            <p>Public Keys: <?php echo $public_keys; ?></p>
            <p>Reservation ID: <?php echo $reservation_id; ?></p>
            <p>Security Groups: <?php echo $security_groups; ?></p>
            <p>Services: <?php echo $services; ?></p>
        </div>
    </div>
</body>

</html>

<!-- AWS Abrufen von Metadaten - Professionell gebastelt von Maik :-) -->
<!-- https://docs.aws.amazon.com/de_de/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html -->

' | sudo tee /usr/share/nginx/html/index.html


sudo systemctl restart nginx.service