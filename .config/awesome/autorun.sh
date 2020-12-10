#!/bin/bash

function run {
    if ! pgrep -f $1 ;
    then
        $@&
    else
        pkill $1
        $@&
    fi
}

programs=("nm-applet" "blueman-applet" "albert" "copyq" "pasystray" 'picom -cCGfF -o 0.38 -O 200 -I 200 -t 0 -l 0 -r 5 -m 0.88 --focus-exclude "x = 0 && y = 0 && override_redirect = true"')
for program in ${programs[*]};do
    run "${program}"
done