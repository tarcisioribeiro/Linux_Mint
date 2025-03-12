#!/usr/bin/bash
# Update repos
sudo apt update

# Necessary Packages
sudo apt install apt-transport-https ca-certificates curl software-properties-common

# Adding docker GPG Key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Adding docker to APT repos
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

# Update APT
sudo apt update

# Installing Docker
sudo apt install docker-ce

# Adding user to docker
sudo usermod -aG docker "${USER}"
su - "${USER}"
