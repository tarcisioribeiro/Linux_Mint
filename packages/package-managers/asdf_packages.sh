#!/usr/bin/bash
set -euo pipefail

# Carregar ASDF no ambiente atual
if [ -f "$HOME/.asdf/asdf.sh" ]; then
    . "$HOME/.asdf/asdf.sh"
fi

# Função para adicionar plugin se não existir
add_plugin_if_not_exists() {
    local plugin_name="$1"
    local plugin_url="${2:-}"

    if ! asdf plugin list | grep -q "^${plugin_name}$"; then
        echo "Adicionando plugin: $plugin_name"
        if [ -n "$plugin_url" ]; then
            asdf plugin add "$plugin_name" "$plugin_url"
        else
            asdf plugin add "$plugin_name"
        fi
    else
        echo "Plugin $plugin_name já existe, pulando..."
    fi
}

asdf reshim

# Adicionar plugins
add_plugin_if_not_exists neovim
add_plugin_if_not_exists python
add_plugin_if_not_exists java "https://github.com/halcyon/asdf-java.git"
add_plugin_if_not_exists nodejs "https://github.com/asdf-vm/asdf-nodejs.git"
add_plugin_if_not_exists golang "https://github.com/asdf-community/asdf-golang.git"

asdf reshim
asdf install java oracle-21
asdf install neovim stable
asdf install nodejs 23.9.0
asdf install python 3.10.12
asdf install golang 1.23.0
asdf reshim
asdf set --global java oracle-21
asdf set --global neovim stable
asdf set --global nodejs 23.9.0
asdf set --global python 3.10.12
asdf set --global golang 1.23.0
