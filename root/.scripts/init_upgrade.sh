#!/bin/bash

##### Constants

TITLE="System Information for $HOSTNAME"
RIGHT_NOW=$(date +"%x %r %Z")
TIME_STAMP="Updated on $RIGHT_NOW by $USER"

NEWPW=""

##### Functions

function change_pw
{
	echo "root:$NEWPW" | chpasswd
}

function update_os
{
	wget -P /etc/apt -N https://raw.githubusercontent.com/kinologik/cloudbox/master/etc/apt/sources.list
	apt-get update
}

function upgrade_os
{
	wget -P /etc/apt -N https://raw.githubusercontent.com/kinologik/cloudbox/master/etc/apt/listchanges.conf
	apt-get -y install debconf-utils
	wget -P ~/ -N https://raw.githubusercontent.com/kinologik/cloudbox/master/root/preseed.cfg
	debconf-set-selections --verbose < ~/preseed.cfg
	rm ~/preseed.cfg
	apt-get -o Dpkg::Options::="--force-confnew" -y dist-upgrade
	apt-get -y autoremove
}

function virt_memory
{
	touch /swapfile
	chmod 600 /swapfile
	dd if=/dev/zero of=/swapfile bs=1024k count=2048
	mkswap /swapfile
	swapon /swapfile
	echo "/swapfile none swap sw 0 0" >> /etc/fstab
	sysctl -w vm.swappiness=30
}


function auto_login
{
	mkdir --parents /etc/systemd/system/getty@tty1.service.d
	wget -P /etc/systemd/system/getty@tty1.service.d -N https://raw.githubusercontent.com/kinologik/cloudbox/master/etc/systemd/system/getty-tty1.service.d/autologin.conf

}

function clear_history
{
	cat /dev/null > ~/.bash_history
	history -c
}

##### Main

while [ "$1" != "" ]; do
    case $1 in
        -pw | --password )	shift
                                NEWPW=$1
                                ;;
        * )                     echo "No argument - Exiting..."
                                exit $?
    esac
done

if [ -z "$NEWPW" ]
then
	echo "Argument without value - Exiting..."
else
	change_pw
	update_os
	upgrade_os
	virt_memory
	auto_login
	clear_history
fi
