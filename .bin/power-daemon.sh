#!/bin/bash
# Written by Mussa Mipawa Shomari <mepowerleo10 at gmail.com>
# Released under the GPLv2 licence

# Warning:
# The Author offers no warranty on any misuse, error, data loss caused by the software
# Use at your own risk!
 
t=0
c=$(cat /sys/class/power_supply/AC/online)
checkstatus()
{
    # initializing the environment variables
    appname="Power Manager"
    AC=$(cat /sys/class/power_supply/AC/online)
    BAT=$(cat /sys/class/power_supply/BAT0/capacity)
    levels=(empty caution low medium good full)
    bat="/home/mepowerleo10/.local/share/icons/Flatery-Dark/panel/32@2x/battery-"

    # Is there a second battery?
    #if [ -d /sys/class/power_supply/BAT1 ];then
    #    BAT1=$(cat /sys/class/power_supply/BAT1/capacity)
    #    BAT=$((($BAT + $BAT1) / 2))
    #fi
    
    # the adapter is not connected
    if [ $AC  -lt 1 ];then
        c=0
        if [ $BAT -lt 20 ];then
            if [ $BAT -lt 10 ];then
                if [ $BAT -lt 5 ];then

                    # give the user 10 seconds to plug in powersource, or the computer suspends
                    for t in {10..1};do
                        sleep 1
                        if [ "$(cat /sys/class/power_supply/AC/online)" = "1" ];then
                            break
                        else
                            notify-send -a "$appname" -u critical "Low Battery ($BAT%)" "Battery level critical, computer will suspend in 10s"
                            echo "$(date +%a_%d-%m-%Y_%H:%M:%S)... System Suspend In $t's" -i "$bat${levels[0]}.svg"
                        fi
                    done
                    if [ "$(cat /sys/class/power_supply/AC/online)" = "0" ];then
                        ~/.local/bin/lockscreen.sh && systemctl suspend
                        echo "$(date +%a_%d-%m-%Y_%H:%M:%S)... System Suspended"
                    fi
                else
                    if [ $t = 1 ];then t=2; notify-send -a "$appname" -u normal "Very Low Battery ($BAT%)" "Battery very low, please plugin power adapter" -i "$bat${levels[0]}.svg"; fi
                    echo "$(date +%a_%d-%m-%Y_%H:%M:%S)... Battery Very Low ($BAT%)"
                fi
            else
                if [ $t = 0 ];then t=1;notify-send -a "$appname" -u low "Low Battery ($BAT%)" "Battery low, please plugin power adapter" -i "$bat${levels[1]}.svg"; fi
                echo "$(date +%a_%d-%m-%Y_%H:%M:%S)... Battery Low alert ($BAT%)"
            fi
        fi
    # is the adapter connected?
    else
        if [ $c -lt 1 ]; then
            c=1
            idx=$((($BAT*6/100)%6))
            notify-send -a "$appname" -u normal "Charging ($BAT%)" "Power adapter plugged in, battery charging" -i "$bat${levels[$idx]}-charging.svg"
        fi
 
        if [ $BAT -lt 20 ] && [ $BAT -gt 10 ];then
            t=0
        elif [ $BAT -lt 10 ] && [ $BAT -gt 5 ];then
            t=1
        elif [ $BAT -gt 98 ];then
            [ $f -eq 1 ] &&  {
                notify-send -a "$appname" -u critical "Battery Fully Charged! ($BAT%)" "Battery full, please unplug power adapter"
                f=1
        }
        else
            t=0
        fi
        
        echo "$(date +%a_%d-%m-%Y_%H:%M:%S)... Battery Charging: $BAT%"
    fi
    echo "$(date +%a_%d-%m-%Y_%H:%M:%S)... Power status: $BAT%"
}

toggle() {
    t=$(((t + 1) % 2))
}

# and infinite loop for the daemon
while true;do
    checkstatus
    sleep 2
done
