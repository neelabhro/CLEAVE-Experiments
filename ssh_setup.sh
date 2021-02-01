#!/bin/bash

if [[ $# -lt 1 ]]; then
  echo "Need to provide IP address or SSH hostname of Raspberry Pi."
  exit 1
fi

echo "Setting up Raspberry Pi on $1"
ssh -oForwardX11=no "$1" mkdir -p /tmp/setup
scp ./config.txt ./sysctl.conf "$1":/tmp/setup/
ssh -oForwardX11=no "$1" "sudo mv /tmp/setup/config.txt /boot/config.txt && sudo mv /tmp/setup/sysctl.conf /etc/sysctl.conf && rm -rf /tmp/setup && sudo reboot"
echo "Raspberry Pi rebooting... Please wait."
sleep 30
echo "Done"
echo "Please verify changes:"
echo "The following command should output 'frequency(48)=2000478464'"
ssh -oForwardX11=no "$1" "vcgencmd measure_clock arm"
echo "The following command should output 'net.core.rmem_max = 26214400' and 'net.core.rmem_default = 26214400'"
ssh -oForwardX11=no "$1" "sudo sysctl net.core.rmem_max && sudo sysctl net.core.rmem_default"
