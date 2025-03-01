#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install toilet curl wget zsh -y
chsh -s /usr/bin/zsh

title_green() {
  clear
  echo ""
  echo -e "\033[32m$(toilet --font pagga --filter border --width 200 "$1")\033[0m"
  echo ""
  sleep 2
}

title() {
  clear
  echo ""
  echo -e "$(toilet --font pagga --filter border --width 200 "$1")"
  echo ""
  sleep 2
}

green() {
  clear
  echo ""
  echo -e "\033[32m$1\033[0m"
  echo ""
  sleep 2
}

blue() {
  clear
  echo ""
  echo -e "\033[34m$1\033[0m"
  echo ""
  sleep 2
}

title "Instalação - Parte 1"

sudo apt install build-essential gcc g++ clang make cmake automake autoconf \
  git wget curl stow pkg-config meson ninja-build scdoc \
  neofetch tmux rofi fzf bat gdebi feh nitrogen polybar redshift \
  gnome-tweaks gnome-shell-extension-manager tmux xclip xsel \
  mpv vlc shotcut obs-studio cava flatpak libpam0g-dev \
  deluge deluged deluge-web deluge-console kitty pavucontrol \
  timeshift openssh-server mysql-server default-libmysqlclient-dev \
  dkms perl nodejs npm ruby-full libsdl2-dev libusb-1.0-0-dev \
  adb cpu-checker qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils \
  ffmpeg libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev libswresample-dev \
  gimp libgtk-3-dev libgtk-4-dev libadwaita-1-dev blueman \
  python3 python3-venv python3-tk python3-pip python3-openssl python3.10-full python3.10-dev \
  libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncurses5-dev libncursesw5-dev \
  libffi-dev liblzma-dev tk-dev btop stow scrot maim \
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

sleep 2

cd $HOME/repos/Ubuntu/packages/terminals

blue "Instalando o Oh My ZSH..."
./oh_my_zsh_install.sh

