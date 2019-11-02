# Starting from scratch on nvim install script for Fedora
#
# Variables named "*dir" exist in the git directory.
# Variables "*path" exist on the system
#
# First few lines are variables to make the script work where it's run from

this_dir="$(dirname "$(readlink -f "$0")")"  # Get expanded path to build off of
nvim_dir=$this_dir"/nvim"
move_dirs_path=$nvim_dir"/move_dirs"
nvimconf_dir=$move_dirs_path"/conf"
autoload_dir=$move_dirs_path"/autoload"
colors_dir=$move_dirs_path"/colors"
plugged_dir=$move_dirs_path"/plugged"
initvim_file=

nvim_conf_path=$HOME"/.config/nvim/"

# Create nvim path directory if not exists
if [ ! -d "$nvim_conf_path" ]; then
    mkdir $nvim_conf_path
fi

# Install nvim from dnf
sudo dnf install -y neovim python3-neovim python3-pip

# Make nvim the default editor
export EDITOR="nvim"

function echo_testval () {
    # Echos the value of a variable.
    echo $0
}

function copy_item () {
    # Copies items from $0 to $1.
    cp -r $1 $2
}

# Copy init.vim to config path
copy_item $nvim_dir"/init.vim" $nvim_conf_path

# Copy colors dir to config path
copy_item "$colors_dir/" "$nvim_conf_path"

# Copy config dir to config path
copy_item "$nvimconf_dir/" "$nvim_conf_path"

# Install vimplug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install pynvim
pip3 install pynvim

# Open nvim and run PlugInstall command
nvim +'PlugInstall' +qa
