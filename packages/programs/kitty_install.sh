#!/bin/bash

# Variáveis
DEV_DIR="$HOME/Development"
REPO_DIR="$DEV_DIR/kitty"
DESKTOP_FILE="$HOME/.local/share/applications/kitty.desktop"
EXEC_BIN="$REPO_DIR/kitty/launcher/kitty"
ICON_PATH="$HOME/.icons/dracula-icons/scalable/apps/kitty.svg"
Icon=/home/tarcisio/

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
Name=Kitty
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

cd "$DEV_DIR" || exit 1
cd Linux_Mint/stow
rm -rf "$HOME/.config/kitty" && mkdir -p "$HOME/.config/kitty" && stow -v -t "$HOME/.config/kitty" kitty
rm -rf "$HOME/bin/"

