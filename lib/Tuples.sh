#!/bin/bash

# Hm. Only one tuple so far. Enough for now.
function Tuple() {
	echo "$@"
}

# TupleValue. Note: using this is a bit expensive, though someway cleaner.
# Consider having something like this:
#	for token in $tuple; do
#		if [ $c -eq 0 ]; then
#			x=$token
#		elif [ $c -eq 1 ]; then
#			y=$token
#		elif [ $c -eq 2 ]; then
#			z=$token
#		fi
#		c=$((c+1))
#	done
#   ... now do something with x, y, z
function tValAt() {
	local pos=$1; shift
	echo $@ | awk '{print $'$pos'}'
}

# export -f tv

