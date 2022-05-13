#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"

sudo apt-get update 
sudo apt-get install nginx -y 

cat <<  EOF >  index.html 
<html>
    <title> Career IT </title>
    <body>
        <h1> Welcome to Career IT </h1>

        <h2> Terraform Demo </h2>
    </body>
</html>

EOF

sudo rm /var/www/html/*.html

sudo cp index.html /var/www/html/