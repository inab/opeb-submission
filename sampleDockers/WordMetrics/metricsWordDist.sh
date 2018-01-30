#!/bin/bash

if [ $# = 3 ] ; then
	input="$1"
	# This parameter is not being used in this example
	reference="$2"
	output="$3"

	uniqtemp="$(mktemp -t uniqXXXXXX)"
	gunzip -c "$input" | strings | tr -s ' ,:.' '\n' | sort | uniq -c | sed 's#^[^0-9]*\([0-9]\+\) \+\(.\+\)$#\t\t\t\t"\2": \1,#g;$ s#,$##;' > "$uniqtemp"
	if [ $? = 0 ] ; then
		cat<<EOF > "$output"
{
	"id": "$(gunzip -c "$input" | sha256sum -b - | cut -f 1 -d ' ')",
	"metrics": [
		{
			"type": "worddist",
			"units": "worddist",
			"value": {
$(<"${uniqtemp}")
			}
		}
	]
}
EOF
	else
		retval=$?
	fi
	rm -f "$uniqtemp"

	if [ -n "$retval" ] ; then
		echo "ERROR: Word distribution metrics computation failed" 1>&2
		exit $retval
	else
		exit 0
	fi
else
	echo "Usage: $0 {input} {reference} {output}" 1>&2
	exit 1
fi
