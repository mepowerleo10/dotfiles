#!/bin/bash
################################################################
###### "He who stops being better, stops being good" 	########
######					~ Oliver Cromwell				########
################################################################

STATE_FILE="$HOME/.config/mpd/state"

details() {
	#alias mpc="mpc current"
	artist=$(mpc current -f "[%artist%]")
	if [ ${#artist} -gt 15 ];then
		artist="${artist:0:14}..."
	fi

	title=$(mpc current -f "[%title%]")
	if [ ${#title} -gt 20 ];then
		title="${title:0:19}..."
	fi

	if [ "$state" = "pause" ];then
		state=""
	else
		state=""
	fi
	
	#unalias mpc

	state="%{A3:mpc stop:}$state%{A}"

	loop=$(head -n 10 $STATE_FILE | grep "^single" | awk -F ": " '{print $2}')
	if [ $loop -eq 1 ];then
		loop=" %{F#FFCC1B}%{F-} "
	else
		loop=" "
	fi

	action_btns="%{A1:mpc prev:}%{A} $state %{A1:mpc next:}%{A}$loop"

	action_btns="%{F#FF5A67}$action_btns%{F-}"

	stat="$action_btns%{T1}$artist - $title%{T-}"
	echo "$stat"

}

player() {
	state=$(head -n 5 $STATE_FILE | grep "^state" | awk -F ": " '{print $2}')
	stat_line=""
	if [ " " = " " ];then
		if [ "$state" != "stop" ];then
				duration="$($HOME/.bin/mpdtimer)|$(mpc current -f %time%)"
			if [ $? -eq 0 ];then
				stat_line=$(details)
				stat_line="$stat_line %{F#FF5A67}$duration%{F-}"
				stat_line="%{A1:mpc toggle &> /dev/null:}$stat_line%{A}"
			fi
		else
			stat_line="%{A1:mpc toggle &> /dev/null:}%{F#FF5A67} %{F-}%{T1}Nothing playing%{T-}%{A}"
		fi
	else
		stat_line="%{F#FF5A67} %{F-}%{T1}No players%{T-}"
	fi

	echo "%{T2}$stat_line%{T-}"
}

ch_loop() {
	if [ $(head -n 10 $STATE_FILE | grep '^single' | awk -F ': ' '{print $2}') != 1 ];then
		mpc single on
	else
		mpc single off
	fi
}

while getopts "pl" opt; do
	case ${opt} in
		p) player;;
		l) ch_loop;;
		*) echo "Option not known";;
	esac
done	
