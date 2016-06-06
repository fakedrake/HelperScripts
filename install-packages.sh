#!/bin/bash

function printi {echo "[INFO] $*"}

function printe {echo "[ERROR] $*"}

function setup_arch {
    # Package manager
    PAC=pacman -S
    VIRTUALENV=virtualenv2


    # Packages
    PYTHON_PAC=python2
    PIP_PAC=python2-pip
    VIRTUALENV_PAC=python2-virtualenv
}

function setup_ubuntu {
    # Package manager
    PAC=apt-get install

    # Packages
    PYTHON_PAC=python
}

function install_pac {
    while $#; do
	case $1; in
	    "python")
		[ command -v $PYTHON_PAC ] || $PAC $PYTHON_PAC $PIP_PAC $VIRTUALENV_PAC
		$VIRTUALENV --no-site-packages $HOME/bin/py/

		# Local copy of virtualenv
		pip install virtualenv
	esac
    done
}

if command -v pacman; then
    printi "You are running arch"
    setup_arch
elif command -v apt-get; then
    printi "You are running ubuntu"
    setup_ubuntu
else
    printe "Cannot determine you distribution, sorry."
    exit 1
fi
