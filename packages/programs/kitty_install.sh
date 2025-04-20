#!/bin/bash

# Variáveis
DEV_DIR="$HOME/development"
REPO_DIR="$DEV_DIR/kitty"
DESKTOP_FILE="$HOME/.local/share/applications/kitty.desktop"
EXEC_BIN="$REPO_DIR/launcher/kitty"
ICON_PATH="$REPO_DIR/launcher/kitty.png"

# Cria a pasta development se não existir
mkdir -p "$DEV_DIR"

echo "Clonando repositório em $REPO_DIR..."
git clone https://github.com/kovidgoyal/kitty.git "$REPO_DIR" || {
  echo "Erro ao clonar."
  exit 1
}

cd "$REPO_DIR" || exit 1

echo "Compilando kitty..."
./dev.sh build || {
  echo "Erro na build."
  exit 1
}

echo "Criando link simbólico em ~/bin (se existir)..."
mkdir -p "$HOME/bin"
ln -sf "$EXEC_BIN" "$HOME/bin/kitty"

echo "Criando atalho no menu de aplicativos..."
mkdir -p "$(dirname "$DESKTOP_FILE")"

cat >"$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Kitty Terminal
GenericName=Terminal Emulator
Comment=Fast, feature-rich, GPU based terminal
Exec=$EXEC_BIN
Icon=$ICON_PATH
Categories=System;TerminalEmulator;
StartupNotify=true
StartupWMClass=kitty
EOF

echo "Atualizando cache de atalhos..."
update-desktop-database ~/.local/share/applications 2>/dev/null || echo "Você pode precisar reiniciar a sessão."

echo "Instalação concluída! Rode 'kitty' via ~/bin/kitty ou pelo menu de aplicativos."
