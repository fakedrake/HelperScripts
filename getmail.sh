#!/bin/bash
# $ crontab -e
# */5 * * * * NOTIFY=y /Users/drninjabatman/bin/getmail.sh >/tmp/stdout.log 2>/tmp/stderr.log
set -e
mbsync="/usr/local/bin/mbsync"
notify=/usr/local/bin/terminal-notifier
notmuch=/usr/local/bin/notmuch
emacsclient=/Applications/Emacs.app/Contents/MacOS/bin/emacsclient
nm="$emacsclient -e \"(progn (call-interactively 'nm) (call-interactively 'other-frame))\""
pid=$!

[ -x $mbsync ] || exit 1
killall mbsync || true
function mbsyncRunning {
    ps aux | grep "mbsyn[c]" > /dev/null
}
function killMbsync {
    killall mbsync || true
}

function fail {
    if mbsyncRunning; then
        log "Fail: already running mbsync"
    else
        log "Fail: Something went wrong with mbsync"
    fi
    exit 1
}

function has_internet {
    /sbin/ping -c 1 8.8.8.8 > /dev/null
}

function log {
    if [[ -x $notify ]] && [[ -n $NOTIFY ]]; then
        $notify -title "E-Mail" -message "$@" -execute "$nm"
    else
        echo $@
    fi
}

function waitForMbsyncToStop {
    for i in {0..10}; do
        echo "Waiting for mbsync $i..."
        if ! mbsyncRunning; then
            return
        fi
        sleep 2;
    done
    killMbsync
}

function getBox {
    if ! $mbsync "$1"; then
        if ! waitForMbsyncToStop || ! $mbsync "$1"; then
            log "Failed: $mbsync $1";
            fail;
        fi
    fi

    if ! $notmuch new; then
        log "Failed: $notmuch new";
        fail;
    fi

    local new_mail=$($notmuch count tag:unread);
    if [[ $new_mail -gt 0 ]]; then
        log "New mail: $new_mail";
    fi
}

if ! has_internet; then
    echo "No internet!"
    exit 1;
fi

getBox icfp
getBox "gmail:[Gmail]/All Mail"
getBox gmail
