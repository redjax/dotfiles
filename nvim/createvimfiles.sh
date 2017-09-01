#!/bin/bash

# >dep indicates a line that I intend to deprecate.

#>dep (unsure if necessary since I am already cloning this file from Github.
# First, download the dotfiles folder
#git clone git://github.com/redjax/dotfiles ~/dotfiles

# Next, we copy the init.nvim and autoload folder from the dotfiles folder
# I am trying something new here, where I create the init.vim file, and then just $cat the contents of the nvim file in the cloned directory to the new one. This way I can also simply update my init.vim folder on future releases.
mkdir ~/.config/nvim
#>dep (I intend to just $cat the config of init.vim, so copying is not necessary.
#cp -R ~/Documents/github/dotfiles/nvim/init.vim ~/.config/nvim/init.vim

# Copy contents of init.nvim to new init.nvim file.
touch ~/.config/nvim/init.vim
cat ~/Documents/github/dotfiles/nvim/init.nvim > ~/.config/nvim/init.nvim
cp -R ~/Documents/github/dotfiles/nvim/autoload ~/.config/nvim/

#>dep (I am using Vim-Plug instead of Vundle now.
#>dep cp -R ~/Documents/github/dotfiles/nvim/bundle ~/.config/nvim/
#>dep cp -R ~/Documents/dotfiles/nvim/plugged ~/.config/nvim/plugged

#>dep (I am using Vim-Plug instead of Vundle now.
#>dep Then, we'll install Vundle before anything else
#>dep git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim

# Clone Vim-Plug into autoload directory
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Then, we'll run the VIM command to install all the Plug plugins
nvim +PlugInstall

#>dep chmod u+x vundleupdate.sh
#>dep./vundleupdate.sh
