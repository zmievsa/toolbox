#!/bin/sh
set -e
if [ "$EUID" -eq 0 ]
  then echo "Please, do not run me as root."
  exit 1
fi
if [ $# -lt 2 ]
  then
    echo "Not enough arguments supplied. You must supply a path to directory that contains your app and then a DNS name for your service"
    echo "If you want an example of such a name, look at https://github.com/Ovsyanka83/unischeduler_web/blob/master/deploy.sh"
    exit 1
fi
PROJDIR=$(basename $1)
PROJDIRPATH=$(realpath $1)

sudo apt update
sudo apt install nginx python3 python3-pip python3-dev ufw git certbot python-certbot-nginx
# Configure firewall
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw enable

pip3 install pipenv
# To use python packages from console
# (Source .bashrc won't work in a script)
echo "PYTHON_BIN_PATH='$(python3 -m site --user-base)/bin'
PATH='$PATH:$PYTHON_BIN_PATH'" >> ~/.bashrc 

cd $PROJDIRPATH
mkdir .venv # Sets pipenv to put everything in .venv
echo "If an error happens now, it means you have some problems with your project. Check if it runs by itself"
python3 -m pipenv install -e . # install from setup.py
cd ..
echo "Now we will add all the necessary configurations"
# gunicorn --preload means that we load our app before launching workers. This makes workers share multiprocessing locks
echo "[Unit]
Description=Gunicorn instance to serve $PROJDIR
After=network.target

[Service]
User=$USER
Group=www-data
WorkingDirectory=$PROJDIRPATH
Environment="PATH=$PROJDIRPATH/.venv/bin"
ExecStart=$PROJDIRPATH/.venv/bin/gunicorn --preload --workers 3 --bind unix:$PROJDIR.sock -m 007 wsgi:app

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/$PROJDIR.service # Create service to run app on startup
echo "server {
    listen 443 ssl;
    listen [::]:443 ssl;
    # Use these two lines if you accidentally lose your configuration
    # ssl_certificate /etc/letsencrypt/live/$2/fullchain.pem;
    # ssl_certificate_key /etc/letsencrypt/live/$2/privkey.pem;
    server_name $2;

    location / {
        include proxy_params;
        proxy_pass http://unix:$PROJDIRPATH/$PROJDIR.sock;
    }

}
server {
    listen 80;
    listen [::]:80;

    server_name $2;

    return 302 https://$server_name$request_uri;
}" | sudo tee /etc/nginx/sites-available/$PROJDIR # Nginx will catch all requests and forward them to $PROJDIR
sudo ln -s /etc/nginx/sites-available/$PROJDIR /etc/nginx/sites-enabled
sudo rm /etc/nginx/sites-enabled/default

sudo certbot --nginx

sudo systemctl start $PROJDIR
sudo systemctl enable $PROJDIR
sudo systemctl restart nginx

echo "alias restart-server=\"sudo systemctl restart $PROJDIR\"" >> ~/.bashrc
