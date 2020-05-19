#!/usr/bin/env bash

FONT="Consolas 11"
# position values:
# 1 2 3
# 8 0 4
# 7 6 5
POSITION=0
YOFF=30

theme="~/.config/rofi/themes/basicfloat.rasi"
definition="The Dictionary...."
#word="$(echo "$definition" | rofi -dmenu -p "define" -font "$FONT" -location "$POSITION" -yoffset "$YOFF" -dpi 100)"
while true; do
    echo $word
    if [ "$word" = "quit dictionary" ]; then
        exit
    fi
    echo "quit dictionary" > /tmp/dict_definition
    definition="$(dict $word >> /tmp/dict_definition 2>&1)"
    word="$(cat /tmp/dict_definition | rofi -dmenu -p "define" -theme $theme)"
done
