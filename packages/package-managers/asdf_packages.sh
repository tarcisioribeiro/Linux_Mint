#!/usr/bin/bash
asdf reshim

asdf plugin add neovim
asdf plugin add java https://github.com/halcyon/asdf-java.git
asdf plugin-add php https://github.com/asdf-community/asdf-php.git
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git

asdf install java oracle-21
asdf install neovim stable
asdf install nodejs 23.9.0
asdf install php 8.4.4

asdf reshim
