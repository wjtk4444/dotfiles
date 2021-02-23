#!/bin/bash

curr=`sudo ddccontrol -r 0x60 dev:/dev/i2c-8 2>&1 | tail -n1 | sed 's/^.*+\/\([0-9]\+\)\/.*$/\1/'`
if [[ ! -z $1 ]]; then
    new=$1
elif [[ $curr == 15 ]]; then
    new=16
elif [[ $curr == 16 ]]; then
    new=15
else
    notify-send "something's gone terribly wrong in toggle_right_display.sh"
    exit 1
fi

if [[ $new != $curr ]]; then
    sudo ddccontrol -r 0x60 -w $new dev:/dev/i2c-8
fi

    
