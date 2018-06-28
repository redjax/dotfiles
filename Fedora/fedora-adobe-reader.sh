#!/bin/bash
cd /tmp
wget http://ardownload.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i486linux_enu.rpm

dnf install AdbeRdr9.5.5-1_i486linux_enu.rpm

# Dependencies
dnf install libcanberra-gtk2.i686 adwaita-gtk2-theme.i686 PackageKit-gtk3-module.i686


