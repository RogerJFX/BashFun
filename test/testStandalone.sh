#!/bin/bash

export KILL_ON_FAILURE=true

. ./Assertions.sh
. ../Math.sh

Assertions assertEquals 1 1 "one should equal one"

Assertions assertTrue $[ 1 == 12 ] "'one equals twelve' should be true"

function testFib() {
	Assertions assertEquals 15 $(Math fib 8) "Fibonacci should (not) lie"
	Assertions assertEquals 55 $(Math fib 10) "Fibonacci should not lie"
}

testFib


Assertions summary
