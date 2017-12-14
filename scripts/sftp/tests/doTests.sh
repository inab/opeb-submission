#!/usr/bin/env bash

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

pushd "$BASEDIR" > /dev/null
echo "Running submitter tests..."
./submitter_tests.sh
popd > /dev/null
