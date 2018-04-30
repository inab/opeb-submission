#!/usr/bin/env bats

@test "Check mongodb service is running" {
    [ "$(curl -s localhost:27017)" = "It looks like you are trying to access MongoDB over HTTP on the native driver port." ]
[ $? ]
}

