#!/bin/bash

# This "Tuple" is a simple container for arguments. May be used for two dimensional arrays.
# Note: the echo is lazy (like me, by the way)
function Tuple() {
	echo "$@"
}

# Creates another sequence of a given tuple, that might be used to create another tuple.
# Usage:
# newTuple=$(tSubset "4,3,2" $myTuple)
# This would create a new Tuple with only 3 values of myTuple with passed indexes.
function tSubset() {
	local pos="$1"; shift
	printPos=$(echo $pos | sed "s/^/$/; s/,/,$/g")
	echo $@ | awk '{print '$printPos'}'
}

# TupleValue. Use it like $(tValAt 42 $myTuple), where 42 is the value's
# position in the tuple starting with index 1.
function tValAt() {
	local pos=$(($1-1)); shift
	local len=$#
	local c=0
	for token in $@; do
		if [ $c -eq $pos ]; then
			echo $token
			break
		fi
		c=$((c+1))
		if [ $c -eq $len ]; then
			return 1
		fi
	done
}

# Available since bash version 4.3 (nameref)
# Should be faster than tValAt in the end
# Pass some array name and the tuple, e.g.
# local myArr
# toArray myArr $myTuple
# echo ${myArr[0]}
function toArray() {
	local -n array="$1"; shift
	array=( "$@" )
}

# export -f tv

