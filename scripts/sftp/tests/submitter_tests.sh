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
source ../management/submitterSetup.ini

newuser='first'
submission='one'

@test "Create submitter 'first'" {

../management/createSubmitter.sh "$newuser"

found_user="$(getent passwd "$newuser" | cut -d':' -f1 )"
[ "$found_user" = "$newuser" ]
}

@test "Create submission '$submission' for all users" {

../management/createSubmission.sh "$submission"

submission_folder_path="${BASE_SUBM_DATA}/${newuser}/${SUBMISSIONS_SUBDIR}/${submission}"
submission_folder_name="$(basename "$submission_folder_path")"
submission_folder_group="$(stat --printf %G "$submission_folder_path")"
submission_folder_owner=$(stat --printf %U "$submission_folder_path")

[[ "$submission_folder_name" = "$submission" && \
	"$submission_folder_owner" = "$newuser" && \
	"$submission_folder_group" = "$SUBM_GROUP"  ]]
}
