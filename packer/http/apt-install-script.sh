#!/bin/bash
echo "this is the first line from the provision script"
echo 'packer' | sudo -S apt upgrade -y
echo 'packer' | sudo -S apt update -y
echo 'packer' | sudo -S apt-get remove docker docker-engine-docker.io -y
echo 'packer' | sudo -S apt update -y
echo 'packer' | sudo -S apt-get install docker.io -y
echo 'packer' | sudo -S snap install docker
echo 'packer' | sudo -S apt-get install net-tools -y
echo "this is the last line of the provision script"
