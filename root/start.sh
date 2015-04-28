#!/bin/bash

## STARTING CLOUDBOX CLEAN INSTALLATION ##

## Import bash library ##
	mkdir ${HOME}/.scripts
	wget -P ${HOME}/.scripts https://raw.githubusercontent.com/kinologik/cloudbox/master/root/.scripts/lib.sh
	source ${HOME}/.scripts/lib.sh

## Re-generate locale [en_US.UTF-8 UTF-8] (prevent apt-get warnings)
	backup /etc/locale.gen
	wget -P /etc ${CBURL}/etc/locale.gen
	locale-gen
	
## Install curl && set environment variables
	apt-get -y install curl
	ln -s /etc/environment ${HOME}/.ssh/environment

## Set autologin for TTY1
	TTYLOGIN='/etc/systemd/system/getty@tty1.service.d/autologin.conf'
	curl --create-dirs -o ${TTYLOGIN} ${CBURL}$(echo ${TTYLOGIN} | sed 's|@|-|g')
	if [ $? != 0 ]; then echo "systemd autologin download failed..."; exit; fi

## Set new .bashrc script to continue installation after reboot && delete this script
	backup ${HOME}/.bashrc
	curl -o ${HOME}/.bashrc ${CBURL}/root/.bashrc.01
	if [ $? != 0 ]; then echo ".bashrc download failed..."; exit; fi
	rm ${HOME}/start.sh
	
## REBOOT
	cat /dev/null > /var/log/syslog
	reboot
