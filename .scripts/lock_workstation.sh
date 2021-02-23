#!/bin/bash

# check output of "xinput list" command and write your mouse name down
mouse_name='G502'
mouse_ids=`xinput list | grep "$mouse_name" | sed 's/.*id=\([0-9]\+\).*/\1/g'`

toggle_left_display.sh 16 

# mute audio
pactl suspend-source  alsa_input.usb-Samson_Technologies_Samson_GoMic-00.analog-stereo true
pactl set-source-mute alsa_input.usb-Samson_Technologies_Samson_GoMic-00.analog-stereo true
pactl set-sink-mute   alsa_output.usb-Topping_D30-00.analog-stereo true

# pause music if playing, don't resume automatically
mpc pause

# lock workstation
loginctl lock-session

# make sure everything's locked
sleep 1

# turn mouse off
for id in $mouse_ids; do # no quotes over $mouse_ids to treat it as an array 
    xinput --disable $id
done

# turn screens off
xset -dpms
xset dpms force off

# wait for the user to unlock workstation
while [ $(qdbus org.freedesktop.ScreenSaver /ScreenSaver org.freedesktop.ScreenSaver.GetActive) = 'true' ]; do
    sleep 0.25
done

# turn mouse on
for id in $mouse_ids; do # no quotes over $mouse_ids to treat it as an array
    xinput --enable $id
done

# unmute audio
pactl suspend-source  alsa_input.usb-Samson_Technologies_Samson_GoMic-00.analog-stereo false
#pactl set-source-mute alsa_input.usb-Samson_Technologies_Samson_GoMic-00.analog-stereo false
pactl set-sink-mute   alsa_output.usb-Topping_D30-00.analog-stereo false
