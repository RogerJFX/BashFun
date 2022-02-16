#!/bin/bash

# Only works inside a suite.

dir=$(dirname "$0")
. "$dir/../lib/Math.sh"
. "$dir/../lib/Tuples.sh"

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

function testGeoDistance() {
	Assertions assertNumberEquals 187 $(Math geoDist $(Tuple 50.111511 8.680506) $(Tuple 49.45052 11.08048)) 1 "Distance F <-> N in km"
}
    
function testFib() {
	Assertions assertEquals 21 $(Math fib 8) "Fibonacci should not lie for 8"
	Assertions assertEquals 55 $(Math fib 10) "Fibonacci should not lie for 10"
}

function testAbs() {
	Assertions assertEquals 21.001 $(Math abs -21.001) "Math abs of -21.001"
	Assertions assertEquals 21.001 $(Math abs 21.001) "Math abs of 21.001"
}

function testCommonMathBC() {
	Assertions assertEquals 912.6 $(Math sum 11.2 1.3 900.1) "Math sum"
	Assertions assertNumberEquals 2.2 $(Math avg 1.1 2.2 3.3) 0.000000000000000001 "Math avg"
	Assertions assertEquals 263130836933693530167218012160000000 $(Math fact 32) "Math fact"
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
Assertions testUnit testCommonMathBC "Some common bc ops"
Assertions testUnit testGeoDistance "Test distance in km"
Assertions testUnit testFib "Test fibonacci"
Assertions testUnit testAbs "Test Math abs"
Assertions testUnit testAtan2 "Test atan2"
Assertions testUnit testAtan2Slow "Test atan2, slower way"
Assertions testUnit testAtan2Array "Test atan2, array way"
Assertions testUnit testAtan2Subset "Test mapping Tuples to others."


