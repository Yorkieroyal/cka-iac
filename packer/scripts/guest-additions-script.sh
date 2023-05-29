#!/bin/bash
echo "this is the first line of the guest additions script"
#get linux kernal headers and basic developer tools
echo 'packer' | sudo -S apt-get install linux-headers-$(uname -r) build-essential dkms -y
#install guest additions for 6.1.32
#wget http://download.virtualbox.org/virtualbox/6.1.32/VBoxGuestAdditions_6.1.32.iso
echo 'packer' | sudo -S mkdir /media/VBoxGuestAdditions
#echo 'packer' | sudo -S mount -o loop,ro VBoxGuestAdditions_6.1.32.iso /media/VBoxGuestAdditions
echo 'packer' | sudo -S mount -o loop,ro VBoxGuestAdditions.iso /media/VBoxGuestAdditions
echo 'packer' | sudo -S sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
#echo 'packer' | sudo -S rm VBoxGuestAdditions_6.1.32.iso
#echo 'packer' | sudo -S rm VBoxGuestAdditions.iso
echo 'packer' | sudo -S umount /media/VBoxGuestAdditions
echo 'packer' | sudo -S rmdir /media/VBoxGuestAdditions
sleep 4
echo "ive just slept for 4"
echo 'packer' | sudo -S reboot
sleep 5
echo "ive just slept for 5"
echo "this is the last line of the guest additions script, but before reboot"
