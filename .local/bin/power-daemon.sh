#!/bin/bash

initialize () {
	dev_path="/sys/class/power_supply"

	# the state of the AC power adapter
	AC=$(cat $dev_path/AC/online)
	BAT=$(cat $dev_path/BAT0/capacity)

	# does the second battery exist?
	if [ -e "$dev_path/BAT1" ];then
		bat1=$(cat $dev_path/BAT1/capacity)
		BAT=$(bc <<< "scale=2; ($BAT+$bat1)/2")
	fi
}

notify () {
	
}
