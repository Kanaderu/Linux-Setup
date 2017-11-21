#!/bin/bash

# Script for installing tmux on systems where you don't have root access.
# tmux will be installed in $TARGET_DIR/bin.
# It's assumed that wget and a C/C++ compiler are installed.

# exit on error
set -e

export CPPFLAGS="-P"
TMUX_VERSION=2.6
TMUX_SOURCE=https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz

TARGET_DIR=$HOME/local                      # set TMUX install location
BUILD_DIR=`pwd`/build                       # set TMUX working directory location (can delete this afterwards)
OFFLINE=false

# create our directories
mkdir -p $TARGET_DIR $BUILD_DIR
cd $BUILD_DIR

# download source files for tmux, libevent, and ncurses (otherwise assume they're already downloaded)
if ! $OFFLINE; then
    wget -O tmux-${TMUX_VERSION}.tar.gz ${TMUX_SOURCE}
    wget https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
    wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz
fi

# extract files, configure, and compile
############
# libevent #
############
tar xvzf libevent-2.1.8-stable.tar.gz
cd libevent-2.1.8-stable
./configure --prefix=$TARGET_DIR --disable-shared
make
make install
cd ..

############
# ncurses  #
############
tar xvzf ncurses-6.0.tar.gz
cd ncurses-6.0
./configure --prefix=$TARGET_DIR
make
make install
cd ..

############
# tmux     #
############
tar xvzf tmux-${TMUX_VERSION}.tar.gz
cd tmux-${TMUX_VERSION}
./configure CFLAGS="-I$TARGET_DIR/include -I$TARGET_DIR/include/ncurses" LDFLAGS="-L$TARGET_DIR/lib -L$TARGET_DIR/include/ncurses -L$TARGET_DIR/include"
CPPFLAGS="-I$TARGET_DIR/include -I$TARGET_DIR/include/ncurses" LDFLAGS="-static -L$TARGET_DIR/include -L$TARGET_DIR/include/ncurses -L$TARGET_DIR/lib" make
cp tmux $TARGET_DIR/bin
cd ..

# cleanup
#rm -rf $BUILD_DIR

echo ""
echo "$TARGET_DIR/bin/tmux is now available. You can optionally add $TARGET_DIR/bin to your PATH."
echo "The working directory $BUILD_DIR is now finished and can be deleted."
