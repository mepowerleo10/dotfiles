#!/bin/bash
# Written by Mussa Mipawa Shomari <mepowerleo10@gmail.com>
# Released under the GPLv2 licence

# Warning:
# The Author offers no warranty on any misuse, error, data loss caused by the software
# Use at your own risk!

message() {
    echo -e "🔋battery.sh:\n\tA script to query the battery power status and return output in a formatted manner.\n\tCompatible with polybar."
    echo -e "Usage: battery.sh [options... ]"
    echo -e "\nOptions:\n  -s\tprint only the formatted battery status"
    echo -e "  -f\tprint the status with the battery percentage"
    echo -e "  -t\tprint the battery percentage (without the percentage sign)"
    echo -e "  -d\tprint debugging information"
    echo -e "License: GPLv2\n\nPlease do share!!! 😁"
}

if [[ $# -eq 0 ]]; then message; fi

bat0=$(cat /sys/class/power_supply/BAT0/capacity)
ac=$(cat /sys/class/power_supply/AC/online)
bat1=0
max_bat=100
if [ $(cat /sys/class/power_supply/BAT1/present) -eq 1 ]; then
	bat1=$(cat /sys/class/power_supply/BAT1/capacity)
	total_bat=$(expr $bat0 + $bat1 )
	total_bat=$(expr $total_bat / 2 )
else
        total_bat=$bat0
fi

colors=(f50707 f51f07 f52b07 f53307 f54607 f55207 f56607 f57a07 f58a07 f59a07 f5b607 f5c907 f5e107 f5f507 e5f507 d5f507 c5f507 aef507 9af507 82f507 62f507 07f543 07f566 07f582 07f59e 07f5c5 07f5d5 07f5f1 07e1f5)
len=${#colors[*]}
idx=$(bc <<< "scale=2; ($total_bat / $max_bat) * $len")
idx=$(printf "%0.0f" $idx)

[[ $idx -gt 28 ]] && idx=28

if [ $ac -eq 0 ];then
    label=""
    if [[ $total_bat -lt 90 ]]; then label=""; fi
    if [[ $total_bat -lt 80 ]]; then label=""; fi
    if [[ $total_bat -lt 70 ]]; then label=""; fi
    if [[ $total_bat -lt 60 ]]; then label=""; fi
    if [[ $total_bat -lt 50 ]]; then label=""; fi
    if [[ $total_bat -lt 45 ]]; then label=""; fi
    if [[ $total_bat -lt 30 ]]; then label=""; fi
    if [[ $total_bat -lt 35 ]]; then label=""; fi
    if [[ $total_bat -lt 25 ]]; then label=""; fi
    if [[ $total_bat -lt 15 ]]; then label=""; fi
    if [[ $total_bat -lt 10 ]]; then label=""; fi
else
    label=""
    if [[ $total_bat -lt 95 ]]; then label=""; fi
    if [[ $total_bat -lt 80 ]]; then label=""; fi
    if [[ $total_bat -lt 70 ]]; then label=""; fi
    if [[ $total_bat -lt 55 ]]; then label=""; fi
    if [[ $total_bat -lt 46 ]]; then label=""; fi
    if [[ $total_bat -lt 31 ]]; then label=""; fi    
    if [[ $total_bat -lt 10 ]]; then label=""; fi
fi

while getopts stfhd option; do
    case "$option" in
        s)
            echo "%{F#${colors[$idx]}}$label";;
        f)
            echo "%{F#${colors[$idx]}}$label ($total_bat%)";;
        t)
            echo "$total_bat";;
        h)
            message;;
        d)
            echo "%{F#${colors[$idx]}}$label ($total_bat%), len=$len, idx=$idx, max=$max_bat";;
        *)
           message;; 
    esac
done
