HL_PIPE_LESS=${HL_PIPE_LESS:-/usr/share/source-highlight/src-hilite-lesspipe.sh}
if [ -f $HL_PIPE_LESS ]; then
    export LESSOPEN="| $HL_PIPE_LESS %s"
    export LESS=' -R'
else
    echo "Less highlighting scripts not found, install it with"
    echo "\t$ p source-highlight"
    echo "Make sure it is in $HL_PIPE_LESS"
fi

export EDITOR='emacsclient'
export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/bin/core_perl:$HOME/.rvm/bin:/usr/local/texlive/2015/bin/x86_64-darwin:$PATH
export PATH="$HOME/.cabal/bin:/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export COMPLETION_WAITING_DOTS="true"
# CCache
if false; then
    export CC="ccache clang -Qunused-arguments"
    export CXX="ccache clang++ -Qunused-arguments"
    # Build chromium: GYP_GENERATORS="ninja" ./build/gyp_chromium
fi

maybe_fail_code='$(x=$?;[[ $x = "0" ]] || echo "(fail: $x)")'
export PS1=$maybe_fail_code$PS1
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PATH=$PATH:/Users/drninjabatman/.cabal/bin
export EDITOR="$(dirname $EMACS)/emacsclient"
