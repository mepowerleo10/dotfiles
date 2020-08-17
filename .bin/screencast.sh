#!/bin/sh

#read -r X Y W H G ID < <(slop --highlight --tolerance=0 --color=0.3,0.4,0.6,0.4 -f "%x %y %w %h %g %i" -D)
#slop --highlight --tolerance=0 --color=0.3,0.4,0.6,0.4


#! /bin/bash
 # -*- mode: sh -*-
 
 
 KEY=$RANDOM
 
 res1=$(mktemp --tmpdir term-tab1.XXXXXXXX)
 res2=$(mktemp --tmpdir term-tab2.XXXXXXXX)
    
out=$(mktemp --tmpdir term-out.XXXXXXXX)

# cleanup
trap "rm -f $res1 $res2 $out" EXIT

export YAD_OPTIONS="--bool-fmt=t --separator='\n' --quoted-output"

width=${geom%%x*}
height=${geom##*x}

select_region="disabled"
full_screen="f"
webcam="f"

select_region() {
    slop --highlight --tolerance=0 \
        --color=0.3,0.4,0.6,0.4 -f \
        "%x %y %w %h %g %i" -D
}

# export -f region

# export select_reg='@bash -c "region"'

# main page
yad --plug=$KEY --tabnum=1 --form \
    --field="Fullscreen:chk" "${full_screen:-false}" \
    --field="Select Region:fbtn" "$select_region" \
    --field="Enable WebCam:chk" ${webcam:-false} \ > $res1 &

# misc page
echo -e $misc | yad --plug=$KEY --tabnum=2 --text-info --editable > $res2 &

# main dialog
yad --window-icon=utilities-terminal \
    --notebook --key=$KEY --tab="ScreenCast" --tab="Misc" \
    --title="FlameCast" --image=utilities-terminal \
    --width=400 --image-on-top --text="FlameCast Screen Recorder"

# recreate rc file
if [[ $? -eq 0 ]]; then
    mkdir -p ${rc_file%/*}

    eval TAB1=($(< $res1))
    eval TAB2=($(< $res2))
fi

echo region