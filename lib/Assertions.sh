#!/bin/bash

export TOP_PID=$$
trap "exit 1" TERM

NC='\033[0m'
GREEN='\033[1;32m'
NORMAL=$(tput sgr0)
RED='\033[1;31m'
BOLD=$(tput bold)

# only works using no subshells. So no "$(func args)", please.
testsPassed=0
testsFailed=0

function Assertions() {

	# not exit... - subshells would work as well.
	function doKill() {
		printf "${BOLD}${RED}" >&2
		echo "!!! Killing on failure '$1'!!!" >&2
		echo "!!! To change this behaviour, just unset KILL_ON_FAILURE!!!" >&2
		kill -s TERM $TOP_PID
	}
	
	function failed() {
		testsFailed=$(($testsFailed + 1))
		printf "${BOLD}${RED}" >&2
		echo "Failed: '$1'" >&2
		if [[ $KILL_ON_FAILURE == true ]] ; then
			doKill "$1"
		fi
	}
	
	function passed() {
		testsPassed=$(($testsPassed + 1))
		printf "${NORMAL}${GREEN}" >&2
		echo "Passed: '$1'" >&2
	}
	
	function summary() {
		printf "${NORMAL}${NC}" >&1
		echo "############################"
		echo "Tests passed: $testsPassed"
		echo "Tests failed: $testsFailed"
	}
	
	function assertTrue() {
		x=$1
		# true or 1
		if [ $1 == 1 ] ; then
			x=true
		elif [ $1 == 0 ] ; then
			x=false
		fi
		if $x ; then 
			passed "$2"
		else 
			failed "$2. Expected true, but was false"
		fi;
	}
	
	function assertEquals() {
		if [ $1 == $2 ] ; then
			passed "$3"
		else
			failed "$3. Expected $1, but was $2"
		fi
	}
	
	# firstNum, secondNum, tolerance(optional. Consider floating points), message
	function assertNumberEquals() {
		rgx='^[0-9.]+$'
		tolerance=0
		message=$3
		if [[ $4 || $3 =~ $rgx ]] ; then 
			tolerance=$3
			message=$4
		fi
		res=$(echo "$2-($1)<$tolerance && $1-($2)<$tolerance" | bc -l)
		if [[ $res == 1 ]] ; then
			passed "$message"
		else
			failed "$message. Diff between expected $1 and actual $2 is greater than $tolerance."
		fi
	}
	
	# Do all tests inside a function. Args: the function, a message.
	function doTests() {
		printf "${NORMAL}${NC}" >&1
		echo ">>> Doing tests '$2' >>>"
		local currPassed currFailed
		local yetFailed=$testsFailed
		local yetPassed=$testsPassed
		$1
		printf "${NORMAL}${NC}" >&1
		currPassed=$(($testsPassed - $yetPassed))
		currFailed=$(($testsFailed - $yetFailed))
		echo "<<< Passed: $currPassed, Failed: $currFailed <<<"
		echo
	}
	
	op=$1; shift
	
	case $op in
		"assertTrue")
			assertTrue "$@"
		;;
		"assertEquals")
			assertEquals "$@"
		;;
		"assertNumberEquals")
			assertNumberEquals "$@"
		;;
		"doTests")
			doTests "$@"
		;;
		"summary")
			summary
		;;
	esac
	
}

export -f Assertions
