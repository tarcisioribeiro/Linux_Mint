#!/usr/bin/bash
mkdir -p ~/Development
cd ~/Downloads
wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.27.1-stable.tar.xz
tar -xf ~/Downloads/flutter_linux_3.27.1-stable.tar.xz -C ~/Development/
rm flutter_linux_3.27.1-stable.tar.xz
