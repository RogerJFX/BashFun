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

function testAbs() {
	Assertions assertEquals 21.001 $(Math abs -21.001) "Math abs of -21.001"
	Assertions assertEquals 21.001 $(Math abs 21.001) "Math abs of 21.001"
}

function doAtan2Bulk() {
	for tuple in "${atan2Arr[@]}" ; do
		$1
	done
}

function testAtan2() {
	local expected x y
	local tolerance=0.00000000001
	function doTest() {
		x=$(tValAt 1 $tuple)
		y=$(tValAt 2 $tuple)
		expected=$(tValAt 3 $tuple)
		Assertions assertNumberEquals $expected $(Math atan2 $x $y) $tolerance "atan2 for $x, $y"
	}
	doAtan2Bulk doTest
}

function testAtan2Slow() {
	local expected x y
	local tolerance=0.00000000001
	function doTest() {
		x=$(tSubset 1 $tuple)
		y=$(tSubset 2 $tuple)
		expected=$(tSubset 3 $tuple)
		Assertions assertNumberEquals $expected $(Math atan2 $x $y) $tolerance "atan2 for $x, $y"
	}
	doAtan2Bulk doTest
}

function testAtan2Array() {
	local arr
	local tolerance=0.00000000001
	function doTest() {
		toArray arr $tuple
		Assertions assertNumberEquals ${arr[2]} $(Math atan2 ${arr[0]} ${arr[1]}) $tolerance "atan2 for ${arr[0]}, ${arr[1]}"
	}
	doAtan2Bulk doTest
}

function testAtan2Subset() {
	local indices="3,1"
	local reOrdered
	function doTest() {
		reOrdered=$(tSubset $indices $tuple)
		Assertions assertEquals $(tValAt 3 $tuple) $(tValAt 1 $reOrdered) "reodering tuple, val 3 -> 1"
		Assertions assertEquals $(tValAt 1 $tuple) $(tValAt 2 $reOrdered) "reodering tuple, val 1 -> 2"
	}
	doAtan2Bulk doTest
}

Assertions doTests testFib "Test fibonacci"
Assertions doTests testAbs "Test Math abs"
time Assertions doTests testAtan2 "Test atan2"
time Assertions doTests testAtan2Slow "Test atan2, slower way"
time Assertions doTests testAtan2Array "Test atan2, array way"
time Assertions doTests testAtan2Subset "Test mapping Tuples to others."


