#!/bin/bash

{
CBURL='https://raw.githubusercontent.com/kinologik/cloudbox/master'
PRESEED=${HOME}'/preseed.cfg'
BCKUP=${HOME}'/.backup'

backup() {
	BCKDIR=$(dirname ${1})
	BCKFILE=$(basename ${1})
	mkdir -p ${BCKUP}${BCKDIR}
    	mv ${1} ${BCKUP}${1}
}

# apt-get -y install debconf-utils &> /dev/null
# wget -P ${HOME} ${CBURL}/root/preseed.cfg
# debconf-set-selections --verbose < ${PRESEED}
# dpkg-reconfigure locales

backup /etc/locale.gen
wget -P /etc ${CBURL}/etc/locale.gen
locale-gen
# echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
apt-get -y install curl
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
