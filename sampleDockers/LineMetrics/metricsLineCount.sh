#!/bin/sh

if [ $# = 3 ] ; then
	input="$1"
	# This parameter is not being used in this example
	reference="$2"
	output="$3"
	numlines=$(gunzip -c "$input" | wc -l)
	if [ $? = 0 ] ; then
		numwords=$(gunzip -c "$input" | wc -w)
		if [ $? = 0 ] ; then
			cat<<EOF > "$output"
{
	"id": "$(gunzip -c "$input" | sha256sum -b - | cut -f 1 -d ' ')",
	"metrics": [
		{
			"type": "linecount",
			"value": $numlines,
			"units": "lines"
		},
		{
			"type": "wordcount",
			"value": $numwords,
			"units": "words"
		}
	]
}
EOF
		else
			retval=$?
		fi
	else
		retval=$?
	fi

	if [ -n "$retval" ] ; then
		echo "ERROR: Counting lines metrics computation failed" 1>&2
		exit $retval
	else
		exit 0
	fi
else
	echo "Usage: $0 {input} {reference} {output}" 1>&2
	exit 1
fi
