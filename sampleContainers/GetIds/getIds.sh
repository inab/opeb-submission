#!/bin/sh

if [ $# = 2 ] ; then
	input="$1"
	output="$2"
	cat<<EOF > "$output"
[
	"$(gunzip -c "$input" | sha256sum -b - | cut -f 1 -d ' ')"
]
EOF
	exit $?
else
	echo "Usage: $0 {input} {output}" 1>&2
	exit 1
fi
