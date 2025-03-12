#!/usr/bin/bash
sudo apt update
sudo apt upgrade

sudo apt install -y qemu-kvm virt-manager libvirt-daemon-system virtinst libvirt-clients bridge-utils
sudo systemctl enable --now libvirtd
sudo systemctl start libvirtd

sudo usermod -aG kvm $USER
sudo usermod -aG libvirt $USER
