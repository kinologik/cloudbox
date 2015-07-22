## X SERVER -- REMOTE DESKTOP -- OPENBOX -- BASIC APPLICATIONS ##

source ${HOME}/.scripts/lib.sh

function install_xserver
{
	apt-get -y --no-install-recommends install xbase-clients xserver-xorg
	apt-get -y install xserver-xorg-video-dummy
	apt-get -y install xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic
		backup /etc/X11/xorg.conf
	curl -o /etc/X11/xorg.conf ${CBURL}/etc/X11/xorg.conf
}

function install_openbox
{
	apt-get -y install libpam-gnome-keyring openbox menu obmenu x11vnc gtk2-engines gtk-chtheme hsetroot nitrogen
	curl -o ${HOME}/.bashrc ${CBURL}/root/.bashrc
		backup ${HOME}/.xinitrc
	curl -o ${HOME}/.xinitrc ${CBURL}/root/.xinitrc
	curl --create-dirs -o ${HOME}/.scripts/emptyTrash.sh ${CBURL}/root/.scripts/emptyTrash.sh
	chmod +x ${HOME}/.scripts/emptyTrash.sh
		backup ${HOME}/.config/openbox/autostart
	curl --create-dirs -o ${HOME}/.config/openbox/autostart ${CBURL}/root/.config/openbox/autostart
		backup ${HOME}/.config/openbox/menu.xml
	curl -o ${HOME}/.config/openbox/menu.xml ${CBURL}/root/.config/openbox/menu.xml
		backup ${HOME}/.config/openbox/rc.xml
	curl -o ${HOME}/.config/openbox/rc.xml ${CBURL}/root/.config/openbox/rc.xml
	sed -i 's|{{port}}|'${VNCPORT}'|g' ${HOME}/.config/openbox/autostart
	mkdir ${HOME}/.icons
}

