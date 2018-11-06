#!/bin/bash

os_check(){
    # Check the OS script is being run on.
    OS="$(lsb_release -is)"  # OS name
    OSRELEASE="$(lsb_release -sr)"  # OS version

    if [[  $OS=="Fedora" ]]
    then
        echo "fedora"

    elif [[ $OS=="Ubuntu" ]]
    then
        echo "ubuntu"

    elif [[ $OS=="Arch" ]]
    then
        echo "arch"

    else
        echo "error"
    fi
}

package_man(){
    # Determine which package manager to use & build commands
    osname=$(os_check)
    packager=" "

    if [[ $osname == "fedora" ]]
    then
        packager="dnf"
        echo $packager

    elif [[ $osname == "ubuntu" ]] || [[ $osname == "debian" ]]
    then
        packager="apt-get"
        echo $packager

    elif [[ $osname == "arch" ]]
    then
        packager="pacman"
        echo $packager
    fi
}


package_funcs() {
    # Build package manager commands
    packager=$(package_man)
    update=$packager" update"
    noconfirm=" "
    install=$packager" install"
    upgrade=$packager" upgrade"
    remove=$packager" remove"

    # Create no confirm option, i.e. "-y" in dnf and apt/apt-get
    if [[ $packager == "dnf" ]] || [[ $packager == "apt" ]]
    then
        noconfirm="-y"

    elif [[ $packager == "arch" ]]
    then
        noconfirm="--noconfirm"
    fi

    # $($install $noconfirm <pkg_var>)  # Install package
}

package_funcs
