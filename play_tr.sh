#!/bin/bash

touch ~/.tr

if [[ -f ~/.lbc ]]; then rm ~/.lbc & touch ~/.tr
fi

radiotray-ng &
sleep 1
 
mute () { "$HOME/bin/checkradiotray_mute"; }
unmute () { "$HOME/bin/checkradiotray_unmute"; }
talkradio () { qdbus com.github.radiotray_ng /com/github/radiotray_ng com.github.radiotray_ng.play_station Imported 'TalkRadio' ; }
setvol () { qdbus com.github.radiotray_ng /com/github/radiotray_ng com.github.radiotray_ng.set_volume 51 ; }

setvol
talkradio
sleep 3
unmute
