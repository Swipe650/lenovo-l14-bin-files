#!/bin/bash

touch ~/.lbc

if [[ -f ~/.tr ]]; then rm ~/.tr & touch ~/.lbc
fi


radiotray-ng &
sleep 1
 
mute () { "$HOME/bin/checkradiotray_mute"; }
unmute () { "$HOME/bin/checkradiotray_unmute"; }
lbc () { qdbus com.github.radiotray_ng /com/github/radiotray_ng com.github.radiotray_ng.play_station Imported 'LBC UK' ; }
setvol () { qdbus com.github.radiotray_ng /com/github/radiotray_ng com.github.radiotray_ng.set_volume 51 ; }

setvol
lbc
sleep 3
unmute
