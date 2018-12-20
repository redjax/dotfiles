#!/bin/bash
# https://albertlauncher.github.io

rpm --import \
  https://build.opensuse.org/projects/home:manuelschneid3r/public_key

cd /opt
git clone --recursive https://github.com/albertlauncher/albert.git
mkdir albert-build
cd albert-build
cmake ../albert -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug
make
make install
