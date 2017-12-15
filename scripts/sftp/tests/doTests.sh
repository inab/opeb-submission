#!/bin/sh

BASEDIR="$(dirname "$0")"
case "$BASEDIR" in
	/*)
		true
		;;
	*)
		BASEDIR="${PWD}/${BASEDIR}"
		;;
esac


# Submitters
# All tests related to the submitters go here

cd "$BASEDIR"
echo "Running submitter tests..."
./guest/submitter_tests.sh
cd ..
