#!/bin/bash

{
ln -s /etc/environment ${HOME}/.ssh/environment

SYSTEMD=$(pidof systemd)
if [[ -z ${SYSTEMD} ]]; then
	cp /etc/inittab /etc/inittab.backup
	curl -o /etc/inittab ${CBURL}/etc/inittab
fi
TTYLOGIN='/etc/systemd/system/getty@tty1.service.d/autologin.conf'
curl --create-dirs -o ${TTYLOGIN} ${CBURL}$(echo ${TTYLOGIN} | sed 's|@|-|g')

curl -o ${HOME}/.bashrc ${CBURL}/root/.bashrc.01
reboot

exit
}
