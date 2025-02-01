#!/usr/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install nala toilet curl wget -y
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

cd ~
mkdir -p ~/repos
mkdir -p ~/scripts

title "Instalação - Parte 1"

sleep 3

blue "\nInstalando o Nala.\n"
sleep 3

sudo nala install \
  build-essential \
  git \
  neofetch \
  gimp \
  meson \
  ninja-build \
  curl \
  tmux \
  wget \
  net-tools \
  btop \
  tilix \
  rofi \
  flatpak \
  python3-venv \
  python3-tk \
  python3-pip \
  python3.10-full \
  python3.10-dev \
  dkms \
  perl \
  gcc \
  make \
  default-libmysqlclient-dev \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  libncurses5-dev \
  libncursesw5-dev \
  llvm \
  xz-utils \
  tk-dev \
  libffi-dev \
  liblzma-dev \
  python3-openssl \
  timeshift \
  bat \
  gdebi \
  ruby-full \
  nodejs \
  npm \
  fzf \
  gnome-tweaks \
  gnome-shell-extension-manager \
  mpv \
  cava \
  feh \
  mysql-server \
  openssh-server \
  obs-studio \
  redshift \
  vlc \
  shotcut \
  deluge \
  deluged \
  deluge-web \
  deluge-console -y

sudo nala install zsh -y
chsh -s /usr/bin/zsh
zsh

clear
echo ""
blue "Instalando o Oh My ZSH..."
echo ""
sleep 3

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

clear
echo ""
blue "Instalando o Oh My Posh..."
echo ""
sleep 3

cd ~
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
mkdir ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.omp.*
rm ~/.poshthemes/themes.zip

cd ~
mkdir -p ~/repos
mkdir -p ~/.icons
mkdir -p ~/.themes
mkdir -p ~/scripts
cd ~/repos

mkdir -p ~/.config/autostart

cd ~/repos
git clone https://github.com/tarcisioribeiro/Terminal.git
git clone https://github.com/tarcisioribeiro/Arch_Linux.git
sudo cp ~/repos/Terminal/customization/bash/Ubuntu_Mono_Nerd_Font_Complete_Mono.ttf /usr/share/fonts/
sudo cp ~/repos/Terminal/customization/powershell/JetBrains_Mono_Medium_Nerd_Font_Complete_Mono_Windows_Compatible.ttf /usr/share/fonts/
cp ~/repos/Terminal/customization/zsh/tj-dracula.omp.json ~/.poshthemes
cp ~/repos/Terminal/customization/bash/logo-ls_Linux_x86_64.tar.gz ~/Downloads
cd ~/Downloads
tar -zxf logo-ls_Linux_x86_64.tar.gz
cd ~/Downloads/logo-ls_Linux_x86_64
sudo cp logo-ls /usr/local/bin
cd ~/Downloads
rm -r logo-ls_Linux_x86_64
rm logo-ls_Linux_x86_64.tar.gz

cd ~/Downloads
wget https://github.com/dracula/zsh-syntax-highlighting/archive/master.zip
unzip master.zip
cp zsh-syntax-highlighting-master/zsh-syntax-highlighting.sh ~/scripts/
rm master.zip
sudo rm -r zsh-syntax-highlighting-master

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

sudo nala remove libmagickcore-6.q16-6 imagemagick-6.q16 imagemagick-6-common imagemagick idle-python3.10 -y

clear
echo ""
blue "Instalando o Neovim..."
echo ""
sleep 3

cd ~/Downloads
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
rm nvim-linux64.tar.gz

clear
echo ""
blue "Instalando o NVM..."
echo ""
sleep 3

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

clear
echo ""
blue "Instalando o HomeBrew..."
echo ""
sleep 3

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

clear
echo ""
blue "Instalando o Oh My Bash..."
echo ""
sleep 3

bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

clear
echo ""
blue "Instalando o Starship..."
echo ""
sleep 3

curl -sS https://starship.rs/install.sh | sh

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Arquivos de customização dos shells
cd ~
cp repos/Terminal/customization/zsh/.zshrc ~
cp repos/Terminal/customization/zsh/.zsh_aliases ~
cp repos/Terminal/customization/bash/.bashrc ~
cp repos/Terminal/customization/bash/.bash_aliases ~
cp repos/Terminal/customization/git/.gitconfig ~
cp repos/Terminal/customization/tmux/.tmux.conf ~
cp repos/Terminal/customization/starship/starship.toml ~/.config
cp ~/repos/Terminal/customization/git/.gitconfig ~
cp ~/repos/Terminal/customization/tmux/.tmux.conf ~
cp ~/repos/Terminal/customization/starship/starship.toml ~/.config

# Fontes
cd ~/repos/Terminal/customization/powershell/
sudo cp JetBrains_Mono_Medium_Nerd_Font_Complete_Mono_Windows_Compatible.ttf /usr/share/fonts
sudo cp ~/repos/Arch_Linux/fonts/DS-DIGIB.TTF /usr/share/fonts
sudo cp ~/repos/Arch_Linux/fonts/JetBrainsMonoNerdFontMono-Italic.ttf /usr/share/fonts
sudo cp ~/repos/Arch_Linux/fonts/JetBrainsMonoNerdFontMono-Bold.ttf /usr/share/fonts
sudo cp ~/repos/Arch_Linux/fonts/JetBrainsMonoNerdFontMono-BoldItalic.ttf /usr/share/fonts

echo ""
title_green "Concluído. Reiniciando a máquina."
echo ""
sleep 3

sudo reboot now
