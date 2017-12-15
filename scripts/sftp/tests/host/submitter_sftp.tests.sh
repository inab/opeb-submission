#!/usr/bin/env bats
@test "Check sftp login system with the 'first' user" {
sshpass -p first sftp -P 8222 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o BatchMode=no -b - first@localhost << EOF
	pwd
	ls
	exit
EOF
[ $? ]
}

