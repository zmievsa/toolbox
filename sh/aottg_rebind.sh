#!/bin/bash
xmodmap -e "pointer = 1 9 3 4 5 6 7 8 2 10 11"
xfconf-query -c keyboard-layout -p /Default/XkbOptions/Group -s ""
./"RC83.x86_64"
xmodmap -e "pointer = 1 2 3 4 5 6 7 8 9 10 11"
xfconf-query -c keyboard-layout -p /Default/XkbOptions/Group -s grp:alt_shift_toggle
