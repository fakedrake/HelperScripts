#!/bin/bash
# LICENSE: PUBLIC DOMAIN
# switch between us, gr

# If an explicit layout is provided as an argument, use it. Otherwise, select the next layout from
# the set [us, fr, de].
if [[ -n "$1" ]]; then
    setxkbmap $1
else
    layout=$(setxkbmap -query | awk 'END{print $2}')
    case $layout in
        us)
            setxkbmap gr
            ;;
        *)
            setxkbmap us
            ;;
    esac
fi
