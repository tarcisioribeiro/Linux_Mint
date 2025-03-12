#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install toilet curl wget nala -y

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

sudo nala install build-essential gcc g++ clang make cmake automake autoconf \
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
  libffi-dev liblzma-dev tk-dev btop stow scrot maim playerctl \
  libxcb1-dev libxcb-keysyms1-dev libxcb-util0-dev libxcb-icccm4-dev \
  libxcb-randr0-dev libxcb-xinerama0-dev libpango1.0-dev libx11-dev \
  libxrandr-dev libxinerama-dev libxss-dev libglib2.0-dev libev-dev \
  libxcb-cursor-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
  libxcb-xrm0 libxcb-xrm-dev libxcb-shape0-dev libconfig-dev \
  libdbus-1-dev libegl-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev \
  libx11-xcb-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-glx0-dev \
  libxcb-image0-dev libxcb-present-dev libxcb-render0-dev acpi light \
  libxcb-render-util0-dev libxcb-util-dev libxcb-xfixes0-dev uthash-dev \
  libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libmpv mpv libgtk-3-dev \
  libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
  libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa \
  gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudiolibmpv1 locate libcurl4-openssl-dev \
  pkg-config libgd-dev libonig-dev libpq-dev libzip-dev curl unzip jq gnome-shell-extension-manager gnome-tweaks git zsh curl wget toilet -y

sleep 2

blue "Instalando o Oh My ZSH..."
cd "$HOME/repos/Ubuntu/packages/terminals" || exit
./oh_my_zsh_install.sh

blue "Instalando o Oh My Posh..."
sudo wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
mkdir "$HOME/.poshthemes"
wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O "$HOME/.poshthemes/themes.zip"
unzip "$HOME/.poshthemes/themes.zip" -d "$HOME/.poshthemes"
chmod u+rw "$HOME/.poshthemes/*.omp.*"
rm "$HOME/.poshthemes/themes.zip"
ln "$HOME/repos/Ubuntu/customization/zsh/tj-dracula.omp.json" "$HOME/.poshthemes/tj-dracula.omp.json"

cd ~ || exit && mkdir -p "$HOME/repos" && mkdir -p "$HOME/.icons" && mkdir -p "$HOME/.themes" && mkdir -p "$HOME/scripts"

cd "$HOME/repos/Ubuntu/fonts" || exit
sudo cp JetBrains_Mono_Medium_Nerd_Font_Complete_Mono_Windows_Compatible.ttf /usr/share/fonts/
sudo cp JetBrainsMonoNerdFontMono-Bold.ttf /usr/share/fonts/
sudo cp JetBrainsMonoNerdFontMono-BoldItalic.ttf /usr/share/fonts/
sudo cp JetBrainsMonoNerdFontMono-Italic.ttf /usr/share/fonts

clear
cp "$HOME/repos/Ubuntu/customization/bash/logo-ls_Linux_x86_64.tar.gz" "$HOME/Downloads"
cd "$HOME/Downloads" || exit
tar -zxf logo-ls_Linux_x86_64.tar.gz
cd "$HOME/Downloads/logo-ls_Linux_x86_64" || exit
sudo cp logo-ls /usr/local/bin
cd "$HOME/Downloads" || exit
rm -r logo-ls_Linux_x86_64
rm logo-ls_Linux_x86_64.tar.gz

blue "Ativando o acesso aos apps Flatpak..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

blue "Instalando o HomeBrew..."
cd "$HOME/repos/Ubuntu/packages/package-managers" || exit
./brew_install.sh

blue "Instalando o Oh My Bash..."
cd "$HOME/repos/Ubuntu/packages/terminals" || exit
./oh_my_bash_install.sh

blue "Instalando o Starship..."
cd "$HOME/repos/Ubuntu/packages/terminals" || exit
./starship_install.sh

git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

tmux new-session -d -s "dev"
cd "$HOME/repos/Ubuntu/customization" || exit
ln tmux/.tmux.conf "$HOME/.tmux.conf"
sleep 2
tmux source "$HOME/.tmux.conf"
sleep 2
tmux kill-session -t "dev"

echo "eval \"$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"" >>"$HOME/.bashrc"
echo "eval \"$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"" >>"$HOME/.zshrc"
sleep 2
source /home/tarcisio/.bashrc
sleep 2

blue "Instalando o i3wm..."
cd "$HOME/Downloads" || exit
/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2024.03.04_all.deb keyring.deb SHA256:f9bb4340b5ce0ded29b7e014ee9ce788006e9bbfe31e96c09b2118ab91fca734
cd "$HOME/Downloads" || exit
sudo apt install ./keyring.deb
echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
sudo apt update
sudo rm keyring.deb
sudo apt install i3

echo "Instalando gaps do i3..."
cd "$HOME/Downloads" || exit
git clone https://www.github.com/jbenden/i3-gaps-rounded i3-gaps
cd i3-gaps || exit
mkdir -p build
cd build || exit
meson ..
ninja
sudo ninja install
cd "$HOME/Downloads" || exit
sudo rm -r i3-gaps

blue "Baixando o Flutter..."
cd "$HOME/repos/Ubuntu/packages/development-tools" || exit
./flutter.sh

blue "Instalando o picom..."
cd "$HOME/Downloads" || exit
git clone https://github.com/yshui/picom.git
cd picom || exit
meson setup --buildtype=release build
sudo ninja -C build
sudo ninja -C build install
cd "$HOME/Downloads" || exit
sudo rm -r picom/

blue "Instalando o scrcpy..."
cd "$HOME/Downloads" || exit
git clone https://github.com/Genymobile/scrcpy
cd scrcpy || exit
./install_release.sh
cd "$HOME/Downloads" || exit
sudo rm -r scrcpy

