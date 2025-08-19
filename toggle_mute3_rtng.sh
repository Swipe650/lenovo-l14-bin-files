#!/bin/bash

# Invoke check mute and unmute bash scripts to manage toggling mute correctly

#mute_app() { qdbus com.github.radiotray_ng /com/github/radiotray_ng com.github.radiotray_ng.mute; }
mute_app() { ~/bin/check_radiotray_mute.sh; }
#unmute_app() { qdbus com.github.radiotray_ng /com/github/radiotray_ng com.github.radiotray_ng.mute; }
unmute_app() { ~/bin/check_radiotray_unmute.sh; }

# Conky countdown timer
conkytimer() {
    sec=$1
    for (( i = 0; i < sec; i++ )); do
        timer=$((sec-i))
        echo "                  ${timer}" > ~/.conkytimer
        sleep 1
    done
    rm -f ~/.conkytimer
    touch ~/.conkytimer
}

# Get current volume level and show OSD dialog
show_osd_dialog() {
    vollevel=$(amixer -D pulse get Master | awk -F 'Left:|[][]' 'BEGIN {RS=""}{ print $3 }')
    qdbus org.kde.plasmashell /org/kde/osdService org.kde.osdService.volumeChanged "${vollevel::-1}"
}

# Mute/unmute actions and top-of-the-hour dialog
top_of_the_hour_dialog() {
    mute_app
    qdbus org.kde.plasmashell /org/kde/osdService org.kde.osdService.volumeChanged 0
    conkytimer "$adlength"
    unmute_app
    show_osd_dialog
    exit
}

# Check top of the hour conditions
check_top_of_the_hour() {
    currenttime=$(date +%M)
    stations=(
        ".tr:TalkRadio:01 02 03 04:50"
        ".tr:TalkRadio:28 29 30 31 32 33 34 35 36 37:150"
        ".lbc:LBC UK:00 01 02 03 04 05 06:30"
    )

    for station in "${stations[@]}"; do
        IFS=':' read -r file station_name times adlength_value <<< "$station"
        if test -f "$file" && [[ " $times " =~ " $currenttime " ]]; then
            adlength=$adlength_value
            top_of_the_hour_dialog
        fi
    done
    }

# # Check if off-peak period
check_for_off_peak() {
    currenttime=$(date +%H%M)
    stations=(".lbc:LBC UK:120" ".tr:TalkRadio:170")

    for station in "${stations[@]}"; do
        IFS=':' read -r file station_name timeout_value <<< "$station"
        if test -f "$file" && { [ "$currenttime" -gt "1900" ] || [ "$currenttime" -lt "0600" ]; }; then
            timeout=$timeout_value
        fi
    done
}

# Default adbreak length function
default_adbreak_length() {
    timeout=185
    check_for_off_peak
    while [ "$SECONDS" -le "$timeout" ]; do
        echo "                  $((timeout - SECONDS))" > ~/.conkytimer
        sleep 1
    done
}

# Main script
check_top_of_the_hour
mute_app
qdbus org.kde.plasmashell /org/kde/osdService org.kde.osdService.volumeChanged 0
default_adbreak_length
unmute_app
show_osd_dialog
