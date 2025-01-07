#!/usr/bin/bash
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
mkdir repos
mkdir scripts

red "\n |--------- Instalação - Parte 1 ---------| \n"

sleep 10

sudo apt update
sudo apt upgrade -y
sudo apt install nala

blue "\nInstalando o Nala.\n"
sleep 3

sudo nala install \
  build-essential \
  git \
  neofetch \
  curl \
  tmux \
  wget \
  net-tools \
  btop \
  tilix \
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
  feh \
  mysql-server \
  openssh-server

sudo nala install zsh -y
chsh -s /usr/bin/zsh
zsh

blue "\nInstalando o Oh My ZSH...\n"
sleep 3

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

blue "\nInstalando o Oh My Posh...\n"
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
git clone https://github.com/tarcisioribeiro/ExpenseLit.git
git clone https://github.com/tarcisioribeiro/Password_Manager.git

mkdir -p ~/.config/autostart

cd ~/repos
git clone https://github.com/tarcisioribeiro/Terminal.git
cp repos/Terminal/customization/zsh/tj-dracula.omp.json ~/.poshthemes
cp repos/Terminal/customization/bash/logo-ls_Linux_x86_64.tar.gz ~/Downloads
cd ~/Downloads
tar -zxf logo-ls_Linux_x86_64.tar.gz
cd ~/Downloads/logo-ls_Linux_x86_64
sudo cp logo-ls /usr/local/bin

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

sudo nala remove libmagickcore-6.q16-6 imagemagick-6.q16 imagemagick-6-common imagemagick idle-python3.10

blue "\nInstalando o Neovim...\n"
sleep 3

cd ~/Downloads
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
rm nvim-linux64.tar.gz

blue "\nInstalando o NVM...\n"
sleep 3
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

blue "\nInstalando o HomeBrew...\n"
sleep 3
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

blue "\nInstalando o Oh My Bash...\n"
sleep 3
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

blue "\nInstalando o Starship...\n"
sleep 3
curl -sS https://starship.rs/install.sh | sh

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

cd ~
cp repos/Terminal/customization/zsh/.zshrc ~
cp repos/Terminal/customization/zsh/.zsh_aliases ~
cp repos/Terminal/customization/bash/.bashrc ~
cp repos/Terminal/customization/bash/.bash_aliases ~
cp repos/Terminal/customization/git/.gitconfig ~
cp repos/Terminal/customization/tmux/.tmux.conf ~
cp repos/Terminal/customization/starship/starship.toml ~/.config

green "\nConcluído. Reinicie o terminal e execute o próximo instalador.\n"
sleep 3