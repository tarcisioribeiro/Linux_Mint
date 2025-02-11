#!/usr/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install toilet curl wget -y
clear

title_red() {
    echo -e "\033[31m$(toilet --font pagga --filter border --width 200 "$1")\033[0m"
}

title_green() {
    echo -e "\033[32m$(toilet --font pagga --filter border --width 200  "$1")\033[0m"
}

title_blue() {
    echo -e "\033[34m$(toilet --font pagga --filter border --width 200 "$1")\033[0m"
}

title() {
  echo -e "$(toilet --font pagga --filter border --width 200 "$1")"
}

red() {
    echo -e "\033[31m$1\033[0m"
}
green() {
    echo -e "\033[32m$1\033[0m"
}

blue() {
    echo -e "\033[34m$1\033[0m"
}

title "Instalação - Parte 1"

sudo apt install build-essential git neofetch gimp meson ninja-build curl tmux wget net-tools btop tilix rofi flatpak \
  python3-venv python3-tk python3-pip python3.10-full python3.10-dev dkms perl gcc make default-libmysqlclient-dev \
  libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncurses5-dev libncursesw5-dev llvm xz-utils tk-dev \
  libffi-dev liblzma-dev python3-openssl timeshift bat gdebi ruby-full nodejs npm fzf \
  gnome-tweaks gnome-shell-extension-manager mpv cava feh mysql-server openssh-server obs-studio \
  redshift vlc shotcut deluge deluged deluge-web deluge-console stow polybar nitrogen \
  libxcb1-dev libxcb-keysyms1-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev \
  libxcb-randr0-dev libxcb-xinerama0-dev libpango1.0-dev libx11-dev libxrandr-dev libxinerama-dev libxss-dev \
  libglib2.0-dev libev-dev libxcb-cursor-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf \
  libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev libconfig-dev cmake clang ninja libgtk3-dev libdbus-1-dev \
  libegl-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb-composite0-dev \
  libxcb-damage0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-render0-dev \
  libxcb-render-util0-dev libxcb-util-dev libxcb-xfixes0-dev uthash-dev -y

sudo apt remove libmagickcore-6.q16-6 imagemagick-6.q16 imagemagick-6-common imagemagick idle-python3.10 -y

sudo apt install zsh -y
chsh -s /usr/bin/zsh

clear && echo "" && blue "Instalando o Oh My ZSH..." && echo "" && sleep 3
~/Ubuntu/packages/oh_my_zsh_install.sh

clear && echo "" && blue "Instalando o Oh My Posh..." && echo "" && sleep 3
cd ~
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
mkdir ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.omp.*
rm ~/.poshthemes/themes.zip
ln ~/repos/Ubuntu/customization/zsh/tj-dracula.omp.json ~/.poshthemes/tj-dracula.omp.json

# Diretórios
cd ~
mkdir -p ~/repos
mkdir -p ~/.icons
mkdir -p ~/.themes
mkdir -p ~/scripts

# Fontes
cd ~/repos/Ubuntu/fonts
sudo cp JetBrains_Mono_Medium_Nerd_Font_Complete_Mono_Windows_Compatible.ttf /usr/share/fonts/
sudo cp JetBrainsMonoNerdFontMono-Bold.ttf /usr/share/fonts/
sudo cp JetBrainsMonoNerdFontMono-BoldItalic.ttf /usr/share/fonts/
sudo cp JetBrainsMonoNerdFontMono-Italic.ttf /usr/share/fonts

# logo-ls
cp ~/repos/Ubuntu/customization/bash/logo-ls_Linux_x86_64.tar.gz ~/Downloads
cd ~/Downloads
tar -zxf logo-ls_Linux_x86_64.tar.gz
cd ~/Downloads/logo-ls_Linux_x86_64
sudo cp logo-ls /usr/local/bin
cd ~/Downloads
rm -r logo-ls_Linux_x86_64
rm logo-ls_Linux_x86_64.tar.gz

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

clear && echo "" && blue "Instalando o Neovim..." && echo "" && sleep 3
cd ~/Downloads
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
rm nvim-linux64.tar.gz

clear && echo "" && blue "Instalando o NVM..." && echo "" && sleep 3
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

clear && echo "" && blue "Instalando o HomeBrew..." && echo "" && sleep 3
~/repos/Ubuntu/packages/brew_install.sh

clear && echo "" && blue "Instalando o Oh My Bash..." && echo "" && sleep 3
~/repos/Ubuntu/packages/oh_my_bash_install.sh

clear && echo "" && blue "Instalando o Starship..." && echo "" && sleep 3
~/repos/Ubuntu/packages/starship_install.sh

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Arquivos de customização dos shells
cd ~/repos/Ubuntu/customization
ln zsh/.zshrc ~/.zshrc
ln zsh/.zsh_aliases ~/.zsh_aliases
ln bash/.bashrc ~/.bashrc
ln bash/.bash_aliases ~/.bash_aliases
ln tmux/.tmux.conf ~/.tmux.conf
ln starship/starship.toml ~/.config/starship.toml
ln git/.gitconfig ~/.gitconfig

