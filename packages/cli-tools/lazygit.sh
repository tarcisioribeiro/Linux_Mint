#!/usr/bin/bash
brew install eza glow tldr fd git-delta zoxide
brew install jstkdng/programs/ueberzugpp
cd ~/Downloads
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
rm ~/Downloads/lazygit
rm ~/Downloads/lazygit.tar.gz
nvm install 20.17.0