#!/bin/bash
# $ crontab -e
# */5 * * * * /Users/drninjabatman/bin/getmail.sh >/tmp/stdout.log 2>/tmp/stderr.log
set -e
mbsync="/usr/local/bin/mbsync"
notify=/usr/local/bin/terminal-notifier
notmuch=/usr/local/bin/notmuch

function printErr {
    $notify -message "$1" -title "Failure getting main";
    echo "[ERROR]" $1
    echo "$1" >&2
}

function tooBadMbsyncExit {
    printErr "mbsync failed too many times"
    exit 1
}

function getMail {
    local attempts=$1
    if [[ attempts -gt 10 ]]; then
        tooBadMbsyncExit;
    fi

    $mbsync -V gmail || getMail $(( $attempts + 1 ))
}

function log {
    echo "[GETMAIL]" $@
}

log "Getting mail..."
getMail

log "Indexing mail..."
$notmuch new >& /dev/null
unread_messages=$($notmuch count tag:unread)

log "Unread messages: $unread_messages"
if [[ $unread_messages -ne 0 ]]; then
    $notify -message "Found $unread_messages new messages" -title "New mail ($unread_messages)";
fi
