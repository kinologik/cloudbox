CBURL='https://raw.githubusercontent.com/kinologik/cloudbox/master'
# PRESEED=${HOME}'/preseed.cfg'
BCKUP=${HOME}'/.backup'

backup() {
	BCKDIR=$(dirname ${1})
	BCKFILE=$(basename ${1})
	mkdir -p ${BCKUP}${BCKDIR}
    	mv ${1} ${BCKUP}${1}
}
