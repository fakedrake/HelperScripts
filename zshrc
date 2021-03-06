#!/usr/bin/zsh
HELPER=$HOME/Projects/helperscripts
function try_source {
    file="$HELPER/zsh/$1"
    if [ -f "$file" ]; then
	source "$file"
    fi
}

if [ $(uname) = "Darwin" ]; then
    try_source osx.zsh
fi

try_source personal.zsh
try_source oh-my-zsh.zsh
try_source theme.zsh
try_source variables.zsh
try_source aliases.zsh
try_source functions.zsh
try_source bash_compat.zsh
try_source mit.zsh
# try_source thinksilicon.zsh
try_source python.zsh
# try_source depot_tools.zsh
try_source gpg.zsh
try_source completions/notmuch-completion.zsh


export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

PERL_MB_OPT="--install_base \"/Users/drninjabatman/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/drninjabatman/perl5"; export PERL_MM_OPT;


if [[ "$TERM" = "dumb" ]]; then
   export PS1="> "
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/usr/local/opt/gettext/bin:$PATH"
export PATH=${HOME}/perl5/perlbrew/bin:$PATH

