#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install toilet curl wget -y

title_green() {
  clear
  echo ""
  echo -e "\033[32m$(toilet --font pagga --filter border --width 200 "$1")\033[0m"
  echo ""
  sleep 5
}

title() {
  clear
  echo ""
  echo -e "$(toilet --font pagga --filter border --width 200 "$1")"
  echo ""
  sleep 5
}

green() {
  clear
  echo ""
  echo -e "\033[32m$1\033[0m"
  echo ""
  sleep 5
}

blue() {
  clear
  echo ""
  echo -e "\033[34m$1\033[0m"
  echo ""
  sleep 5
}

title "Instalação - Parte 1"

sudo apt install build-essential gcc g++ clang make cmake automake autoconf \
  git wget curl stow pkg-config meson ninja-build scdoc \
  neofetch tmux rofi fzf bat gdebi feh nitrogen polybar redshift \
  gnome-tweaks gnome-shell-extension-manager \
  mpv vlc shotcut obs-studio cava flatpak \
  deluge deluged deluge-web deluge-console \
  timeshift openssh-server mysql-server default-libmysqlclient-dev \
  dkms perl nodejs npm ruby-full libsdl2-dev libusb-1.0-0-dev \
  adb cpu-checker qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils \
  ffmpeg libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev libswresample-dev \
  gimp libgtk-3-dev libgtk-4-dev libadwaita-1-dev \
  python3 python3-venv python3-tk python3-pip python3-openssl python3.10-full python3.10-dev \
  libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncurses5-dev libncursesw5-dev \
  libffi-dev liblzma-dev tk-dev \
  libxcb1-dev libxcb-keysyms1-dev libxcb-util0-dev libxcb-icccm4-dev \
  libxcb-randr0-dev libxcb-xinerama0-dev libpango1.0-dev libx11-dev \
  libxrandr-dev libxinerama-dev libxss-dev libglib2.0-dev libev-dev \
  libxcb-cursor-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
  libxcb-xrm0 libxcb-xrm-dev libxcb-shape0-dev libconfig-dev \
  libdbus-1-dev libegl-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev \
  libx11-xcb-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-glx0-dev \
  libxcb-image0-dev libxcb-present-dev libxcb-render0-dev \
  libxcb-render-util0-dev libxcb-util-dev libxcb-xfixes0-dev uthash-dev \
  libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev -y

sudo apt remove libmagickcore-6.q16-6 imagemagick-6.q16 imagemagick-6-common imagemagick idle-python3.10 -y

sudo apt install zsh -y && sleep 5 && chsh -s /usr/bin/zsh
blue "Instalando o Oh My ZSH..."
sh packages/oh_my_zsh_install.sh

