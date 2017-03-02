#!/bin/bash

#TODO: Define install for pacman -S pkg
PKG_MANAGER=$( command -v yum || command -v apt-get ) || echo "Neither yum nor apt-get found" || exit 1
PKG_MANAGER="sudo $PKG_MANAGER install -y "

#TODO: Add distinguish between different package names between yum and apt-get
PACKAGES=(vim tmux git)
FAILED_PKGS=
for PKG in ${PACKAGES[*]}; do
	$PKG_MANAGER $PKG
	if [ $? != 0 ] ; then
		echo Installation $PKG failed.
		FAILED_PKGS="$FAILED_PKGS $PKG"
	fi
done
if [ "$FAILED_PKGS" != "" ]; then 
	echo FAILED PACKAGES: $FAILED_PKGS
fi


