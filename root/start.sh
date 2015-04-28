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

# curl -o /etc/default/locale ${CBURL}/etc/default/locale
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
apt-get -y install curl

# mkdir --parents ${BCKUP}'/'{home,etc,var/{www/html/{localhost,*},run}}
ln -s /etc/environment ${HOME}/.ssh/environment

SYSTEMD=$(pidof systemd)

########### IRRELEVANT SINCE JESSIE IS STABLE ####################
# if [[ -z ${SYSTEMD} ]]; then
		# mv /etc/inittab ${BCKUP}/etc/inittab
#	backup /etc/inittab
	# curl -o /etc/inittab ${CBURL}/etc/inittab
#	if [ $? != 0 ]; then echo "inittab download failed..."; exit; fi
#fi

TTYLOGIN='/etc/systemd/system/getty@tty1.service.d/autologin.conf'
curl --create-dirs -o ${TTYLOGIN} ${CBURL}$(echo ${TTYLOGIN} | sed 's|@|-|g')
if [ $? != 0 ]; then echo "systemd autologin download failed..."; exit; fi

backup ${HOME}/.bashrc
# curl -o ${HOME}/.bashrc ${CBURL}/root/.bashrc.01
if [ $? != 0 ]; then echo ".bashrc download failed..."; exit; fi
rm ${HOME}/start.sh
# reboot

exit
}
