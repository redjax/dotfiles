#!/bin/bash

cd /opt/

# clone the repository
# git clone https://www.github.com/Airblader/i3 i3-gaps
rm -rf i3-gaps

# Install components
# dnf remove -y libxcb-devel xcb-util-keysyms-devel xcb-util-devel xcb-util-wm-devel xcb-util-xrm-devel yajl-devel libXrandr-devel startup-notification-devel libev-devel xcb-util-cursor-devel libXinerama-devel libxkbcommon-devel libxkbcommon-x11-devel pcre-devel pango-devel git gcc automake libtool xorg-x11-util-macros xorg-x11-server-devel xorg-x11-server-devel xorg-x11-xkb-utils-devel

# Install XCB util
cd /opt/
# git clone --recursive https://github.com/Airblader/xcb-util-xrm.git
rm -rf xcb-util-xrm

# compile & install
# autoreconf --force --install
# rm -rf build/
# mkdir -p build && cd build/
# mkdir build
# ./autogen.sh

# Disabling sanitizers is important for release versions!
# The prefix and sysconfdir are, obviously, dependent on the distribution.
# ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
# make
# sudo make install
