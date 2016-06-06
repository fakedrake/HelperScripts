#!/bin/sh

NOTIFY_TIME=500

while true; do
    if [ $(acpi -b | awk '{print $5}' | sed s/://g) -lt $NOTIFY_TIME ] && acpi -b | grep "Discharging" > /dev/null; then
	notify-send "$(acpi -b)"
    fi
    sleep 120
done
