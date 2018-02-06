#!/usr/bin/env bats

source ../../../sftp/management/submitterSetup.ini

newuser='first'
submission='one'

@test "Create submitter 'first'" {

../../../sftp/management/createSubmitter.sh "$newuser"

found_user="$(getent passwd "$newuser" | cut -d':' -f1 )"
[ "$found_user" = "$newuser" ]
}

@test "Create submission '$submission' for all users" {

../../../sftp/management/createSubmission.sh "$submission"

submission_folder_path="${BASE_SUBM_DATA}/${newuser}/${SUBMISSIONS_SUBDIR}/${submission}"
submission_folder_name="$(basename "$submission_folder_path")"
submission_folder_permissions="$(stat --printf %a "$submission_folder_path")"
submission_folder_group="$(stat --printf %G "$submission_folder_path")"
submission_folder_owner="$(stat --printf %U "$submission_folder_path")"

[[ "$submission_folder_name" = "$submission" && \
	"$submission_folder_permissions" = "755" && \
	"$submission_folder_owner" = "$newuser" && \
	"$submission_folder_group" = "$SUBM_GROUP"  ]]
}

@test "Assign password to 'first' user for testing the sftp login" {

echo 'first:first' | chpasswd

[ $? ]
}
