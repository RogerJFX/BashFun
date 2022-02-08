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
		echo "--------------------------"
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
		if [[ $1 == $2 ]] ; then
			passed "$3"
		else
			failed "$3. Expected $1, but was $2"
		fi
	}
	
	op=$1; shift
	
	case $op in
		"assertTrue")
			assertTrue "$@"
		;;
		"assertEquals")
			assertEquals "$@"
		;;
		"summary")
			summary
		;;
	esac
	
}

export -f Assertions
