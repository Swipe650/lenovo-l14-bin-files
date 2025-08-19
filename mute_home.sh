#!/bin/bash

google_home="Kitchen home"
#google_home="Bedroom mini"
#google_home="Multiroom mini"

vol=$(/home/swipe/bin/cast-linux-amd64 --name "$google_home" status | awk -F 'Volume:' '{print $2}' | cut -c4-5 | bc -l)

    if [[ "$vol" -eq "00" ]]; then
      /home/swipe/bin/cast-linux-amd64 --name "$google_home" volume .35
      
      
    elif [[ "$vol" -gt "01" ]]; then
      /home/swipe/bin/cast-linux-amd64 --name "$google_home" volume 0
    fi 
