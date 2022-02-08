#!/bin/bash

# Only works inside a suite.

. ./Math.sh

function testFib() {
	Assertions assertEquals 15 $(Math fib 8) "Fibonacci should (not) lie"
	Assertions assertEquals 55 $(Math fib 10) "Fibonacci should not lie"
}

testFib
