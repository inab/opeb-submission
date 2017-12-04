#!/bin/bash

BASEDIR="$(dirname "$0")"
case "$BASEDIR" in
	/*)
		true
		;;
	*)
		BASEDIR="${PWD}/${BASEDIR}"
		;;
esac
source "${BASEDIR}"/submitterSetup.ini

if [ $# -ge 1 ] ; then
	submitGid="$(getent group "$SUBM_GROUP" | cut -f 3 -d ':')"
	declare -a submitUsers=( $(getent passwd | awk -F: "(\$4 == $submitGid) { print \$1 }") )
	for user in "${submitUsers[@]}" ; do
		jobsdir="${BASE_SUBM_DATA}"/"${user}"/"${SUBMISSIONS_SUBDIR}"
		(cd "${jobsdir}" && mkdir -p "$@" && chown "${user}:" "$@")
	done
else
	echo "Usage: $0 {jobId+}"
fi
