#!/bin/bash

deps=("software-properties-common")
ppa="ppa:neovim-ppa/stable"
ppa_unstable="ppa:neovim-ppa/unstable"

function install_dependencies() {

  for dep in "${deps[@]}"
  do
    echo "Installing $dep"
    sudo apt install -y $dep
  done

}

function setup_ppa() {

  echo "Importing $ppa"
  sudo add-apt-repository $ppa -y
  sudo add-apt-repository $ppa_unstable -y

  sudo apt update -y

}

function install_neovim() {

  echo "Installing neovim"

  sudo apt install -y neovim

}

function install_vimplug() {

  echo "Installing VimPlug"
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

}

function install_nodejs() {

  echo "Installing NodeJS"
  curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
  sudo apt-get install -y nodejs

}

function uninstall_neovim() {

  echo "Removing neovim"

  sudo apt autoremove -y --purge neovim*

  sudo add-apt-repository -y --remove $ppa
  sudo add-apt-repository -y --remove $ppa_unstable

}

function install_nerdfonts() {

  nerdfont_git_clone_url="https://github.com/ryanoasis/nerd-fonts.git"
  fonts_dir="$HOME/.local/share/fonts"
  git_dir="$HOME/git"
 
  echo "Installing Nerdfonts"

  if [[ ! -d $fonts_dir ]];
  then
    mkdir -pv $fonts_dir
  fi

  cd $fonts_dir

  curl -fLo "DejaVu Sans Mono Nerd Font Complete.ttf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf?raw=true"
  curl -fLo "Droid Sans Mono Nerd Font Complete.otf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.otf?raw=true"
  curl -fLo "Droid Sans Mono Nerd Font Complete.otf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf?raw=true"
  curl -fLo "Fira Code Regular Nerd Font Complete.ttf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf"
  curl -fLo "Fira Code Regular Mono Nerd Font Complete.ttf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete%20Mono.ttf?raw=true"
  curl -fLo "Fira Mono Regular Nerd Font Complete.otf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraMono/Regular/complete/Fura%20Mono%20Regular%20Nerd%20Font%20Complete.otf?raw=true"
  curl -fLo "Fira Mono Regular Mono Nerd Font Complete.otf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraMono/Regular/complete/Fura%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.otf?raw=true"
  curl -fLo "Hasklig Regular Nerd Font Complete.otf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hasklig/Regular/complete/Hasklug%20Nerd%20Font%20Complete.otf?raw=true"
  curl -fLo "Hasklig Regular Mono Nerd Font Complete.otf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hasklig/Regular/complete/Hasklug%20Nerd%20Font%20Complete%20Mono.otf?raw=true"
  curl -fLo "Monoki Regular Nerd Font Complete.ttf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Mononoki/Regular/complete/mononoki-Regular%20Nerd%20Font%20Complete.ttf?raw=true"
  curl -fLo "Monoki Regular Mono Nerd Font Complete.ttf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Mononoki/Regular/complete/mononoki-Regular%20Nerd%20Font%20Complete%20Mono.ttf?raw=true"
  curl -fLo "Source Code Pro Nerd Font Complete.ttf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf?raw=true"
  curl -fLo "Source Code Pro Mono Nerd Font Complete.ttf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf?raw=true"
  curl -fLo "Ubuntu Regular Nerd Font Complete.ttf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Ubuntu/Regular/complete/Ubuntu%20Nerd%20Font%20Complete.ttf?raw=true"
  curl -fLo "Ubuntu Regular Mono Nerd Font Complete.ttf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Ubuntu/Regular/complete/Ubuntu%20Nerd%20Font%20Complete%20Mono.ttf?raw=true"
  curl -fLo "Ubuntu Mono Regular Nerd Font Complete.ttf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete.ttf?raw=true"
  curl -fLo "Ubuntu Regular Mono Nerd Font Complete.ttf" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete%20Mono.ttf?raw=true" 
 
}

function setup_coc() {

  nvim --headless "+call CocInstall coc-tsserver coc-css coc-eslint coc-pyright coc-prettier"

}

if [[ $1 == "-u" ]]
then
  uninstall_neovim
else
  install_dependencies
  install_nodejs
  setup_ppa
  install_neovim
  install_vimplug
  install_nerdfonts
  setup_coc
fi

" :CocInstall coc-tsserver coc-css coc-eslint coc-emmet coc-pyright coc-prettier
