#!/bin/sh

set -e
sudo apt install wget build-essential libreadline-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev


curl -O https://www.python.org/ftp/python/$1/Python-$1.tgz
tar -xvzf Python-$1.tgz
cd Python-$1

./configure --prefix=/opt/python/$1 --enable-shared --enable-ipv6 --enable-optimizations --with-ensurepip=upgrade LDFLAGS=-Wl,-rpath=/opt/python/$1/lib,--disable-new-dtags
make
sudo make install
read -p "Would you like to add /opt/python/$1/bin/ to PATH? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 0
echo "PATH=\$PATH:/opt/python/$1/bin/" >> ~/.bashrc
