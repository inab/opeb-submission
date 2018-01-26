#!/usr/bin/env bats

TMP_DIR=$(mktemp -d)

@test "Check sftp login system with the 'first' user" {

sshpass -p first sftp -P 8222 -F /dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o BatchMode=no -b - first@localhost << EOF
	pwd
	ls
	exit
EOF

[ $? ]
}

@test "Check sftp 'one' folder permissions on the system with the 'first' user" {

sshpass -p first sftp -P 8222 -F /dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o BatchMode=no -b - first@localhost << EOF > "$TMP_DIR/permissions_test.txt"
	ls -l submissions
EOF

permissions="$(tail -n+2 $TMP_DIR/permissions_test.txt | cut -d' ' -f1)"

[ "$permissions" = "drwxr-xr-x" ]
}

@test "'first' user upload 'sftp_upload_test_digest.txt' file in submissions/one" {

echo 'SFTP upload test' > "$TMP_DIR/sftp_upload_test.txt"
sed -i "1i $(md5sum $TMP_DIR/sftp_upload_test.txt | cut -d' ' -f1)" "$TMP_DIR/sftp_upload_test.txt"

sshpass -p first sftp -P 8222 -F /dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o BatchMode=no -b - first@localhost << EOF
	cd submissions/one
	put $TMP_DIR/sftp_upload_test.txt
	exit
EOF

[ $? ]
}

