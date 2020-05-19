#!/bin/bash

t=0

toggle() {
	t=$(((t + 1) % 2))
	notify-send "DUNST_COMMAND_TOGGLE"
}

trap "toggle" USR1

while true;do
	if [ $t -eq 1 ];then
		icon="%{F#ffcc1b}%{F-}"
	else
		icon=""
	fi
	echo $icon

	sleep 1 &
	wait
done
