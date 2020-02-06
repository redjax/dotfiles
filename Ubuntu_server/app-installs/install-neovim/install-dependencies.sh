#!/bin/bash

detect_os_install_packages() {
  echo "What distribution of Linux are you using? i.e. ubuntu: "
  read distro

  # List of OS installs
  declare -a os_installs=("neovim"
                          "python3"
			              "python3-pip"
			              "git"
			              "python-autopep8"
			              "tidy", # HTML formatting
                          "fonts-powerline"
			              )

  # List of pip installs
  declare -a pip_installs=("pynvim"
  			   "jedi"
			   "yapf" # for code completion plugin
			   "pylint" # for linting
			   "black"
			   "sqlformat" # SQL linting
			   "flake8" # Python linting
               "autopep8" # Python code formatting
               )


  # Determine OS and install dependencies
  if [[ "$distro" == "ubuntu" ]];
  then
    pkg_mgr="apt"
    echo "Installing packages for Ubuntu with $pkg_mgr"

    # Install OS dependencies
    for app in "${os_installs[@]}"
    do
      sudo apt update -y
      sudo apt install -y "$app"
    done

    # Install pip dependencies
    echo "Installing packages for Python with pip"

    for pip_pkg in "${pip_installs[@]}"
    do
      pip3 install "$pip_pkg"
    done


  elif [[ "$distro" == "fedora" ]];
  then
    pkg_mgr="dnf"
    echo "Detected package manager as $pkg_mgr"

    # Install OS dependencies
    for app in "${os_installs[@]}"
    do
      sudo dnf update -y
      sudo dnf install -y "$app"
    done

    # Install pip dependencies
    for pip_pkg in "${pip_installs[@]}"
    do
      pip3 install "$pip_pkg"
    done

  else
    echo "Unsupported OS. What is your package manager, i.e. apt, dnf:"
    read pkg_mgr
    echo $pkg_mgr
  fi
}

# Run function to detect OS and install packages
detect_os_install_packages
