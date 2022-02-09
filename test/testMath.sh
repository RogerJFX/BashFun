#!/bin/bash

# Only works inside a suite.

. ../lib/Math.sh
. ../lib/Tuples.sh

declare -a atan2Arr=(
                "$(Tuple 1 2 0.4636476090008061)"
                "$(Tuple 100000 -22 1.5710163267913473)"
                "$(Tuple -1 2 -0.4636476090008061)"
                "$(Tuple -10 2 -1.373400766945016)"
                "$(Tuple -10 -222 -3.096578037815266)"
                "$(Tuple -10 -2222222 -3.141588153589343)"
                "$(Tuple -10 -22 -2.714965160462917)"
                "$(Tuple 1 -2 2.677945044588987)"
                "$(Tuple 0 0 0)"
                )
                
function testFib() {
	Assertions assertEquals 21 $(Math fib 8) "Fibonacci should not lie for 8"
	Assertions assertEquals 55 $(Math fib 10) "Fibonacci should not lie for 10"
}

function testAtan2() {
	local expected x y c
	local tolerance=0.00000000001
	for i in "${atan2Arr[@]}" ; do
		c=0
		for token in $i; do
			if [ $c -eq 0 ]; then
				x=$token
			elif [ $c -eq 1 ]; then
				y=$token
			elif [ $c -eq 2 ]; then
				expected=$token
			fi
			c=$((c+1))
		done
		Assertions assertNumberEquals $expected $(Math atan2 $x $y) $tolerance "atan2 for $x, $y"
	done
}

Assertions doTests testFib "Test fibonacci"
Assertions doTests testAtan2 "Test atan2"