if [ $(tty) == /dev/tty1 ]; then
	## Base Libraries ##
		apt-get -y install git software-properties-common build-essential automake libtool pkg-config flex bison
		apt-get -y install bcrypt libcurl4-openssl-dev apache2-utils libmagickwand-dev libmagickcore-dev

	## X SERVER ##
		install_xserver

	## REMOTE DESKTOP && OPENBOX ##
		install_openbox

	## Fonts, Icons, Themes && Wallpapers ##
		# Fonts
			# Oxygen
				curl https://dl.dropboxusercontent.com/s/ixzd0g4qy19wnya/font.oxygen.tar.gz | tar -zxvf - -C ${HOME}
		# Icons
			# Pacifica
				apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 87DD42B5
				curl -o /etc/apt/sources.list.d/pacifica.list ${CBURL}/etc/apt/sources.list.d/pacifica.list
				apt-get update
				apt-get -y install pacifica-icon-theme
				ln -s /usr/share/icons/Pacifica ${HOME}/.icons/Pacifica
				ln -s /usr/share/icons/Pacifica-U ${HOME}/.icons/Pacifica-U
			
			# Numix
				apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0F164EEB
				curl -o /etc/apt/sources.list.d/numix.list ${CBURL}/etc/apt/sources.list.d/numix.list
				apt-get update
				apt-get -y install numix-icon-theme numix-icon-theme-circle
				ln -s /usr/share/icons/Numix ${HOME}/.icons/Numix
				ln -s /usr/share/icons/Numix-Light ${HOME}/.icons/Numix-Light
				ln -s /usr/share/icons/Numix-Circle ${HOME}/.icons/Numix-Circle
				ln -s /usr/share/icons/Numix-Circle-Light ${HOME}/.icons/Numix-Circle-Light
			
			# Ardis
				## svg icons -- won't work with Wbar atm ##
				git clone https://github.com/KotusWorks/Ardis-icon-theme.git ${HOME}/.icons/Ardis-icon-theme
				
		# Themes
			# Numix
				apt-get -y install numix-gtk-theme
					backup ${HOME}/.gtkrc-2.0
				curl -o ${HOME}/.gtkrc-2.0 ${CBURL}/root/.gtkrc-2.0
					backup ${HOME}/.config/gtk-3.0/settings.ini
				curl --create-dirs -o ${HOME}/.config/gtk-3.0/settings.ini ${CBURL}/root/.config/gtk-3.0/settings.ini
				
		# Wallpapers
			# Custom
				curl https://dl.dropboxusercontent.com/s/ru883uwrnh98y7d/wallpapers.tar.gz | tar -zxvf - -C ${HOME}
					backup ${HOME}/.config/nitrogen/nitrogen.cfg
				curl --create-dirs -o ${HOME}/.config/nitrogen/nitrogen.cfg ${CBURL}/root/.config/nitrogen/nitrogen.cfg
					backup ${HOME}/.config/nitrogen/bg-saved.cfg
				curl -o ${HOME}/.config/nitrogen/bg-saved.cfg ${CBURL}/root/.config/nitrogen/bg-saved.cfg	

	## Compositor ##
		apt-get -y install compton
			backup ${HOME}/.config/compton.conf
		curl -o ${HOME}/.config/compton.conf ${CBURL}/root/.config/compton.conf

	## System Monitor ##
		apt-get -y install conky-std htop
		apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 2D0F61F0
		curl -o /etc/apt/sources.list.d/conky-manager.list ${CBURL}/etc/apt/sources.list.d/conky-manager.list
		apt-get update
		apt-get -y install conky-manager
			backup ${HOME}/.config/conky/.conkyrc
		curl --create-dirs -o ${HOME}/.config/conky/.conkyrc ${CBURL}/root/.config/conky/.conkyrc

	## Toolbar ##
		apt-get -y install tint2
			backup ${HOME}/.config/tint2/tint2rc
		curl --create-dirs -o ${HOME}/.config/tint2/tint2rc ${CBURL}/root/.config/tint2/tint2rc

	## Launcher ##
		apt-get -y -t experimental install plank
		DCK1=${HOME}'/.config/plank/dock1'
		DSRC=${CBURL}'/root/.config/plank/dock1'
		PTHM=${HOME}'/.local/share/plank/themes/cloudbox'
		PSRC=${CBURL}'/root/.local/share/plank/themes/cloudbox'
		rm -rf ${DCK1}/launchers && mkdir -p ${DCK1}/launchers
		curl -o ${DCK1}/settings ${DSRC}/settings
		
		curl -o ${DCK1}/launchers/filemanager.desktop ${DSRC}/launchers/filemanager.desktop
		curl -o ${DCK1}/launchers/filemanager.dockitem ${DSRC}/launchers/filemanager.dockitem
		curl -o ${DCK1}/launchers/terminal.desktop ${DSRC}/launchers/terminal.desktop
		curl -o ${DCK1}/launchers/terminal.dockitem ${DSRC}/launchers/terminal.dockitem
		curl -o ${DCK1}/launchers/editor.desktop ${DSRC}/launchers/editor.desktop
		curl -o ${DCK1}/launchers/editor.dockitem ${DSRC}/launchers/editor.dockitem
		curl -o ${DCK1}/launchers/plank.desktop ${DSRC}/launchers/plank.desktop
		curl -o ${DCK1}/launchers/plank.dockitem ${DSRC}/launchers/plank.dockitem
		sed -i 's|{{home}}|'${HOME}'|g' ${DCK1}/launchers/filemanager.desktop
		sed -i 's|{{home}}|'${HOME}'|g' ${DCK1}/launchers/filemanager.dockitem
		sed -i 's|{{home}}|'${HOME}'|g' ${DCK1}/launchers/terminal.desktop
		sed -i 's|{{home}}|'${HOME}'|g' ${DCK1}/launchers/terminal.dockitem
		sed -i 's|{{home}}|'${HOME}'|g' ${DCK1}/launchers/editor.desktop
		sed -i 's|{{home}}|'${HOME}'|g' ${DCK1}/launchers/editor.dockitem
		sed -i 's|{{home}}|'${HOME}'|g' ${DCK1}/launchers/plank.desktop
		sed -i 's|{{home}}|'${HOME}'|g' ${DCK1}/launchers/plank.dockitem
		
		curl --create-dirs -o ${PTHM}/dock.theme ${PSRC}/dock.theme
		curl -o ${PTHM}/hover.theme ${PSRC}/hover.theme

	## Terminal ##
		apt-get -y install terminator
			backup ${HOME}/.config/terminator/config
		curl --create-dirs -o ${HOME}/.config/terminator/config ${CBURL}/root/.config/terminator/config

	## File Manager ##
		mkdir --parents ${HOME}/.local/share
		mkdir ${HOME}/Templates
		apt-get -y install pcmanfm
			backup ${HOME}/.config/pcmanfm/default/pcmanfm.conf
		curl --create-dirs -o ${HOME}/.config/pcmanfm/default/pcmanfm.conf ${CBURL}/root/.config/pcmanfm/default/pcmanfm.conf
			backup ${HOME}/.config/libfm/libfm.conf
		curl --create-dirs -o ${HOME}/.config/libfm/libfm.conf ${CBURL}/root/.config/libfm/libfm.conf

	## Text Editor ##
		apt-get -y install geany
		curl --create-dirs -o ${HOME}/.config/geany/colorschemes/zenburn.conf ${CBURL}/root/.config/geany/colorschemes/zenburn.conf
			backup ${HOME}/.config/geany/geany.conf
		curl -o ${HOME}/.config/geany/geany.conf ${CBURL}/root/.config/geany/geany.conf

	## Load final script && REBOOT ##
		cat /dev/null > /var/log/syslog
		curl -o ${HOME}/.bashrc ${CBURL}/root/.bashrc
		# reboot
fi
