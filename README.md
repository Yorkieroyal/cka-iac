# cka-iac
Packer pipeline to take an ubuntu release 20.04 and provision docker.io, kubeadm 1.22.1-00, kubelet 1.22.0-00 and kubectl 1.22.0-00. Then create a useable .ovf in the vagrant .box format.  

Terraform pipeline to create a three node [1 x control, 2 x worker] cluster using the .box images created by packer. 

Install scripts to use kubeadm to create a cluster running 1.22.0-00 on a docker runtime using dockershim.

# requirements

packer version 1.8.6 

terraform version 1.2.1 

virtualbox version 6.1 

macos 12.5.1 


