#!/bin/bash
gnome_session=$(pgrep -u $USER gnome-session)
export $(sed 's/\o000/\n/g;' < /proc/$gnome_session/environ | grep DISPLAY)
export $(sed 's/\o000/\n/g;' < /proc/$gnome_session/environ | grep XAUTHORITY)
export $(sed 's/\o000/\n/g;' < /proc/$gnome_session/environ | grep DBUS_SESSION_BUS_ADDRESS)

while [ $# -gt 0 ]; do
    case $1 in
	"--reload" | "-r")
	    OPTIONS+=":reload:"
	    shift
	    ;;
    esac
done

function in_option {
    [[ "$OPTIONS" = *":$1:"* ]] && return 0
    return 1
}

if in_option "reload"; then
    echo "Replacing gnome shell"
    gnome-shell --replace &
fi