blue "Instalando o Oh My Posh..."
sudo wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh && mkdir ~/.poshthemes
wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes && chmod u+rw ~/.poshthemes/*.omp.*
rm ~/.poshthemes/themes.zip && ln ~/repos/Ubuntu/customization/zsh/tj-dracula.omp.json ~/.poshthemes/tj-dracula.omp.json

# Diretórios
cd ~ && mkdir -p ~/repos && mkdir -p ~/.icons && mkdir -p ~/.themes && mkdir -p ~/scripts

# Fontes
cd ~/repos/Ubuntu/fonts
sudo cp JetBrains_Mono_Medium_Nerd_Font_Complete_Mono_Windows_Compatible.ttf /usr/share/fonts/
sudo cp JetBrainsMonoNerdFontMono-Bold.ttf /usr/share/fonts/
sudo cp JetBrainsMonoNerdFontMono-BoldItalic.ttf /usr/share/fonts/
sudo cp JetBrainsMonoNerdFontMono-Italic.ttf /usr/share/fonts

# logo-ls
cp ~/repos/Ubuntu/customization/bash/logo-ls_Linux_x86_64.tar.gz ~/Downloads
cd ~/Downloads && tar -zxf logo-ls_Linux_x86_64.tar.gz
cd ~/Downloads/logo-ls_Linux_x86_64 && sudo cp logo-ls /usr/local/bin
cd ~/Downloads && rm -r logo-ls_Linux_x86_64 && rm logo-ls_Linux_x86_64.tar.gz

blue "Ativando o acesso aos apps Flatpak..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

blue "Instalando o Neovim..."
cd ~/Downloads && git clone https://github.com/neovim/neovim.git && cd neovim
make CMAKE_BUILD_TYPE=Release && sudo make install
cd ~/Downloads && sudo rm -r neovim

blue "Instalando o NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

cd ~/repos/Ubuntu

blue "Instalando o HomeBrew..."
sh packages/brew_install.sh

blue "Instalando o Oh My Bash..."
sh packages/oh_my_bash_install.sh

blue "Instalando o Starship..."
sh packages/starship_install.sh

# Arquivos de customização dos shells
rm ~/.zshrc && rm ~/.zsh_aliases && rm ~/.bashrc && rm ~/.bash_aliases
cd ~/repos/Ubuntu/customization
ln zsh/.zshrc ~/.zshrc && ln zsh/.zsh_aliases ~/.zsh_aliases
ln bash/.bashrc ~/.bashrc && ln bash/.bash_aliases ~/.bash_aliases
ln tmux/.tmux.conf ~/.tmux.conf
ln starship/starship.toml ~/.config/starship.toml
ln git/.gitconfig ~/.gitconfig

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux new-session -d -s "dev" && sleep 5 tmux source ~/.tmux.conf && sleep 5 && tmux kill-session -t "dev"

source ~/.bashrc

title "Instalação - Parte 2"
brew install eza glow tldr fd git-delta zoxide yazi
brew install jstkdng/programs/ueberzugpp
cd ~/Downloads
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
rm ~/Downloads/lazygit && rm ~/Downloads/lazygit.tar.gz && nvm install 20.17.0

blue "Instalando o i3wm..."
/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2024.03.04_all.deb keyring.deb SHA256:f9bb4340b5ce0ded29b7e014ee9ce788006e9bbfe31e96c09b2118ab91fca734
cd ~/Downloads && sudo apt install ./keyring.deb
echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
sudo apt update && sudo rm keyring.deb && sudo apt install i3 i3lock

blue "Instalando o i3lock-color..."
cd ~/Downloads && git clone https://github.com/Raymo111/i3lock-color.git && cd i3lock-color
./build.sh && ./install-i3lock-color.sh && cd ~/Downloads && sudo rm -r i3lock-color

"Instalando gaps do i3..."
cd ~/Downloads && git clone https://www.github.com/jbenden/i3-gaps-rounded i3-gaps && cd i3-gaps
mkdir -p build && cd build && meson .. && ninja
sudo ninja install && cd ~/Downloads && sudo rm -r i3-gaps

blue "Instalando o Speed Test..."
cp ~/repos/Ubuntu/packages/speed_test.tgz ~/Downloads
cd ~/Downloads && sudo tar -xvzf speed_test.tgz -C /usr/bin && rm speed_test.tgz

blue "Baixando o Flutter..."
mkdir -p ~/development && cd ~/Downloads
wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.27.1-stable.tar.xz
tar -xf ~/Downloads/flutter_linux_3.27.1-stable.tar.xz -C ~/development/
rm flutter_linux_3.27.1-stable.tar.xz && sudo rm -r Dracula

blue "Instalando o picom..."
cd ~/Downloads && git clone https://github.com/yshui/picom.git && cd picom
meson setup --buildtype=release build && sudo ninja -C build && sudo ninja -C build install
cd ~/Downloads && sudo rm -r picom/

blue "Instalando o Alacritty..."
cd ~/Downloads/ && git clone https://github.com/alacritty/alacritty.git
cd alacritty && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.bashrc && sleep 5 && cargo build --release
sudo cp target/release/alacritty /usr/local/bin
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
sudo mkdir -p /usr/local/share/man/man1
sudo mkdir -p /usr/local/share/man/man5
scdoc <extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz >/dev/null
scdoc <extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz >/dev/null
scdoc <extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz >/dev/null
scdoc <extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz >/dev/null

blue "Instalando o scrcpy..."
cd ~/Downloads
git clone https://github.com/Genymobile/scrcpy
cd scrcpy
./install_release.sh
cd ~/Downloads
sudo rm -r scrcpy

# Arquivos de configuração
cd ~/repos/Ubuntu/stow
mkdir -p ~/.config/autostart && stow -v -t ~/.config/autostart autostart
mkdir -p ~/.config/btop && stow -v -t ~/.config/btop btop
mkdir -p ~/.config/cava && stow -v -t ~/.config/cava cava
mkdir -p ~/.config/dunst && stow -v -t ~/.config/dunst dunst
mkdir -p ~/.config/gtk-3.0 && stow -v -t ~/.config/gtk-3.0 gtk-3.0
mkdir -p ~/.config/i3 && stow -v -t ~/.config/i3 i3
mkdir -p ~/.config/alacritty && stow -v -t ~/.config/alacritty alacritty
mkdir -p ~/.config/nitrogen && stow -v -t ~/.config/nitrogen nitrogen
mkdir -p ~/.config/nvim && stow -v -t ~/.config/nvim nvim
mkdir -p ~/.config/polybar && stow -v -t ~/.config/polybar polybar
mkdir -p ~/.config/rofi && stow -v -t ~/.config/rofi rofi
ln picom.conf ~/.config/picom.conf

cd ~/repos/Ubuntu/
mkdir -p ~/Pictures && stow -v -t ~/Pictures wallpapers
mkdir -p ~/scripts && stow -v -t ~/scripts scripts

# Tema Dracula
cd ~/Downloads/
wget -q https://github.com/dracula/gtk/archive/master.zip
unzip master.zip && mv gtk-master Dracula && mv Dracula ~/.themes
rm master.zip && cd ~/Downloads && git clone https://github.com/vinceliuice/Tela-icon-theme.git
cd Tela-icon-theme && ./install.sh -n dracula && cd ..
sudo rm -r Tela-icon-theme

gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
gsettings set org.gnome.desktop.wm.preferences theme "Dracula"
gsettings set org.gnome.desktop.interface icon-theme "dracula-dark"
gsettings set org.gnome.desktop.interface font-name "JetBrainsMono NFM"

blue "Instalando pacotes via Flatpak..."
flatpak install flathub io.github.shiftey.desktop
flatpak install flathub org.telegram.desktop
flatpak install flathub net.pcsx2.PCSX2
flatpak install flathub com.snes9x.Snes9x
flatpak install flathub org.duckstation.DuckStation

blue "Instalando pacotes .deb..."
cp /mnt/sda1/Packages/*.deb ~/Downloads/
cd ~/Downloads/
sudo gdebi chrome.deb
sudo gdebi code.deb
sudo gdebi discord.deb
sudo gdebi obsidian.deb
sudo gdebi upscayl.deb

blue "Gerando chave SSH..."
ssh-keygen
sudo ufw enable && sudo ufw allow OpenSSH

blue "Removendo o Snap..."
cd ~/repos/Ubuntu/packages
sh remove_snapd.sh

title_green "Instalação concluída."

read -p "Reiniciar agora? (s/n): " choice
if [[ "$choice" == "s" ]]; then
  sudo reboot
fi
