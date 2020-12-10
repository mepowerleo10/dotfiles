#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Mail : adi1090x@gmail.com
## Github : @adi1090x
## Reddit : @adi1090x

rofi_command="rofi -theme ~/.config/rofi/themes/powermenu.rasi"
uptime=$(uptime -p | sed -e 's/up //g')

notify=$(cat /tmp/notify)

if [ $notify = "true" ]; then
  notifications=""
else
  notifications=""
fi

# Options
shutdown=""
reboot=""
lock=""
suspend=""
logout=""

# Variable passed to rofi
options="$shutdown\n$reboot\n$lock\n$suspend\n$logout\n$notifications"

chosen="$(echo -e "$options" | $rofi_command -p "UP - $uptime" -dmenu -selected-row 2)"
case $chosen in
    $shutdown)
        systemctl poweroff
        ;;
    $reboot)
        systemctl reboot
        ;;
    $lock)
        #$HOME/.local/bin/lockscreen.sh
        betterlockscreen --lock dimblur
        ;;
    $suspend)
		    #$HOME/.local/bin/lockscreen.sh
        systemctl suspend
        betterlockscreen --lock dimblur
        ;;
    $logout)
        awesome-client 'awesome.quit()'
        ;;
    $notifications)
        if [ $notify = "true" ]; then
          awesome-client 'naughty.suspend()'
          echo "false" > /tmp/notify
        else
          awesome-client 'naughty.resume()'
          echo "true" > /tmp/notify
        fi
        ;;
esac

