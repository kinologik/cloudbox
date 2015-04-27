#!/bin/bash

{
CBURL='https://raw.githubusercontent.com/kinologik/cloudbox/master'
ln -s /etc/environment ${HOME}/.ssh/environment

SYSTEMD=$(pidof systemd)

if [[ -z ${SYSTEMD} ]]; then
	cp /etc/inittab /etc/inittab.backup
	curl -o /etc/inittab ${CBURL}/etc/inittab
	if [ $? != 0 ]; then echo "inittab download failed..."; exit; fi
fi
TTYLOGIN='/etc/systemd/system/getty@tty1.service.d/autologin.conf'
curl --create-dirs -o ${TTYLOGIN} ${CBURL}$(echo ${TTYLOGIN} | sed 's|@|-|g')
if [ $? != 0 ]; then echo "systemd autologin download failed..."; exit; fi

curl -o ${HOME}/.bashrc ${CBURL}/root/.bashrc.01
if [ $? != 0 ]; then echo ".bashrc download failed..."; exit; fi
rm ${HOME}/start.sh
reboot

exit
}
