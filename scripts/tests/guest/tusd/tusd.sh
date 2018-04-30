#!/usr/bin/env bats

@test "Check tusd service is running" {
    [ "$(curl -s localhost:1080 | head -n1)" = "Welcome to tusd" ]
[ $? ]
}

