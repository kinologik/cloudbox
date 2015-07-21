INSTLOG=${HOME}/.log/install.log

## Create installation log file
init_log() {
	mkdir ${HOME}/.log
	touch ${HOME}/.log/install.log
	echo "CLOUDBOX INSTALLATION LOG" > ${INSTLOG}
	echo "~ created on $(timestamp) ~" >>  ${INSTLOG}
	echo -e "==================================================\n" >>  ${INSTLOG}
}
