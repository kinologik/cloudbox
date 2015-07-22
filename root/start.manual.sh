#!/bin/bash

## STARTING CLOUDBOX CLEAN INSTALLATION ##

## Import libraries ##
	echo 'Installing script libraries...' && sleep 1

	source ${HOME}/.scripts/path.sh
	
	wget -P ${HOME}/.scripts ${CBURL}/root/.scripts/lib.sh
	source ${HOME}/.scripts/lib.sh

## Install curl && sudo
	echo 'Installing sudo and curl...' && sleep 1
	
	apt-get -y install sudo
	apt-get -y install curl
	apt-get -y autoremove

## Set autologin for TTY1
	echo 'Setting autologin...' && sleep 1

	rm ${TTYLOGIN}
	cp /lib/systemd/system/getty@.service ${TTYLOGIN}
	sed -i 's|ExecStart=.*|ExecStart=-/sbin/agetty --autologin root --noclear %I 38400 linux|g' ${TTYLOGIN}

## Load next installation script && delete this script
	echo 'Downloading script files ...' && sleep 1

	mkdir ${HOME}/.install
	curl -o ${HOME}/.install/01.init.sh ${CBURL}/root/.install/01.init.sh
		if [ $? != 0 ]; then echo "01.init.sh download failed..."; exit; fi
	curl -o ${HOME}/.install/02.desktop.sh ${CBURL}/root/.install/02.desktop.sh
		if [ $? != 0 ]; then echo "02.desktop.sh download failed..."; exit; fi
	
		backup ${HOME}/.bashrc
	mv -f ${HOME}/.install/01.init.sh ${HOME}/.bashrc
	
	rm ${HOME}/start.manual.sh

## Clear syslog && prompt for reboot
	cat /dev/null > /var/log/syslog
	
	echo 'Please reboot to continue ...'
