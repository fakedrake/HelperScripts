export EMACS=/Applications/Emacs.app/Contents/MacOS/bin/Emacs
export HL_PIPE_LESS=/usr/local/bin/src-hilite-lesspipe.sh

if [[ -z $HOMEBREW_GITHUB_API_TOKEN ]]; then
    echo "Set HOMEBREW_GITHUB_API_TOKEN in ~/bin/zsh/personal.zsh"
    echo "create one at https://github.com/settings/tokens"
fi

export PATH=${HOME}/Library/Haskell/bin:$PATH
