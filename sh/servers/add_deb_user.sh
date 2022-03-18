#!/bin/sh
if [ $# -eq 0 ]
  then
    echo "No arguments supplied. You need to put the name of your user"
    exit
fi
adduser $1;
usermod -aG sudo $1;
cp -r ~/.ssh /home/$1;
chown -R $1:$1 /home/$1/.ssh;
