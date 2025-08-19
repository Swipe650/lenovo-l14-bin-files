#!/bin/bash

google_home="Kitchen home"
#google_home="Bedroom mini"
#google_home="Multiroom mini"

vol=$(/home/swipe/bin/cast-linux-amd64 --name "$google_home" status | awk -F 'Volume:' '{print $2}' | cut -c3-5)

#volup=$(echo "$vol" | awk '{print $0+0.05}')


incl=0.03
volup=`echo $vol + $incl | bc`

#/home/swipe/bin/cast-linux-amd64 --name "$google_home" volume $volup


/home/swipe/bin/set_vol_home "$volup"
