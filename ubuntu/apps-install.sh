#!/bin/bash

user = "jack"
userhome = "/home/$user/"
dotfiles = "$userhome/Documents/git/dotfiles"
vers = "bionic"
ubuntuvers = "Ubuntu_18.10"

# --------------------------------------------------------------------------------------

# General apps
apt install -y alacarte
apt install -y snapd
apt install -y screen
# --------------------------------------------------------------------------------------

# NVIM

    # Add ppa
add-apt-repository ppa:neovim-ppa/unstable
apt update -y
apt install -y neovim

    # Add dependencies for plugins
apt-get install -y python-dev python-pip python3-dev python3-pip

    # Restore NVIM settings
mkdir $userhome/.config/nvim

    # Copy contents of init.nvim to new init.nvim file.
touch $userhome/.config/nvim/init.vim
cd ../nvim

cat init.vim > $userhome/.config/nvim/init.vim
cp -R autoload $userhome/.config/nvim/

    # Clone Vim-Plug into autoload directory
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Run PlugInstall command
nvim +PlugInstall

# --------------------------------------------------------------------------------------

# Tmux
apt install -y tmux
cp $dotfiles/.tmux.conf ~/

# --------------------------------------------------------------------------------------

# Smartgit

    # Open webpage with Smartgit archive
echo "Opening Smartgit download page"
read -p "Download the Linux archive, press Enter to open download page: "
xdg-open https://www.syntevo.com/smartgit/download/
read -p "Press Enter after download has completed: "

    # Create install directory (may not need this step)
# mkdir /opt/smartgit

    # Install to directory
cd $userhome/Downloads/
tar xzvf smartgit-linux-*.tar.gz
cp -R smartgit /opt/
cp $userhome/Documents/git/dotfiles/ubuntu/smartgit.desktop /usr/share/applications

# --------------------------------------------------------------------------------------

# VSCode
cd $userhome/Downloads

echo "Opening VSCode Download page"
echo "Choose to save the download instead of opening with the package manager."
read -p "Press Enter to open download page: "
xdg-open https://code.visualstudio.com/
read -p "Press enter after download has completed: "
dpkg -i $userhome/Downloads/code_*.deb && apt-get install -f

# --------------------------------------------------------------------------------------

# Sublime Text

    # Add key
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

    # Add repo
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
apt update
apt install -y sublime-text

# --------------------------------------------------------------------------------------

# Tilix
    # Add repo
add-apt-repository ppa:webupd8team/terminix
apt update
apt install -y tilix

    # Create symlink to avoid error when editing settings
ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh

# Restore conf
dconf load /com/gexperts/Tilix/ < $dotfiles/tilix/tilix.dconf

# Stop screen startup message
echo 'startup_message off' >> $userhome/.screenrc

# --------------------------------------------------------------------------------------

# Discord
snap install discord

# --------------------------------------------------------------------------------------

# Albert
    # Add key
#curl https://build.opensuse.org/projects/home:manuelschneid3r/public_key | sudo apt-key add -

#pause -r "Make sure to change release version to current Ubuntu version equivalent."
#pause -r "Press CTRL-C to cancel script execution if change needed"
#sh -c "echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/x$ubuntuvers/ /' > /etc/apt/sources.list.d/home:manuelschneid3r.list"
#apt update
#apt install -y albert

# --------------------------------------------------------------------------------------

# Themes, Fonts, and Icons

# Clone repo
# git clone --progress https://github.com/redjax/jaxlinuxlooks.git $userhome/Documents/git/jaxlinuxlooks

# -Themes
# cd $userhome/Documents/git/jaxlinuxlooks/ && ./themesinstall.sh

# -Fonts
# cd $userhome/Documents/git/jaxlinuxlooks/ && ./fontsinstall.sh

    # Arc theme
add-apt-repository ppa:noobslab/themes

    # Arc icons
add-apt-repository ppa:noobslab/icons
apt update
apt install -y arc-icons arc-theme

# --------------------------------------------------------------------------------------

# Cron tasks
cd $dotfiles/cronscripts
./createcronjobs.sh
