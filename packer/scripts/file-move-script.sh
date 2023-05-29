#!/bin/bash

echo "this is the first line from the file move script"
echo 'packer' | sudo -S mv /tmp/kubernetes.list /etc/apt/sources.list.d/
echo 'packer' | sudo -S mv /tmp/calico.yaml /root/
echo "this is the last line of the file move script"