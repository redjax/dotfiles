dnf upgrade --refresh
dnf install -y dnf-plugin-system-upgrade
dnf system-upgrade download --releasever=28
dnf system-upgrade reboot -y

