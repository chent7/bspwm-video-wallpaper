#!/bin/bash
## kill and start video background
killall xwinwrap
while pgrep -u $UID -x xwinwrap >/dev/null; do sleep 1; done
xwinwrap -fs -fdt -ni -b -nf -- mpv --input-ipc-server=/tmp/mpvsocket --loop --pause -wid WID ~/Video\ Wallpapers/Anime-Himiko-Toga-Particles-Live-Wallpaper.mp4

## logic for pausing and playing based on window focus and state 

## alternative to --input-ipc-server is with xdotool to send p key
# xdotool key --window "$(xdotool search --class mpv)" p

PLAY=false
sleep 1

## more logic can be set with focused.tiled, focused.floating focused.fullscreen...
## can be used to create logic where only a floating window is present video will play
## alternative to bspc is to use xdotool getwindowfocus
## use xprop to get window information

while true; do 
	if [ $(bspc query -N -n focused) = /dev/null ] && [ "$PLAY" == false  ]; then
		echo '{"command": ["cycle", "pause"]}' | socat - /tmp/mpvsocket
		PLAY=true
	elif [ $(bspc query -N -n focused) > /dev/null ] && [ "$PLAY" == true ]; then
		echo '{"command": ["cycle", "pause"]}' | socat - /tmp/mpvsocket
                PLAY=false
	fi
	sleep 1
done
