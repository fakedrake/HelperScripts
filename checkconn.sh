#!/bin/bash

state=none;
while true; do
    if ! ping -c 1 -t 1 8.8.8.8; then
        echo "[$(date)] No connection";
        if [[ ! "$state" = "offline" ]]; then
            terminal-notifier -title "Connection lost" -message "waiting...";
        fi
        state=offline;
        sleep 1;
    else
        echo "[$(date)] Connection lost";
        if [[ ! "$state" = "online" ]]; then
            terminal-notifier -title "Connection found" -message "Horay";
        fi;
        sleep 2;
        state=online;
    fi;
done
