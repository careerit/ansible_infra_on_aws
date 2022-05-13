#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"
sudo apt-get update && sudo apt-get install python3 -y

sudo apt-get install -y python3-pip  software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get update && sudo apt install ansible -y