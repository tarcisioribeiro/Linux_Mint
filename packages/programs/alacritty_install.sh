#!/usr/bin/bash
cd "$HOME/Downloads"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

sleep 5
rm $HOME/.bashrc
rm $HOME/.bash_aliases
cd $HOME/repos/Ubuntu/customization/bash
ln .bash_aliases $HOME/.bash_aliases
ln .bashrc $HOME/.bashrc
sleep 5

cd "$HOME/Downloads"
git clone https://github.com/rust-lang/cargo.git
cd cargo
cargo build --relsease

cd "$HOME/Downloads"
git clone https://github.com/alacritty/alacritty.git
cd alacritty
cargo build --release
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
cd $HOME
sudo rm -r $HOME/Downloads/alacritty/
