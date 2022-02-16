#!/bin/bash

# Mind you can change the test behavior by exporting some vars.
# For unit test behavior: export UNIT_TEST_BEHAVIOUR=true
# Kill complete test after first failure: export KILL_ON_FAILURE=true

export TOP_PID=$$
trap "exit 1" TERM

NC='\033[0m'
GREEN='\033[1;32m'
NORMAL=$(tput sgr0)
RED='\033[1;31m'
BOLD=$(tput bold)

# only works using no subshells. So no "$(func args)", please.
unitsPassed=0
unitsFailed=0
assertionFailed=false

function Assertions() {

	# not exit... (and "set -e") - subshells would work as well.
	function doKill() {
		printf "${BOLD}${RED}" >&2
		echo "!!! Killing on failure '$1'!!!" >&2
		echo "!!! To change this behaviour, just unset KILL_ON_FAILURE!!!" >&2
		kill -s TERM $TOP_PID
	}
	
	function failed() {
		assertionFailed=true
		printf "${BOLD}${RED}" >&2
		echo "Assertion failed: '$1'" >&2
		if [[ $KILL_ON_FAILURE == true ]] ; then
			doKill "$1"
		fi
	}
	
	function passed() {
		if [[ $UNIT_TEST_BEHAVIOUR != true ]] ; then
			printf "${NORMAL}${GREEN}" >&2
			echo "Assertion passed: '$1'" >&2 
		fi
	}
	
	function summary() {
		printf "${NORMAL}${NC}" >&1
		echo "############################"
		if [[ $UNIT_TEST_BEHAVIOUR != true && $unitsPassed == 0 && $unitsPassed == 0 ]] ; then
			echo "No unit test behaviour at all"
		else
			echo "Units passed: $unitsPassed"
			echo "Units failed: $unitsFailed"
		fi
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
	
	function checkUnit() {
		if [[ $UNIT_TEST_BEHAVIOUR == true && $assertionFailed == true ]] ; then
			return 0
		else 
			"$@"
		fi
	}
	
	# Do all tests inside a function (a unit). Args: the function, a message.
	function testUnit() {
		local result
		assertionFailed=false
		printf "${NORMAL}${NC}" >&1
		echo ">>> Doing tests $1 :: '$2' >>>"
		"$@"
		if [[ $assertionFailed == true ]] ; then
			unitsFailed=$(($unitsFailed + 1))
			result="FAILED"
			printf "${BOLD}${RED}"
		else 
			unitsPassed=$(($unitsPassed + 1))
			result="PASSED"
			printf "${NORMAL}${GREEN}"
		fi
		echo "<<< Unit $1 $result <<<"
		echo
	}
	
	op=$1; shift
	
	case $op in
		"assertTrue")
			checkUnit assertTrue "$@"
		;;
		"assertEquals")
			checkUnit assertEquals "$@"
		;;
		"assertNumberEquals")
			checkUnit assertNumberEquals "$@"
		;;
		"testUnit")
			testUnit "$@"
		;;
		"summary")
			summary
		;;
	esac
	
}

# export -f Assertions
