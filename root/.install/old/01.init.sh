## OS UPDATE/UPGRADE, SWAPFILE, HOSTNAME + TIMEZONE + LOCALES SETTINGS && DELETE HISTORY ##

source ${HOME}/.scripts/lib.sh

function host_tz
{
		backup /etc/hostname
		copy /etc/hosts
		backup /etc/timezone
		backup /etc/localtime
		
	echo -e ${HNAME} > /etc/hostname
	sed -i 's|127.0.0.1 localhost|127.0.0.1 localhost '${HNAME}'|g' /etc/hosts

	echo ${TZONE} > /etc/timezone
	ln -s /usr/share/zoneinfo/${TZONE} /etc/localtime
	# dpkg-reconfigure -f noninteractive tzdata
		
	#	backup /etc/default/locale
	# curl -o /etc/default/locale ${CBURL}/etc/default/locale
	# dpkg-reconfigure -f noninteractive locales
}

function update_sources
{
		backup /etc/apt/sources.list
	curl -o /etc/apt/sources.list ${CBURL}/etc/apt/sources.${OSDIST}.list
	apt-get update
	if [ $? != 0 ]; then echo "update failed..."; exit; fi
	# curl -o /etc/apt/sources.list.d/experimental.list ${CBURL}/etc/apt/sources.list.d/experimental.list
	# apt-get update
}

function update_upgrade
{
		backup /etc/apt/listchanges.conf
	curl -o /etc/apt/listchanges.conf ${CBURL}/etc/apt/listchanges.conf
	apt-get -y dist-upgrade
	if [ $? != 0 ]; then echo "upgrade failed..."; exit; fi
	apt-get -y autoremove
}

function create_swapfile
{
	touch /swapfile
	chmod 600 /swapfile
	dd if=/dev/zero of=/swapfile bs=1M count=2048
	mkswap /swapfile
	swapon /swapfile
		copy /etc/fstab
	echo '/swapfile none swap sw 0 0' >> /etc/fstab
	sysctl -w vm.swappiness=30
}

function update_ssh
{
		backup /etc/ssh/sshd_config
	curl -o /etc/ssh/sshd_config ${CBURL}/etc/ssh/sshd_config
	sed -i 's|{{port}}|'${SSHPORT}'|g' /etc/ssh/sshd_config
}

if [ $(tty) == /dev/tty1 ]; then
	## Set hostname, timezone && locale ##
		host_tz
		
	## Update Debian source files ##
		update_sources

	## Unattended Debian update/upgrade ##
		update_upgrade

	## Configure swapfile ##
		create_swapfile

	## SSH port settings ##
		update_ssh

	## Delete bash history && load next installation script ##
		cat /dev/null > ${HOME}/.bash_history
		history -c
		mv -f ${HOME}/.install/02.desktop.sh ${HOME}/.bashrc
		# curl -o ${HOME}/.bashrc ${CBURL}/root/.bashrc.02

	## REBOOT ##
		cat /dev/null > /var/log/syslog
		# reboot
fi
