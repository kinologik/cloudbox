#!/bin/bash

mkdir ${HOME}/.scripts
wget -P ${HOME}/.scripts https://raw.githubusercontent.com/kinologik/cloudbox/master/root/.scripts/lib.sh
source ${HOME}/.scripts/lib.sh

backup /etc/locale.gen
wget -P /etc ${CBURL}/etc/locale.gen
locale-gen
apt-get -y install curl
ln -s /etc/environment ${HOME}/.ssh/environment

TTYLOGIN='/etc/systemd/system/getty@tty1.service.d/autologin.conf'
curl --create-dirs -o ${TTYLOGIN} ${CBURL}$(echo ${TTYLOGIN} | sed 's|@|-|g')
if [ $? != 0 ]; then echo "systemd autologin download failed..."; exit; fi

backup ${HOME}/.bashrc
curl -o ${HOME}/.bashrc ${CBURL}/root/.bashrc.01
if [ $? != 0 ]; then echo ".bashrc download failed..."; exit; fi
rm ${HOME}/start.sh
	
	cat /dev/null > /var/log/syslog
	
reboot
