#!/usr/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386 -y
sudo cp /mnt/sda1/Packages/android-studio.tar.gz ~/Downloads
sudo tar -xzvf android-studio.tar.gz -C /opt
cd /opt
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils -y
./android-studio/bin/studio.sh
flutter doctor --android-licenses
cd ~/Downloads/
rm android-studio.tar.gz
