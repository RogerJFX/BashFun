#!/bin/bash

# don't break big numbers
export BC_LINE_LENGTH=0

function Math() {
	
	function output() {
		echo $1 | bc -l
	}
	
	function sum() {
		local term=$1; shift
		for var in "$@" ; do
			term="$term+$var"
		done
		echo $(output $term)
	}
	
	function average() {
		echo $(output "$(sum $@)/$#")
	}
	
	function factorial() {
		local term="1"
		for ((i = 2; i <= $1; i++)) ; do
			term="$term*$i"
		done
		echo $(output $term)
	}
	
	# a bit slow then... - but fun
	function fibonacciRec() {
		local num=$1
		if [[ $num = 1 || $num = 2 ]] ; then
			echo 1
		else 
			a=$(($num-1))
			b=$(($num-2))
			echo $(output "$(fibonacciRec $a) + $(fibonacciRec $b)")
		fi
	}
	
	# faster :O
	function fibonacci() {
		local low=0
		local high=1
		for ((i = $1; i > 1; i--)) ; do
			high=$(output "$high+$low")
			low=$(output "$high-$low")
		done
		echo $(output $high)
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
		"fibFun")
			fibonacciRec $1
		;;
		*)
			notImplemented
		;;
	esac	
}

export -f Math