cd "$HOME/Downloads" || exit
git clone --depth=1 https://github.com/adi1090x/rofi.git
cd rofi || exit
chmod +x setup.sh
./setup.sh
rm -r ~/.config/rofi

cd "$HOME/repos/Ubuntu/stow" || exit
mkdir -p "$HOME/.config/autostart" && stow -v -t "$HOME/.config/autostart" autostart
mkdir -p "$HOME/.config/btop" && stow -v -t "$HOME/.config/btop" btop
mkdir -p "$HOME/.config/cava" && stow -v -t "$HOME/.config/cava" cava
mkdir -p "$HOME/.config/dunst" && stow -v -t "$HOME/.config/dunst" dunst
mkdir -p "$HOME/.config/gtk-3.0" && stow -v -t "$HOME/.config/gtk-3.0" gtk-3.0
mkdir -p "$HOME/.config/i3" && stow -v -t "$HOME/.config/i3" i3
mkdir -p "$HOME/.config/alacritty" && stow -v -t "$HOME/.config/alacritty" alacritty
mkdir -p "$HOME/.config/lazygit" && stow -v -t "$HOME/.config/lazygit" lazygit
mkdir -p "$HOME/.config/nitrogen" && stow -v -t "$HOME/.config/nitrogen" nitrogen
mkdir -p "$HOME/.config/nvim" && stow -v -t "$HOME/.config/nvim" nvim
mkdir -p "$HOME/.config/polybar" && stow -v -t "$HOME/.config/polybar" polybar
mkdir -p "$HOME/.config/rofi" && stow -v -t "$HOME/.config/rofi" rofi
mkdir -p "$HOME/.config/ranger" && stow -v -t "$HOME/.config/ranger" ranger
mkdir -p "$HOME/.config/spotify-tui" && stow -v -t "$HOME/.config/spotify-tui" spotify-tui
mkdir -p "$HOME/.config/spicetify" && stow -v -t "$HOME/.config/spicetify" spicetify
ln picom.conf "$HOME/.config/picom.conf"
ln Xresources "$HOME/Xresources"

cd "$HOME/repos/Ubuntu/" || exit
mkdir -p "$HOME/Pictures" && stow -v -t "$HOME/Pictures" wallpapers
mkdir -p "$HOME/scripts" && stow -v -t "$HOME/scripts" scripts

cd "$HOME/Downloads/" || exit
wget -q https://github.com/dracula/gtk/archive/master.zip
unzip master.zip
mv gtk-master Dracula
mv Dracula "$HOME/.themes"
rm master.zip
cd "$HOME/Downloads" || exit
git clone https://github.com/vinceliuice/Tela-icon-theme.git
cd Tela-icon-theme || exit
./install.sh -n dracula
cd ..
sudo rm -r Tela-icon-theme

gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
gsettings set org.gnome.desktop.wm.preferences theme "Dracula"
gsettings set org.gnome.desktop.interface icon-theme "dracula-dark"
gsettings set org.gnome.desktop.interface font-name "JetBrainsMono NFM 11"
gsettings set org.gnome.cursor.interface cursor-theme "breeze_cursors"

blue "Instalando o i3lock-color..."
cd "$HOME/repos/Ubuntu/packages/terminals" || exit
./i3lock-color.sh

blue "Removendo diretórios..."
rm -r "$HOME/Documents/"
rm -r "$HOME/Music/"
rm -r "$HOME/Public/"
rm -r "$HOME/Templates/"
rm -r "$HOME/Videos/"

blue "Instalando programas..."
sudo mkdir /media/tarcisio/Seagate && sudo mount /dev/sdb1 /media/tarcisio/Seagate
cp /media/tarcisio/Seagate/Packages/*.deb "$HOME/Downloads"
sudo gdebi chrome.deb
sudo gdebi code.deb
sudo gdebi discord.deb
sudo gdebi obsidian.deb
sudo gdebi upscayl.deb
sudo gdebi workbench.deb
sudo gdebi virtualbox.deb
sleep 5
rm -- *glob* *.deb
sudo mv /usr/share/mysql-workbench/data/code_editor.xml /usr/share/mysql-workbench/data/code_editor_old.xml
sudo cp "$HOME/repos/Ubuntu/customization/mysql-workbench/code_editor.xml" /usr/share/mysql-workbench/data/

git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.10.2

cd "$HOME/Downloads" || exit
wget https://raw.githubusercontent.com/dracula/gedit/master/dracula.xml
mkdir -p ~/.local/share/gedit/styles/
mv dracula.xml ~/.local/share/gedit/styles/

rm "$HOME/.zshrc" && rm "$HOME/.zsh_aliases" && rm "$HOME/.bashrc" && rm "$HOME/.bash_aliases"
cd "$HOME/repos/Ubuntu/customization" || exit
ln zsh/.zshrc "$HOME/.zshrc" && ln zsh/.zsh_aliases "$HOME/.zsh_aliases"
ln bash/.bashrc "$HOME/.bashrc" && ln bash/.bash_aliases "$HOME/.bash_aliases"
ln starship/starship.toml "$HOME/.config/starship.toml"
ln git/.gitconfig "$HOME/.gitconfig"

sleep 5
source /home/tarcisio/.bashrc
sleep 5

cd "$HOME/repos/Ubuntu/packages/development-tools" || exit
./docker_install.sh
./install_kvm.sh

cd "$HOME/repos/Ubuntu/packages/package-managers" || exit
./asdf_packages.sh

brew install fd git-delta vim lazygit eza onefetch spotifyd tldr zoxide

curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update && sudo apt install spotify-client

curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh

read -r -p "Reiniciar agora? (s/n): " choice
if [[ "$choice" == "s" ]]; then
  sudo reboot
fi
