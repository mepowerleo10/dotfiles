#!/bin/bash
################################################################
###### "He who stops being better, stops being good" 	########
######					~ Oliver Cromwell				########
################################################################

details() {
	artist=$(playerctl metadata --format "{{artist}}")
	if [ ${#artist} -gt 15 ];then
		artist="${artist:0:14}..."
	fi

	title=$(playerctl metadata --format "{{title}}")
	if [ ${#title} -gt 20 ];then
		title="${title:0:19}..."
	fi

	if [ "$state" = "Playing" ];then
		state=""
	else
		state=""
	fi

	state="%{A3:playerctl stop:}$state%{A}"

	loop=$(playerctl loop)
	if [ "$loop" = "Track" ];then
		loop=" %{F#FFCC1B}%{F-} "
	else
		loop=" "
	fi

	action_btns="%{A1:playerctl previous:}%{A} $state %{A1:playerctl next:}%{A}$loop"

	action_btns="%{F#FF5A67}$action_btns%{F-}"

	stat="$action_btns%{T1}$artist - $title%{T-}"
	echo "$stat"

}

player() {
	state=$(playerctl status 2>&1)
	stat_line=""
	if [ "$state" != "No players found" ];then
		if [ "$state" != "Stopped" ];then
			duration=$(playerctl metadata --format "{{duration(position)}}|{{ duration(mpris:length) }}")
			if [ $? -eq 0 ];then
				stat_line=$(details)
				stat_line="$stat_line %{F#FF5A67}$duration%{F-}"
				stat_line="%{A1:playerctl play-pause:}$stat_line%{A}"
			fi
		else
			stat_line="%{A1:playerctl play-pause:}%{F#FF5A67} %{F-}%{T1}Nothing playing%{T-}%{A}"
		fi
	else
		stat_line="%{F#FF5A67} %{F-}%{T1}No players%{T-}"
	fi

	echo "%{T2}$stat_line%{T-}"
}

ch_loop() {
	if [ "$(playerctl loop)" != "Track" ];then
		playerctl loop Track
	else
		playerctl loop Playlist
	fi
}

while getopts "pl" opt; do
	case ${opt} in
		p) player;;
		l) ch_loop;;
		*) echo "Option not known";;
	esac
done	
