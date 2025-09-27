#!/usr/bin/env bash

KEYBINDINGS_FILE="$HOME/Development/Linux_Mint/I3_KEYBINDINGS.md"
KITTY_PATH="$HOME/Development/kitty/kitty/launcher/kitty"

# Verificar se o arquivo de keybindings existe
if [[ ! -f "$KEYBINDINGS_FILE" ]]; then
  notify-send "Erro" "Arquivo de keybindings não encontrado!" -i error
  exit 1
fi

# Abrir kitty em janela flutuante e centralizada
"$KITTY_PATH" \
  --class "i3-keybindings-viewer" \
  --title "I3WM - Atalhos de Teclado" \
  --override initial_window_width=1200 \
  --override initial_window_height=800 \
  --override remember_window_size=no \
  --override window_padding_width=20 \
  --override background_opacity=0.95 \
  bash -c "/home/linuxbrew/.linuxbrew/bin/glow -p '$KEYBINDINGS_FILE'; read -p 'Pressione Enter para fechar...'"

