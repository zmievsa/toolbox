#!/bin/sh
# Before running me, create all necessary users using add_deb_user.sh
apt update && apt upgrade
apt install sudo git nginx ufw snapd curl
snap install core && snap refresh core
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot
certbot --nginx
certbot renew --dry-run