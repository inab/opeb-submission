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
	# Assuring the submitters group does exist
	getent group "${SUBM_GROUP}" >& /dev/null || groupadd -K GID_MIN="${GIDMIN}" "${SUBM_GROUP}"

	for newuser in "$@" ; do
		# As each user is being chroot-ed , their "home" is root
		if ! getent passwd "${newuser}" >& /dev/null ; then
			useradd -K UID_MIN="${UIDMIN}" -N -M -g "${SUBM_GROUP}" -d / -s /bin/false "${newuser}"
		fi
		# The real root directory and submissions
		mkdir -p "${BASE_SUBM_DATA}"/"${newuser}"/"${SUBMISSIONS_SUBDIR}"
		# This is not for here
		#chown "${newuser}" "${BASE_SUBM_DATA}"/"${newuser}"/submissions
	done
else
	echo "Usage: $0 {username+}"
	exit 1
fi