blue "Instalando o Oh My Posh..."
sudo wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
mkdir $HOME/.poshthemes
wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O $HOME/.poshthemes/themes.zip
unzip $HOME/.poshthemes/themes.zip -d $HOME/.poshthemes
chmod u+rw $HOME/.poshthemes/*.omp.*
rm $HOME/.poshthemes/themes.zip
ln $HOME/repos/Ubuntu/customization/zsh/tj-dracula.omp.json $HOME/.poshthemes/tj-dracula.omp.json

# Diretórios
cd ~ && mkdir -p $HOME/repos && mkdir -p $HOME/.icons && mkdir -p $HOME/.themes && mkdir -p $HOME/scripts

# Fontes
cd $HOME/repos/Ubuntu/fonts
sudo cp JetBrains_Mono_Medium_Nerd_Font_Complete_Mono_Windows_Compatible.ttf /usr/share/fonts/
sudo cp JetBrainsMonoNerdFontMono-Bold.ttf /usr/share/fonts/
sudo cp JetBrainsMonoNerdFontMono-BoldItalic.ttf /usr/share/fonts/
sudo cp JetBrainsMonoNerdFontMono-Italic.ttf /usr/share/fonts

clear
sleep 5
# logo-ls
cp $HOME/repos/Ubuntu/customization/bash/logo-ls_Linux_x86_64.tar.gz $HOME/Downloads
cd $HOME/Downloads
tar -zxf logo-ls_Linux_x86_64.tar.gz
cd $HOME/Downloads/logo-ls_Linux_x86_64
sudo cp logo-ls /usr/local/bin
cd $HOME/Downloads
rm -r logo-ls_Linux_x86_64
rm logo-ls_Linux_x86_64.tar.gz

blue "Ativando o acesso aos apps Flatpak..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

cd $HOME/repos/Ubuntu

blue "Instalando o HomeBrew..."
cd $HOME/repos/Ubuntu/packages/package-managers
./brew_install.sh

blue "Instalando o Oh My Bash..."
cd $HOME/repos/Ubuntu/packages/terminals
./oh_my_bash_install.sh

blue "Instalando o Starship..."
cd $HOME/repos/Ubuntu/packages/terminals
./starship_install.sh

git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
tmux new-session -d -s "dev"
sleep 2
tmux source $HOME/.tmux.conf
sleep 2
tmux kill-session -t "dev"

echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.bashrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.zshrc

sleep 2
source $HOME/.bashrc
sleep 2

blue "Instalando o i3wm..."
cd $HOME/Downloads
/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2024.03.04_all.deb keyring.deb SHA256:f9bb4340b5ce0ded29b7e014ee9ce788006e9bbfe31e96c09b2118ab91fca734
cd $HOME/Downloads
sudo apt install ./keyring.deb
echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
sudo apt update
sudo rm keyring.deb
sudo apt install i3

"Instalando gaps do i3..."
cd $HOME/Downloads
git clone https://www.github.com/jbenden/i3-gaps-rounded i3-gaps
cd i3-gaps
mkdir -p build
cd build
meson ..
ninja
sudo ninja install
cd $HOME/Downloads
sudo rm -r i3-gaps

blue "Instalando o Speed Test..."
cp $HOME/repos/Ubuntu/packages/speed_test.tgz $HOME/Downloads
cd $HOME/Downloads
sudo tar -xvzf speed_test.tgz -C /usr/bin
rm speed_test.tgz

blue "Baixando o Flutter..."
cd $HOME/repos/Ubuntu/packages/development-tools
./flutter.sh

sleep 5
clear
sleep 5

blue "Instalando o picom..."
cd $HOME/Downloads
git clone https://github.com/yshui/picom.git
cd picom
meson setup --buildtype=release build
sudo ninja -C build
sudo ninja -C build install
cd $HOME/Downloads
sudo rm -r picom/

blue "Instalando o scrcpy..."
cd $HOME/Downloads
git clone https://github.com/Genymobile/scrcpy
cd scrcpy
./install_release.sh
cd $HOME/Downloads
sudo rm -r scrcpy

cd $HOME/Downloads
git clone --depth=1 https://github.com/adi1090x/rofi.git
cd rofi
chmod +x setup.sh
./setup.sh
rm -r ~/.config/rofi

cd $HOME/repos/Ubuntu/stow
mkdir -p $HOME/.config/autostart && stow -v -t $HOME/.config/autostart autostart
mkdir -p $HOME/.config/btop && stow -v -t $HOME/.config/btop btop
mkdir -p $HOME/.config/cava && stow -v -t $HOME/.config/cava cava
mkdir -p $HOME/.config/dunst && stow -v -t $HOME/.config/dunst dunst
mkdir -p $HOME/.config/gtk-3.0 && stow -v -t $HOME/.config/gtk-3.0 gtk-3.0
mkdir -p $HOME/.config/i3 && stow -v -t $HOME/.config/i3 i3
mkdir -p $HOME/.config/kitty && stow -v -t $HOME/.config/kitty kitty
mkdir -p $HOME/.config/lazygit && stow -v -t $HOME/.config/lazygit lazygit
mkdir -p $HOME/.config/nitrogen && stow -v -t $HOME/.config/nitrogen nitrogen
mkdir -p $HOME/.config/nvim && stow -v -t $HOME/.config/nvim nvim
mkdir -p $HOME/.config/polybar && stow -v -t $HOME/.config/polybar polybar
mkdir -p $HOME/.config/rofi && stow -v -t $HOME/.config/rofi rofi
ln picom.conf $HOME/.config/picom.conf

cd $HOME/repos/Ubuntu/
mkdir -p $HOME/Pictures && stow -v -t $HOME/Pictures wallpapers
mkdir -p $HOME/scripts && stow -v -t $HOME/scripts scripts

# Tema Dracula
cd $HOME/Downloads/
wget -q https://github.com/dracula/gtk/archive/master.zip
unzip master.zip
mv gtk-master Dracula
mv Dracula $HOME/.themes
rm master.zip
cd $HOME/Downloads
git clone https://github.com/vinceliuice/Tela-icon-theme.git
cd Tela-icon-theme
./install.sh -n dracula
cd ..
sudo rm -r Tela-icon-theme

gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
gsettings set org.gnome.desktop.wm.preferences theme "Dracula"
gsettings set org.gnome.desktop.interface icon-theme "dracula-dark"
gsettings set org.gnome.desktop.interface font-name "JetBrainsMono NFM"

blue "Instalando o i3lock-color..."
cd $HOME/repos/Ubuntu/packages/terminals
./i3lock-color.sh

blue "Removendo diretórios..."
rm -r $HOME/Documents/
rm -r $HOME/Music/
rm -r $HOME/Public/
rm -r $HOME/Templates/
rm -r $HOME/Videos/

title_green "Instalação concluída."

brew install eza tldr git-delta glow yazi onefetch cmatrix lolcat dust fd zoxide neovim vim
brew install eza tldr git-delta glow yazi onefetch cmatrix lolcat dust fd zoxide neovim vim
brew install jesseduffield/lazygit/lazygit

git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.10.2


rm $HOME/.zshrc && rm $HOME/.zsh_aliases && rm $HOME/.bashrc && rm $HOME/.bash_aliases
cd $HOME/repos/Ubuntu/customization
ln zsh/.zshrc $HOME/.zshrc && ln zsh/.zsh_aliases $HOME/.zsh_aliases
ln bash/.bashrc $HOME/.bashrc && ln bash/.bash_aliases $HOME/.bash_aliases
ln tmux/.tmux.conf $HOME/.tmux.conf
ln starship/starship.toml $HOME/.config/starship.toml
ln git/.gitconfig $HOME/.gitconfig

read -p "Reiniciar agora? (s/n): " choice
if [[ "$choice" == "s" ]]; then
  sudo reboot
fi
