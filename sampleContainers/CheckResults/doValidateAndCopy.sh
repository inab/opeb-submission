#!/bin/sh

if [ $# = 2 ] ; then
	input="$1"
	output="$2"
	if [ -f "$input" -a -r "$input" ] ; then
		case "$(file -L "$input")" in
			*\ gzip\ compressed*)
				# As gzip is the canonical format for this
				# example, we only have to copy it
				if gunzip -t "$input" ; then
					exec cp "$input" "$output"
				else
					echo "ERROR: Corrupted results (gzip) file!" 1>&2
					exit 3
				fi
				;;
			*\ bzip2\ compressed*)
				# As gzip is the canonical format for this
				# example, we have to translate the bzip2
				# compressed file into a gzip one
				if bunzip2 -t "$input" ; then
					bunzip2 -c "$input" | gzip -9c > "$output"
					exit $?
				else
					echo "ERROR: Corrupted results (bzip2) file!" 1>&2
					exit 3
				fi
				;;
			*)
				echo "ERROR: Unrecognized format!" 1>&2
				exit 2
				;;
		esac
	else
		echo "ERROR: results file is unreadable!" 1>&2
		exit 1
	fi
else
	echo "Usage: $0 {input} {output}" 1>&2
	exit 1
fi
