DEPOT_TOOLS=$HOME/bin/depot_tools

if [[ ! -d "$DEPOT_TOOLS" ]]; then
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git $DEPOT_TOOLS
fi

export PATH=$DEPOT_TOOLS:$PATH
