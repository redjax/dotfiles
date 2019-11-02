# -Install GPG Key
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

# -Select Channel (choose 1)
#   -STABLE
sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
#   -DEV
#dnf config-manager --add-repo https://download.sublimetext.com/rpm/dev/x86_64/sublime-text.repo

# Update DNF and install Sublime
sudo dnf install -y sublime-text
