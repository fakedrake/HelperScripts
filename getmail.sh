#!/bin/bash
# $ crontab -e
# */5 * * * * NOTIFY=y /Users/drninjabatman/bin/getmail.sh >/tmp/stdout.log 2>/tmp/stderr.log
set -e
mbsync=$(which mbsync)
notify=/usr/local/bin/terminal-notifier
notmuch=$(which notmuch)
emacsclien=$(which emacsclient)
if [[ -z "$emacsclient" ]]; then
    emacsclient=/Applications/Emacs.app/Contents/MacOS/bin/emacsclient
fi

nm="$emacsclient -e \"(progn (call-interactively 'nm) (call-interactively 'other-frame))\""
pid=$!
this_file=$0

[ -x $mbsync ] || exit 1
killall mbsync || true

function notification {
    if [[ -x /usr/local/bin/terminal-notifier ]]; then
        /usr/local/bin/terminal-notifier -title "$1" -message "$2" -exec "$3"
    elif [[ -x /usr/bin/notify-send ]]; then
        /usr/bin/notify-send "$1" "$2"
    fi
}
function mbsyncRunning {
    ps aux | grep "mbsyn[c]" > /dev/null
}
function killMbsync {
    killall $this_file || true
}

function fail {
    local msg=${1:-"Something went wrong with mbsync"}
    if ! mbsyncRunning; then
        log "Fail: $msg"
    fi
    exit 1
}

function has_internet {
    ping -c 1 8.8.8.8 > /dev/null
}

function log_top_unread {
    notmuch search --output=messages tag:unread \
        | xargs notmuch show --entire-thread=false --format=text \; \
        | sed "s/'/ /" \
        | awk '/header{/{from="No sender";subject="No subject"}
              /From: /{$1="";from=$0}
              /Subject: /{$1="";subject=$0}
              /header}/{print "terminal-notifier -title " "'"'"'"from"'"'"'  -message '"'"'"subject"'"'"'" }' \
        | sed "s/' /'/g" | sed "s/''/' '/" | head -1 | bash
}

function log {
    notification "E-Mail" "$@" "$nm"
}

function waitForMbsyncToStop {
    for i in {0..10}; do
        echo "Waiting for mbsync $i..."
        if ! mbsyncRunning; then
            return
        fi
        sleep 2;
    done
}

function getBox {
    if ! $mbsync "$1"; then
        if ! waitForMbsyncToStop && $mbsync "$1"; then
            fail "$ mbsync $1 ($?)";
        fi
    fi

    if ! $notmuch new; then
        log "Failed: $ notmuch new";
        fail;
    fi

    local new_mail=$($notmuch count tag:unread);
    if [[ $new_mail -gt 1 ]]; then
        log "New mail: $new_mail";
    elif [[ $new_mail -gt 0 ]]; then
        log_top_unread
    fi
}

if ! has_internet; then
    echo "No internet!"
    exit 1;
fi

getBox icfp
getBox "gmail:[Gmail]/All Mail"
getBox gmail
