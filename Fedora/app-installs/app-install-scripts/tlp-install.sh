dnf install -y tlp tlp-rdw

  # Thinkpad-specific
  dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

  dnf install http://repo.linrunner.de/fedora/tlp/repos/releases/tlp-release.fc$(rpm -E %fedora).noarch.rpm

  # Optional

    # akmod-tp_smapi (battery charge threshold, recalibration
    # akmod-acpi_call (X220/T420, X230/T430, etc)
    # kernel-devel (needed for akmod packages)
    # sudo dnf install -y akmod-tp_smapi akmod-acpi_call kernel-devel
