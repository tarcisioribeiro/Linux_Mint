#!/usr/bin/bash
asdf reshim
asdf plugin add neovim
asdf plugin add python
asdf plugin add java https://github.com/halcyon/asdf-java.git
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
asdf reshim
asdf install java oracle-21
asdf install neovim stable
asdf install nodejs 23.9.0
asdf install python 3.10.12
asdf install golang 1.23.0
asdf reshim
asdf global java oracle-21
asdf global neovim stable
asdf global nodejs 23.9.0
asdf global python 3.10.12
asdf global golang 1.23.0
