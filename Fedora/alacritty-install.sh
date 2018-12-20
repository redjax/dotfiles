#!/bin/bash

# Install Alacritty per the Github install how-to

# Prepare working directory
cd ~/Downloads
git clone https://github.com/jwilm/alacritty.git
cd alacritty

# Install Rust
curl https://sh.rustup.rs -sSf | sh

# Ensure Rust is up to date
rustup override set stable
rustup update stable

# Add Rust's package manager "Cargo" to the path
source $HOME/.cargo/env

# Install dependencies
dnf install -y cmake freetype-devel fontconfig-devel xclip

# Build Alacritty
cargo build --release

# Desktop Entry
cp target/release/alacritty /usr/local/bin
cp Alacritty.desktop ~/.local/usr/applications

# Install Alacritty directly with Cargo
# cargo install --git https://github.com/jwilm/alacritty

# Install manpages
# mkdir -p /usr/local/share/man/man1
gzip -c alacritty.man | tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null

# Bash completion
cp alacritty-completions.bash ~/.alacritty
echo "source ~/.alacritty" >> ~/.bashrc
