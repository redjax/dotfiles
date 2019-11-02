sudo dnf config-manager --add-repo https://brave-browser-rpm-dev.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-dev.s3.brave.com/brave-core-nightly.asc
dnf install -y brave-browser-dev
