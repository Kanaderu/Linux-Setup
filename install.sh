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

# debian
# setup powerline fonts
mkdir ~/.temp; cd ~/.temp
wget -nc https://github.com/Kanaderu/source-code-pro/raw/master/source-code-pro-2.030R-ro-1.050R-it.tar.gz
tar xvf source-code-pro-2.030R-ro-1.050R-it.tar.gz
# local setup
#mkdir /usr/share/fonts/opentype/scp #global setup
mkdir -p ~/.fonts
cd ~/.fonts
mv source-code-pro-2.030R-ro-1.050R-it/*/ ~/.fonts
rm -r source-code-pro-2.030R-ro-1.050R-it/*/
sudo fc-cache -f -v # reset font cache

# yum
sudo yum install adobe-source-code-pro-fonts
