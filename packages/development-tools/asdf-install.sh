#!/usr/bin/bash
cd ~/Downloads
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2
source ~/.bashrc
sleep 5
asdf plugin add java https://github.com/halcyon/asdf-java.git

