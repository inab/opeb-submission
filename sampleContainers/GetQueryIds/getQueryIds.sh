#!/bin/sh

if [ $# = 3 ] ; then
	testEventId="$1"
	input="$2"
	output="$3"
	cat<<EOF > "$output"
{
	"testEventId": "$testEventId",
	"queryIds": [
		"$(sha256sum -b "$input" | cut -f 1 -d ' ')"
	]
}
EOF
	exit $?
else
	echo "Usage: $0 {testEventId} {input} {queryIdsFile}" 1>&2
	exit 1
fi
