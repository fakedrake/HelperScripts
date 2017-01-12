function avail {
    command -v "$1" >/dev/null 2>&1
}

if avail pacman ; then
    alias pup="sudo pacman -Syu"
    alias p="sudo pacman -S"
    alias pse="pacman -Ss"
fi

if avail aptitude ; then
    alias pup="sudo aptitude safe-upgrade"
    alias p="sudo aptitude install"
    alias pse="aptitude search"
fi

if avail yaourt; then
    alias yup="sudo yaourt -Syu"
    alias y="sudo yaourt -S"
    alias yse="sudo yaourt -Ss"
fi

if avail brew; then
    alias pup="brew cask update && brew upgrade"
    function p { brew cask install "$1" || brew install "$1" }
    function pse { brew cask search "$1" ; brew search "$1" }
fi

if avail emacs; then
    alias e="emacs -Q -nw"
    alias se="sudo emacs -Q -nw"
fi

if avail systemctl; then
    alias scs="sudo systemctl start"
    alias scr="sudo systemctl restart"
    alias scp="sudo systemctl stop"
fi

alias zsh_git_hide="git config oh-my-zsh.hide-status 1"

# SSH aliases (x forwarding for xclip)
alias purple="ssh -X cperivol@purple"
alias futuna="ssh -X cperivol@futuna.csail.mit.edu"
alias tuvalu="ssh -X cperivol@tuvalu.csail.mit.edu"
alias ashmore="ssh -X cperivol@ashmore.csail.mit.edu"
alias yscreen='ssh -t cperivol@purple ssh -t yellow screen -R'
alias fsql="mysql -u csail --password=pass bitnami_mediawiki -h futuna.csail.mit.edu -P 3307"
alias asql="mysql -u csail --password=pass bitnami_mediawiki -h ashmore.csail.mit.edu -P 3307"
alias fscreen="ssh -t cperivol@futuna.csail.mit.edu screen -R"
alias ascreen="ssh -t cperivol@ashmore.csail.mit.edu screen -R"
alias tscreen="ssh -t cperivol@tuvalu.csail.mit.edu screen -R"
alias ascr="ssh -t drninjabatman@astaroth screen -R"
alias tsql="mysql -u csail --password=pass bitnami_mediawiki -h tuvalu.csail.mit.edu -P 3307"
alias sshaws="ssh -i ~/Desktop/id_rsa fake@ec2-54-174-134-98.compute-1.amazonaws.com"
alias awscreen="ssh -t -i ~/Desktop/id_rsa fake@ec2-54-174-134-98.compute-1.amazonaws.com screen -R"

# Server
alias pyserve='python2 -m SimpleHTTPServer'
alias rh='stack runhaskell'
alias ec="$(dirname $EMACS)/emacsclient"
alias cleanmail="notmuch tag -unread -- '*'"
