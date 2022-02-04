#!/bin/bash

function Math() {
	
	# floating points and big numbers.
	function output() {
		echo $1 | bc -l
	}
	
	function sum() {
		term=$1; shift
		for var in "$@" ; do
			term="$term+$var"
		done
		echo $(output $term)
	}
	
	function average() {
		echo $(output "$(sum $@)/$#")
	}
	
	function factorial() {
		term="1"
		for ((i = 2; i <= $1; i++)) ; do
			term="$term*$i"
		done
		echo $(output $term)
	}
	
	# a bit slow then...
	function fibonacci() {
		num=$1
		if [[ $num = 1 || $num = 2 ]] ; then
			echo 1
		else 
			a=$(($num-1))
			b=$(($num-2))
			echo $(output "$(fibonacci $a) + $(fibonacci $b)")
		fi
	}
	
	function notImplemented() {
		echo "Not implemented"
	}
	
	op=$1; shift
	
	case $op in
		"sum")
			sum $@
		;;
		"avg")
			average $@
		;;
		"fact")
			factorial $1
		;;
		"fib")
			fibonacci $1
		;;
		*)
			notImplemented
		;;
	esac	
}

export -f Math
