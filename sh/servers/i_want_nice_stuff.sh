#!/bin/sh

curl -LO https://github.com/muesli/duf/releases/download/v0.8.1/duf_0.8.1_linux_amd64.deb
dpkg -i duf_0.8.1_linux_amd64.deb

curl -LO https://github.com/sharkdp/bat/releases/download/v0.20.0/bat-musl_0.20.0_amd64.deb
dpkg -i bat-musl_0.20.0_amd64.deb

apt-get install exa --yes

printf '\nalias df="duf"\nalias ls="exa"\nalias ll="exa --git -hal"\nalias cat="bat"\n' >> ~/.bashrc
