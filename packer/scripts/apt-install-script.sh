#!/bin/bash

echo "this is the first line from the provision script"
echo 'packer' | sudo -S curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
echo 'packer' | sudo -S apt upgrade -y
echo 'packer' | sudo -S apt update -y
echo 'packer' | sudo -S apt-get remove docker docker-engine-docker.io -y
echo 'packer' | sudo -S apt update -y
echo 'packer' | sudo -S apt-get install docker.io -y
echo 'packer' | sudo -S snap install docker
echo 'packer' | sudo -S apt-get install kubeadm=1.22.1-00 kubelet=1.22.1-00 kubectl=1.22.1-00 -y
echo 'packer' | sudo -S apt-mark hold kubelet kubeadm kubectl
echo 'packer' | sudo -S add-apt-repository multiverse -y
echo 'packer' | sudo -S apt-get update -y
#move the docker daemon.json file now there is a target directory
echo 'packer' | sudo -S mv /tmp/daemon.json /etc/docker/
echo "this is the last line of the provision script, but before reboot"
