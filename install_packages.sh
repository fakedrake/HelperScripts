if ! command pacman >& /dev/null ; then
    INSTALL_CMD="sudo pacman -S"
    PKG_LIST="arch"
elif ! command apt-get >& /dev/null ; then
    INSTALL_CMD="sudo apt-get install"
    PKG_LIST="ubuntu"
fi

cat packages/common | xargs $INSTALL_CMD
cat packages/$PKG_LIST | xargs $INSTALL_CMD
