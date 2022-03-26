#!/bin/sh

## lc.sh
## Artium Nihamkin
## August 2013
## 
## This script will to run "ls" or "cat" depending the type of the input.
##
## Examples where "ls" is invoked:
##    ./lc.sh file.txt
##    ./lc.sh
## Examples where "cat" is invoked
##    ./lc.sh ~/directory.name
##    ./lc.sh does.not.exist
##    echo "xxx" | ./lc.sh 
##

# If stdin present, assume user meant cat
#
if [ ! -t 0 ] 
then
    cat "$@"
    return
fi

# Find the argument that is file/directory name and test it
# to find out if it is an existing directory. Other arguments are 
# options and thus will begin with an "-".
#
for v in "$@" 
do
    if [ '-' != `echo "$v" | cut -c1 ` ] 
    then
        if [ -d "$v" ]
        then
            # A directory, use "ls".
            #
            ls "$@"
            return
         else
            # Not a directory, use 'cat'.
            # If this is not a file or a directory then cat will
            # print an error message:
            # cat: xxx: No such file or directory
            #
            cat "$@"
            return
        fi
    fi  
done

# No file name provided, assume the user is trying to ls 
# the working directory
#
ls "$@"
