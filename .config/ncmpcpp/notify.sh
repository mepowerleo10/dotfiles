#!/bin/bash

MUSIC_DIR="/mnt/local-data/Media/Music/"
COVER="/tmp/cover.jpg"

function reset_bg {
	print "\e]20;;100x100+1000+1000\a"
}

function notify {
	artist="$(mpc -f %artist% current)"
	album="$(mpc -f %album% current)"
	title="$(mpc -f %title% current)"
	file="$(mpc -f %file% current)"
	rm -f "$COVER" &> /dev/null
	ffmpeg -i "$MUSIC_DIR$file" "/tmp/cover.jpg" -y &> /dev/null
	if [ -f "$COVER" ];then
		src="/tmp/cover.jpg"
		convert "$src" -resize 48x48 "$COVER"
		notify-send -u normal -i "$COVER" "$title" "$artist • <i>$album</i>"
	else
		notify-send -u normal "$title" "$artist • <i>$album</i>"
	fi
}

notify
