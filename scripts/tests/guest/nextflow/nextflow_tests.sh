#!/usr/bin/env bats

BASEDIR="$(dirname "$0")"
case "$BASEDIR" in
	/*)
		true
		;;
	*)
		BASEDIR="${PWD}/${BASEDIR}"
		;;
esac

@test "Nextflow was installed correctly" {

command -v nextflow

[ $? ]
}

@test "Nextflow runs correctly" {

nextflow run hello

[ $? ]
}
