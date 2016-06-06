#!/bin/bash
_pid="$!"

function fail {
    echo "$@(pid=$_pid)" 1>&2
    kill $_pid
}

function iface {
    ret=$(ip link | grep "state UP" | sed -e 's/^[0-9]*: \([^:]*\):.*/\1/' | head -1)
    if [ -z "$ret" ]; then
	fail "No interface is up, pull one up with 'ip link set <iface> up' and rerun"
    fi
    echo $ret
}

function read_mac
{
    ifc=$1
    if [ -n "$ifc" ]; then
	ip link | grep $ifc -A 1 | tail -1 | grep -o -E '[0-9a-f:]{17}' | head -1
    else
	fail "Provide an iface to read_mac"
    fi
}

function my_run
{
    echo "Run: $@"
    "$@" || (echo "Failed" && exit 0)
}


function main {
    IFACE=$(iface)

    echo "Iface found $IFACE"
    if [ ! "$IFACE" ]; then
	fail "Interface not found"
    fi

    MAC=$(read_mac $IFACE)
    PYTHON_NMAC="mac='$MAC'.split(':'); ne=(int(mac[-1],16)+1)&0xff; mac[-1]='%x' % ne; print(':'.join(mac))"
    NMAC=$(python -c "$PYTHON_NMAC")

    echo "Disabling $IFACE"
    my_run ip link set $IFACE down
    echo "Old mac is $MAC, setting mac to $NMAC"
    my_run ip link set addr $NMAC dev $IFACE
    NNMAC=$(read_mac $IFACE)
    if [[ "$NMAC" = "$NNMAC" ]]; then
	echo "Successfuly changed mac address."
	echo "Bringing up interface $IFACE."
	my_run ip link set $IFACE up
    else
	echo "An error has occured. Mac now is $NNMAC."
    fi
}

while [ $# -gt 0 ]; do
    no_main="y"
    case "$1" in
	"-m") read_mac $(iface);;
	"-i") iface;;
    esac
    shift
done

if [ -z "$no_main" ]; then
    main
fi
