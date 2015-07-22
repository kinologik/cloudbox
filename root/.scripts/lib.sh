source ${HOME}/.scripts/path.sh

timestamp() {
	date +"%Y-%m-%d %T"
}

backup() {
	BCKDIR=$(dirname ${1})
	BCKFILE=$(basename ${1})
	mkdir -p ${BCKUP}${BCKDIR}
    	mv ${1} ${BCKUP}${1}
}

copy() {
	BCKDIR=$(dirname ${1})
	BCKFILE=$(basename ${1})
	mkdir -p ${BCKUP}${BCKDIR}
    	cp ${1} ${BCKUP}${1}
}

clear_history() {
	cat /dev/null > ${HOME}/.bash_history
	history -c
	cat /dev/null > /var/log/syslog
}
