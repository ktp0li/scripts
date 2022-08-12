#!/bin/bash
reload() {
feh --bg-fill Downloads/Bez_nazvania49_20220106023315.png
bash .config/polybar/forest/launch.sh &> /dev/null
}

start() {
xrandr --output HDMI2 --mode 2560x1440 --above eDP1
reload
}

stop() {
xrandr --output HDMI2 --off
reload
}

case $1 in
	enable | -e)
	start
	echo "HDMI2 enabled"
	;;
	disable | -d)
	stop
	echo "HDMI2 disabled"
	;;
	*)
	echo "usage: ./secmon enable|-e|disable|-d"
esac
