if [[ ! -d "$HOME/.chezmoi_scripts/utils" ]]; then
    echo "Could not find $HOME/.chezmoi_scripts/utils directory. Make sure to execute this from ~/.chezmoi_scripts"
    exit 1
fi

## Import package manager detection script
source "$HOME/.chezmoi_scripts/utils/platform.sh"

## Set package manager
PKG_MANAGER=$(detect_pkg_manager)

function install_zsh() {
    if [[ $DEBUG -eq 1 ]]; then
        echo "[DEBUG] Install zsh using package manager: $PKG_MANAGER" &>2
    fi

    echo "Installing zsh (you may need to enter your sudo password)"
    sudo $PKG_MANAGER install zsh
    if [[ $? -eq 0 ]]; then
        echo "Successfully installed zsh" &>2

        return 0
    else
        echo "Failed to install zsh" &>2

        return 1
    fi
}

function install_oh_my_zsh() {
    echo "Installing oh-my-zsh (you may need to enter your sudo password)"
    if ! command -v wget &>/dev/null; then
        echo "wget is not installed" &>2

        echo "Attempting to install with $PKG_MANAGER" &>2
        sudo $PKG_MANAGER install wget
        if [[ $? -ne 0 ]]; then
            echo "Failed to install wget" &>2

            return 1
        fi
    fi

    echo "Downloading & executing oh-my-zsh install script"
    sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
    if [[ $? -ne 0 ]]; then
        echo "Failed to install oh-my-zsh" &>2

        return 1
    fi
}

function main() {
    if command -v zsh &> /dev/null; then
        echo "zsh is already installed" &>2
    else
        install_zsh
    fi

    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        echo "oh-my-zsh is already installed" &>2
    else
        install_oh_my_zsh
    fi

    if [[ $? -ne 0 ]]; then
        echo "Error installing & configuring zsh." &>2

        return $?
    fi

    return 0
}


main
if [[ $? -eq 0 ]]; then
    # echo "Successfully installed zsh"
    exit 0
else
    echo "Failed to install zsh"
    exit $?
fi
