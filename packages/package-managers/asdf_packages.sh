#!/usr/bin/bash

git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.10.2

export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
. /home/tarcisio/.asdf/asdf.sh

cd "$HOME/repos/Ubuntu/customization"

asdf reshim

asdf plugin add neovim
asdf plugin add java https://github.com/halcyon/asdf-java.git
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git

asdf reshim

asdf install java oracle-21
asdf install neovim stable
asdf install nodejs 23.9.0

asdf reshim

asdf global java oracle-21
asdf global neovim stable
asdf global nodejs 23.9.0
