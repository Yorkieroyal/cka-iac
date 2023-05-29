#!/bin/bash
#short script to reboot
echo "this is the first line of the reboot script"
sleep 10
echo "ive just slept for 10"
echo 'packer' | sudo -S reboot
sleep 5
echo "ive just slept for 5"
echo "this is the last line of the reboot script"
