#!/bin/bash

{
CBURL='https://raw.githubusercontent.com/kinologik/cloudbox/master'
BCKUP=${HOME}'/.backup'

backup() {
	BCKDIR=$(dirname ${1})
	BCKFILE=$(basename ${1})
	mkdir -p ${BCKUP}${BCKDIR}
    	mv ${1} ${BCKUP}${1}
}

apt-get -y install curl &> /dev/null
ln -s /etc/environment ${HOME}/.ssh/environment

TTYLOGIN='/etc/systemd/system/getty@tty1.service.d/autologin.conf'
curl --create-dirs -o ${TTYLOGIN} ${CBURL}$(echo ${TTYLOGIN} | sed 's|@|-|g')
if [ $? != 0 ]; then echo "systemd autologin download failed..."; exit; fi

backup ${HOME}/.bashrc
curl -o ${HOME}/.bashrc ${CBURL}/root/.bashrc.01
if [ $? != 0 ]; then echo ".bashrc download failed..."; exit; fi
rm ${HOME}/start.sh
reboot

exit
}
