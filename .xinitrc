#!/bin/bash
# Taken from:
#	https://raw.github.com/kaihendry/Kai-s--HOME/master/.xinitrc
#
# for terminus font in Archlinux :(


# 1280x720 = 720p X220
#hash fswebcam && fswebcam -q --no-banner -r 1280x720 ~/private/login-photos/$(date +%Y-%m-%dT%H).jpg &

cap=$(cat /sys/class/power_supply/BAT0/capacity)
max=100


while true
do
	VOL="Volume: $(amixer get Master | tail -1 | sed 's/.*\[\([0-9]*%\)\].*/\1/')"
	LOCALTIME=$(date "+%m/%d/%Y %l:%M %p")
	INTERFACE=$(ip a | grep "<BROADCAST" |cut -d ":" -f2 | cut -d " " -f2| sed 's/://g')
	TEMP="$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))C"


	
	if [[ "$cap" < "max" ]]
	then
		BAT="Battery: ${cap}%"
		xsetroot -name "$INTERFACE $VOL $BAT $LOCALTIME"
	else
		xsetroot -name "$INTERFACE $VOL $LOCALTIME"
	fi
	sleep 20s
done &

nitrogen --restore &

exec dwm
