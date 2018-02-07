#!/bin/sh

if [ $# = 3 ] ; then
	inputDir="$1"
	# This parameter is not being used in this example
	reference="$2"
	output="$3"
	wordcountFile="$(grep -lF  wordcount "$inputDir"/*json)"
	wordstatsFile="$(grep -lF  worddist "$inputDir"/*json)"
	numwords="$(jq '.metrics[] | select(.type=="wordcount") | .value' "$wordcountFile")"
	jq --arg numwords "$numwords" '.id as $id | .metrics[] | select(.type=="worddist") | .value | map_values(. / ( $numwords | tonumber) )  as $value | { id: $id, metrics: [ { type: "wordfreq", units: "freq", value: $value } ] }' "$wordstatsFile" > "$output"
	exit $?
else
	echo "Usage: $0 {input} {reference} {output}" 1>&2
	exit 1
fi
