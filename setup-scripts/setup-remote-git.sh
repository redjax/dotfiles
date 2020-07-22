#!/bin/bash

#
# I'm tired of looking these steps up every time.
#

function CREATE-SSH-KEYS {
    
    GIT_PROVIDER="github.com"

    clear

    echo "Setting up git SSH keys."

    echo ""
    echo "Git email address: "
    read $GIT_EMAIL

    echo ""
    echo "Generating key, suggested name: id_rsa_github"

    ssh-keygen -t rsa -C "$GIT_EMAIL"
    
    echo ""
    echo "Testing git connection..."

    ssh -T git@$GIT_PROVIDER

    echo "Copy contents of ssh public key, shown below, and paste into provider's ssh key settings: "
    echo ""

    cat /home/$USER/.ssh/id_rsa_github.pub

    read -p "Press a button when you've copied the contents above: "
    
    break
}

function CREATE-GIT-USER {
    
    clear

    echo "Git email address: "
    read $GIT_EMAIL

    echo "Git name/username: "
    read $GIT_USER

    echo ""
    echo "Configuring git..."

    git config --global user.name "$GIT_USER"
    git config --global user.email "$GIT_EMAIL"

    echo ""
    read -p "Git user configured. Press a key to continue"

    break
}


CREATE-GIT-USER
CREATE-SSH-KEYS

clear

echo "Now, open a local git repository and enter the following: \
    git remote set-url origin git@github.com:username/your-repository.git"

echo ""

echo "Do the following to commit local changes and push: \
    git add *
    git commit -am "update message"
    git push"

read -p "Press a key to end: "
exit
