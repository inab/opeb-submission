#!/usr/bin/env bats

TMP_DIR=$(mktemp -d)

@test "Check if the 'first' user uploaded the 'sftp_upload_test.txt' file in submissions/one" {

uploaded_file='/data/submitters/first/submissions/one/sftp_upload_test.txt'

md5_digest_remote=$(head -n1 $uploaded_file)
sed -i '1d' $uploaded_file

md5_digest_local="$(md5sum $uploaded_file | cut -d' ' -f1)"

[ "$md5_digest_local" = "$md5_digest_remote" ]
}
