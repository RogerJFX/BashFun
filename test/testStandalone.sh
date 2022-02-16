#!/bin/bash

export KILL_ON_FAILURE=false
# Not particular reasonable...
export UNIT_TEST_BEHAVIOUR=false

dir=$(dirname "$0")
. "$dir/../lib/Assertions.sh"
. "$dir/../lib/Math.sh"

Assertions assertEquals 1 1 "one should equal one"

Assertions assertTrue $[ 1 == 12 ] "'one equals twelve' should be true"

function testFib() {
	Assertions assertEquals 15 $(Math fib 8) "Fibonacci should (not) lie"
	Assertions assertEquals 55 $(Math fib 10) "Fibonacci should not lie"
}

testFib


Assertions summary
