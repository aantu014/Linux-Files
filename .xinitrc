#!/bin/bash
#

# 1280x720 = 720p X220
#hash fswebcam && fswebcam -q --no-banner -r 1280x720 ~/private/login-photos/$(date +%Y-%m-%dT%H).jpg &


INTERFACE=$(ip a | grep "<BROADCAST" |cut -d ":" -f2 | cut -d " " -f2| sed 's/://g')
cap=$(cat /sys/class/power_supply/BAT0/capacity)
#max=100

xcompmgr -c &

while true
do
#	TEMP="$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))C"
#	VOL="Volume:($(amixer get Master | tail -1 | sed 's/.*\[\([0-9]*%\)\].*/\1/'))"
	LOCALTIME=$(date "+%m/%d/%Y %l:%M %p")
	BAT="Battery:(${cap}%)"
	
	xsetroot -name "$INTERFACE  $BAT $LOCALTIME"

	sleep 1m
done &

nitrogen --restore &

exec dwm
