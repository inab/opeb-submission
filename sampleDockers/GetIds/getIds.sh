#!/bin/sh

if [ $# = 2 ] ; then
	input="$1"
	output="$2"
	cat<<EOF > "$output"
[
	"$(basename "$input")"
]
EOF
	exit $?
else
	echo "Usage: $0 {input} {output}" 1>&2
	exit 1
fi
