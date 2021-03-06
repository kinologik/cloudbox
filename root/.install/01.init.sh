## OS UPDATE/UPGRADE, SWAPFILE, HOSTNAME + TIMEZONE + LOCALES SETTINGS && DELETE HISTORY ##

source ${HOME}/.scripts/lib.sh

function host_tz {
		backup /etc/hostname
		copy /etc/hosts
		backup /etc/timezone
		rm /etc/localtime
		
	echo -e ${HNAME} > /etc/hostname
	sed -i 's|127.0.0.1 localhost|127.0.0.1 localhost '${HNAME}'|g' /etc/hosts

	echo ${TZONE} > /etc/timezone
	ln -s /usr/share/zoneinfo/${TZONE} /etc/localtime
}

function update_sources {
		backup /etc/apt/sources.list
	curl -o /etc/apt/sources.list ${CBURL}/etc/apt/sources.${OSDIST}.list
	apt-get update
		if [ $? != 0 ]; then echo "update failed..."; exit; fi
}

function update_upgrade {
		backup /etc/apt/listchanges.conf
	curl -o /etc/apt/listchanges.conf ${CBURL}/etc/apt/listchanges.conf
	apt-get -y dist-upgrade
		if [ $? != 0 ]; then echo "upgrade failed..."; exit; fi
	apt-get -y autoremove
}

function create_swapfile {
	touch /swapfile
	chmod 600 /swapfile
	dd if=/dev/zero of=/swapfile bs=1M count=2048
	mkswap /swapfile
	swapon /swapfile
		copy /etc/fstab
	echo '/swapfile none swap sw 0 0' >> /etc/fstab
	sysctl -w vm.swappiness=30
}

function update_ssh {
		backup /etc/ssh/sshd_config
	curl -o /etc/ssh/sshd_config ${CBURL}/etc/ssh/sshd_config
	sed -i 's|{{port}}|'${SSHPORT}'|g' /etc/ssh/sshd_config
}

function self_ssl {
	mkdir --parents /etc/ssl/${DOMAIN}/certs && mkdir --parents /etc/ssl/${DOMAIN}/private
	SSLSUBJ='/C='${CERTC}'/ST='${CERTST}'/L='${CERTL}'/O='${CERTO}'/CN=*.'${DOMAIN}
	openssl req -x509 -sha256 -nodes -days 5480 -newkey rsa:4096 -out /etc/ssl/${DOMAIN}/certs/${DOMAIN}.pem -keyout /etc/ssl/${DOMAIN}/private/${DOMAIN}.key -utf8 -subj "${SSLSUBJ}"
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

	## Create self-signed certificate ##
		self_ssl
		
	## Clear history ##
		clear_history
	
	## Load next installation script ##
		mv -f ${HOME}/.install/02.desktop.sh ${HOME}/.bashrc

	## REBOOT ##
		echo 'Rebooting in 5 sec ...' && sleep 5
		reboot
fi
