#!/bin/bash

ssh_key="/opt/mylab/keys/mycloudops"
hostsFile="hosts"
cd Terraform

terraform validate 

if [ $? -eq 0 ]
then
    echo -e "Valid Configuration\nProceeding to deploy"
    terraform apply --auto-approve
    
else
    echo "Terraform Validation failed. exit Status: $?"
fi


# Get the Bastion IP
bastionIP=$(terraform output -raw bastion_Public_IP)

# Get the LB DNS Name
albDNS=$(terraform output -raw alb_dns)


# Generate hosts file
echo -e "[webservers]" > $hostsFile
terraform output web_IPs | sed '1,1d; $d; s/  \"//g; s/\",//g' >>  $hostsFile
echo -e "\n\n" >> $hostsFile 
echo -e "[dbservers]" >> $hostsFile
terraform output db_IPs | sed '1,1d; $d; s/  \"//g; s/\",//g' >> $hostsFile

# Check if ansible is installed 

while ! ssh -o StrictHostKeyChecking=no -i ${ssh_key} ubuntu@${bastionIP} ansible --version
do 
    echo "Ansible not yet ready......\nChecking Again"
done

# eval `ssh-agent`
# ssh-add ${ssh_key}

# Copy SSH Config file into the Server
rsync -avz --ignore-existing -e "ssh -i ${ssh_key} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress ../sshconfig ubuntu@${bastionIP}:~/.ssh/config
 
# Copy ssh Key for authentication with controlled nodes
rsync -avz --ignore-existing -e "ssh -i ${ssh_key} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress  ${ssh_key} ubuntu@${bastionIP}:~/


# Copy hosts file to the ansible controller.
rsync -avz -e "ssh -i ${ssh_key} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress  ${hostsFile} ubuntu@${bastionIP}:~/

