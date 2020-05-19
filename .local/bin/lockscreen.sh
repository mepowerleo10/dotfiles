#!/bin/bash

lockimage="/home/mepowerleo10/Pictures/real_einsteined.png"

scrot /tmp/screen.png
convert /tmp/screen.png -scale 10% -scale 1000%  -gamma 0.8 /tmp/screen.png
#[[ -f $1 ]] && convert /tmp/screen.png $1 -gravity center -composite -matte /tmp/screen.png
convert /tmp/screen.png $lockimage -gravity center -region 10x10-400+100 -composite -matte /tmp/screen.png
# dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop
i3lock \
    -i /tmp/screen.png \
    --radius=64 \
    --clock \
    --timepos="tx+683:ty+260" \
    --datestr="%A, %m %Y" \
    --wrongtext="Nope!" \
    --veriftext="We good!"
rm /tmp/screen.png
