# Give the names of the original and copied file and will get the
# compaltetion progress.
function cpprg {
    du $1 | awk '{print $1}' | tail -2 \
	| python -c "a = float(raw_input()); b = float(raw_input()); print a/b"
}

# find the first venv backwards and activate it.
pv() {
    A=./*/bin/activate;
    for i in {1..$(pwd | grep -o / | wc -l)}; do
	if bash -c "ls $A" 2> /dev/null; then
	    source $(bash -c "ls $A | head -1");
	    break;
	fi;
	A=../$A;
    done
}

# Only argument is the url. For 3.12 it would be
# https://bitbucket.org/migerh/workspace-grid-gnome-shell-extension/downloads/workspace-grid%40mathematical.coffee.gmail.com-for-3.12.zip
update_workspace_grid() {
    wget $1 -O /tmp/workspace-grid.zip
    cd ~/.local/share/gnome-shell/extensions
    unzip /tmp/workspace-grid.zip
}


function gcl {
    local project_path="$1"
    local project_name=$(basename $project_path)
    shift

    if [[ "$1" = $project_name ]]; then
	git clone "git@github.com:fakedrake/$project_name" $@ ||
	    git clone "git@github.com:codebendercc/$project_name" $@
    elif [[ $(dirname $(dirname "$project_path")) = "." ]]; then
	git clone "git@github.com:$project_path" $@ ||
            git clone "git@bitbucket.org:$project_path" $@
    else
        git clone $project_path $@
    fi

    cd project_name
}


function ec {
    emacsclient "$1" &
}


function yt {
    youtube-dl -x --audio-format mp3 --restrict-filenames --format "bestaudio" --audio-qualit 2 $1 -o "$HOME/Music/youtube/%(title)s.mp3"
}

function extract {
    if [ -z "$1" ]; then
        # display usage if no parameters given
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    else
        if [ -f "$1" ] ; then
            NAME=${1%.*}
            mkdir $NAME && cd $NAME
            case "$1" in
                *.tar.bz2) tar xvjf ../"$1" ;;
                *.tar.gz) tar xvzf ../"$1" ;;
                *.tar.xz) tar xvJf ../"$1" ;;
                *.lzma) unlzma ../"$1" ;;
                *.bz2) bunzip2 ../"$1" ;;
                *.rar) unrar x -ad ../"$1" ;;
                *.gz) gunzip ../"$1" ;;
                *.tar) tar xvf ../"$1" ;;
                *.tbz2) tar xvjf ../"$1" ;;
                *.tgz) tar xvzf ../"$1" ;;
                *.zip) unzip ../"$1" ;;
                *.Z) uncompress ../"$1" ;;
                *.7z) 7z x ../"$1" ;;
                *.xz) unxz ../"$1" ;;
                *.exe) cabextract ../"$1" ;;
                *) echo "extract: '$1' - unknown archive method" ;;
            esac
        else
            echo "'$1' - file does not exist"
        fi
    fi
}


alias kl="k tasks"
alias kt="k work"
alias kw="k work"
alias kd="k description"
alias kdt="k details"
alias kst="k add subtask"

function kmr {
    times=${1:-1}

    if [[ $times -gt 4 ]]; then
        times=4
    fi

    until [[ $times -eq 0 ]]; do
        k move right
        times=$(($times - 1))
    done

}

function kml {
    times=${1:-1}

    if [[ $times -gt 4 ]]; then
        times=4
    fi

    until [ $times -eq 0 ]; do
        k move left
        times=$(($times - 1))
    done
}

function csailShare {
    if [ -z "$1" ]; then
        fname="$(ls -t $HOME/Desktop | head -1)"
    else
        fname="$1"
    fi

    date="$(date +%s)"
    echo "Uploading: http://people.csail.mit.edu/cperivol/$(basename $fname)"
    scp "$fname" "cperivol@futuna.csail.mit.edu:/afs/csail.mit.edu/u/c/cperivol/public_html/$(Basename $fname)"
}

function gbt {
    git log --graph --decorate "$@"
}

export NOTIFICATION_TIME=15000
function notify {
    cmd=$(history | sed -n 's_[0-9]*  \(.*\)_\1_p' | tail -1)
    now=$(date +%s)
    if [[ $(($now-$LAST_COMMAND_TIMESTAMP)) -gt $NOTIFICATION_TIME ]]
    LAST_COMMAND_TIMESTAMP=$now
}

alias fgit="ssh -C forum git -C /home/drninjabatman/Projects/FluiDB"