# Fontes
cd ~/repos/Ubuntu/fonts
sudo cp JetBrains_Mono_Medium_Nerd_Font_Complete_Mono_Windows_Compatible.ttf /usr/share/fonts
sudo cp DS-DIGIB.TTF /usr/share/fonts
sudo cp JetBrainsMonoNerdFontMono-Italic.ttf /usr/share/fonts
sudo cp JetBrainsMonoNerdFontMono-Bold.ttf /usr/share/fonts
sudo cp JetBrainsMonoNerdFontMono-BoldItalic.ttf /usr/share/fonts

source ~/.bashrc

clear
title "Instalação - Parte 2"
brew install eza glow tldr fd git-delta zoxide yazi
nvm install 20.17.0

mkdir -p ~/.config/tilix/schemes/
wget -qO $HOME"/.config/tilix/schemes/dracula.json" https://git.io/v7QaT

echo "" && blue "Instalando o i3wm..." && echo "" && sleep 3
/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2024.03.04_all.deb keyring.deb SHA256:f9bb4340b5ce0ded29b7e014ee9ce788006e9bbfe31e96c09b2118ab91fca734
cd ~/Downloads
sudo apt install ./keyring.deb
echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
sudo apt update
sudo rm keyring.deb
sudo apt install i3

clear && echo "" && blue "Instalando o i3lock-color..." && echo "" && sleep 3
cd ~/Downloads
git clone https://github.com/Raymo111/i3lock-color.git
cd i3lock-color
./build.sh
./install-i3lock-color.sh
cd ~/Downloads
sudo rm -r i3lock-color

clear && echo "" && blue "Instalando gaps do i3..." && echo ""
cd ~/Downloads
git clone https://www.github.com/jbenden/i3-gaps-rounded i3-gaps
cd i3-gaps
mkdir -p build && cd build
meson ..
ninja
sudo ninja install
cd ~/Downloads
sudo rm -r i3-gaps

cd ~/repos
cp ~/repos/Ubuntu/packages/ookla-speedtest-1.2.0-linux-x86_64.tgz ~/Downloads
cd ~/Downloads
sudo tar -xvzf ookla-speedtest-1.2.0-linux-x86_64.tgz -C /usr/bin
rm ookla-speedtest-1.2.0-linux-x86_64.tgz

sudo snap install youtube-music-desktop-app obsidian
sudo snap install youtube-music-desktop-app obsidian
sudo snap install android-studio --classic

clear && echo "" && blue "Baixando o Flutter..." && echo "" && sleep 3
mkdir -p ~/development
cd ~/Downloads
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.27.1-stable.tar.xz
tar -xf ~/Downloads/flutter_linux_3.27.1-stable.tar.xz -C ~/development/
rm flutter_linux_3.27.1-stable.tar.xz
sudo rm -r Dracula

clear && echo "" && blue "Instalando o picom..." && echo "" && sleeop 3
cd ~/Downloads
git clone https://github.com/yshui/picom.git
cd picom
meson setup --buildtype=release build
sudo ninja -C build
sudo ninja -C build install
cd ~/Downloads
sudo rm -r picom/

# Arquivos de configuração
cd ~/repos/Ubuntu/stow
mkdir -p ~/.config/autostart && stow -v -t ~/.config/autostart autostart
mkdir -p ~/.config/btop && stow -v -t ~/.config/btop btop
mkdir -p ~/.config/cava && stow -v -t ~/.config/cava cava
mkdir -p ~/.config/dunst && stow -v -t ~/.config/dunst dunst
mkdir -p ~/.config/gtk-3.0 && stow -v -t ~/.config/gtk-3.0 gtk-3.0
mkdir -p ~/.config/i3 && stow -v -t ~/.config/i3 i3
mkdir -p ~/.config/i3status && stow -v -t ~/.config/i3status i3status
mkdir -p ~/.config/nitrogen && stow -v -t ~/.config/nitrogen nitrogen
mkdir -p ~/.config/nvim && stow -v -t ~/.config/nvim nvim
mkdir -p ~/.config/polybar && stow -v -t ~/.config/polybar polybar
mkdir -p ~/.config/rofi && stow -v -t ~/.config/rofi rofi
ln picom.conf ~/.config/picom.conf

cd ~/repos/Ubuntu/
mkdir -p ~/Pictures && stow -v -t ~/Pictures wallpapers
mkdir -p ~/scripts && stow -v -t ~/scripts scripts
sudo apt install ruby-full

# Tema Dracula
cd ~/Downloads/
wget https://github.com/dracula/gtk/archive/master.zip
unzip master.zip
mv gtk-master Dracula
mv Dracula ~/.themes
rm master.zip
cd ~/Downloads
git clone https://github.com/vinceliuice/Tela-icon-theme.git
cd Tela-icon-theme
./install.sh -n dracula
cd ..
sudo rm -r Tela-icon-theme

gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
gsettings set org.gnome.desktop.wm.preferences theme "Dracula"
gsettings set org.gnome.desktop.interface icon-theme "dracula-dark"
gsettings set org.gnome.desktop.interface font-name "JetBrainsMono NFM"

flatpak install flathub io.github.shiftey.Desktop

ssh-keygen

sudo ufw enable
sudo ufw allow OpenSSH

echo "" && title_green "Instalação concluída." && echo "" && sleep 3

sudo reboot now
