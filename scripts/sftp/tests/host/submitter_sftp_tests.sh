#!/usr/bin/env bats
@test "Check sftp login system with the 'first' user" {
sshpass -p first sftp -P 8222 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o BatchMode=no -b - first@localhost << EOF
	pwd
	ls
	exit
EOF
[ $? ]
}

@test "Check sftp 'one' folder permissions on the system with the 'first' user" {
sshpass -p first sftp -P 8222 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o BatchMode=no -b - first@localhost << EOF > /tmp/test.txt
	ls -l submissions
EOF
permissions="$(tail -n+2 /tmp/test.txt | cut -d' ' -f1)"

[ "$permissions" = "drwxr-xr-x" ]
}

