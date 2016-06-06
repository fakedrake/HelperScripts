if [ -f $HOME/bin/pypy/bin/activate ]; then
    . $HOME/bin/pypy/bin/activate
else
    echo "You may want to setup a venv:"
    echo "\tvirtualenv2 --no-site-packages $HOME/bin/py"
fi
