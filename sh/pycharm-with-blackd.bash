#!/bin/bash

blackd &
"~/.local/share/JetBrains/Toolbox/apps/PyCharm-C/ch-0/201.7223.92/bin/pycharm.sh" $1
kill %1
