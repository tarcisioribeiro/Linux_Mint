#!/usr/bin/bash

set -e

sudo apt update
sudo apt upgrade -y

brew install fd git-delta vim lazygit eza onefetch tldr zoxide asdf fastfetch glow

pip install pyautogui

sleep 2

cd $HOME/Downloads/
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

sudo apt-get update && sudo apt-get install -y --no-install-recommends \
  curl \
  gnupg2

curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg &&
  curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list |
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt update

export NVIDIA_CONTAINER_TOOLKIT_VERSION=1.18.2-1
sudo apt-get install -y \
  nvidia-container-toolkit=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
  nvidia-container-toolkit-base=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
  libnvidia-container-tools=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
  libnvidia-container1=${NVIDIA_CONTAINER_TOOLKIT_VERSION}

docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
docker exec -it ollama ollama run llama2

cd /media/tarcisio/Seagate/Linux/Customization/grub/
sudo mkdir -p /boot/grub/themes/
sudo cp -r dracula /boot/grub/themes/
sudo cp grub /etc/default/
sudo grub-mkconfig -o /boot/grub/grub.cfg

sleep 2

sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

cd $HOME/Development/Linux_Mint/scripts/installer
python3 main.py

sudo mkdir -p /etc/X11/xorg.conf.d/
cd /media/tarcisio/Seagate/Linux/Utilities/
sudo cp 10-intel-prime.conf /etc/X11/xorg.conf.d/
sudo cp 10-modesetting.conf /etc/X11/xorg.conf.d/
sudo cp 20-serverflags.conf /etc/X11/xorg.conf.d/
sudo cp xorg.conf /etc/X11/

gsettings set org.cinnamon.muffin unredirect-fullscreen-windows false

cd /media/tarcisio/Seagate/Linux/Utilities/block-bad-sites/

sudo python3 block.py

curl -sS https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

sudo apt-get update && sudo apt-get install spotify-client

sleep 10

curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh

sleep 10

spicetify
spicetify update
spicetify upgrade
spicetify apply

mkdir -p "$HOME/.config/spicetify/Themes"
cp -r /media/tarcisio/Seagate/Linux/Customization/spicetify/Dracula/ "$HOME/.config/spicetify/Themes/"
spicetify config current_theme Dracula
spicetify config current_theme Dracula

sleep 15

sudo reboot now
