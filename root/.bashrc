source ${HOME}/.scripts/lib.sh

if [ -z "$DISPLAY" ] && [ $(tty) == /dev/tty1 ]; then
	xinit &>/var/log/xinit.init.log > /var/log/xinit.log
fi
