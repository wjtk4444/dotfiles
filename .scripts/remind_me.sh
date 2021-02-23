#!/bin/bash

if [[ "$#" -eq 2 ]]; then
    title="$1"
    time="$2"
else
    title=`kdialog --inputbox 'remind me about'`
    [[ -z "$title" ]] && exit
    time=`kdialog --inputbox 'in'`
    [[ -z "$time" ]] && exit
fi

time=`echo "$time" | sed -E 's/d|h|m|s/\0 /g'`

delaycommand_second_arg='`kdialog --inputbox "delay by"`'
delaycommand="Delay:.scripts/remind_me.sh '$title' $delaycommand_second_arg"

sleep $time && notify-send.sh -u critical -a 'REMINDER' -i clock "$title" -o "$delaycommand" -o 'Close:exit'

