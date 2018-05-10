#!/usr/bin/env bats

@test "Check tusd service is running" {
    [ "$(curl -s localhost:1080 | head -n1)" = "Welcome to tusd" ]
[ $? ]
}

@test "Upload a test file to tusd service" {
   chmod +x tus_uploader.py
   ./tus_uploader.py
   uploaded_filename=$(cat $(ls /data/*.info | head -n1) | jq -r '[.MetaData.filename][]')
   echo $uploaded_filename
[  "$uploaded_filename" = "test.txt" ]
}

