#!/bin/bash

# don't break big numbers
export BC_LINE_LENGTH=0

function Math() {
	
	function calc() {
		echo $1 | bc -l
	}
	
	function sum() {
		local term=$1; shift
		for var in "$@" ; do
			term="$term+$var"
		done
		echo $(calc $term)
	}
	
	function average() {
		echo $(calc "$(sum $@)/$#")
	}
	
	function factorial() {
		local term="1"
		for ((i = 2; i <= $1; i++)) ; do
			term="$term*$i"
		done
		echo $(calc $term)
	}
	
	# a bit slow then... - but fun
	function fibonacciRec() {
		local num=$1
		if [[ $num = 1 || $num = 2 ]] ; then
			echo 1
		else 
			a=$(($num-1))
			b=$(($num-2))
			echo $(calc "$(fibonacciRec $a) + $(fibonacciRec $b)")
		fi
	}
	
	# faster :O
	function fibonacci() {
		local low=0
		local high=1
		for ((i = $1; i > 1; i--)) ; do
			high=$(calc "$high+$low")
			low=$(calc "$high-$low")
		done
		echo $(calc $high)
	}
	
	function geoDistance() {
		local pi180=0.01745329251994329576
		local R=6371
		local dLatTerm="($3-($1))*$pi180"
		local dLonTerm="($4-($2))*$pi180"
		local lat1Term="$1*$pi180"
		local lat2Term="$3*$pi180"
		local aTerm="s($dLatTerm/2)*s($dLatTerm/2)+c($lat1Term)*c($lat2Term)*s($dLonTerm/2)*s($dLonTerm/2)"
		local atan=$(atan2 "sqrt($aTerm)" "sqrt(1-$aTerm)")
		echo $(calc "$atan*$R*2")
	}
	
	function atan2() {
		local x=$1
		local y=$2
		{ read result; } < <(
			bc -l <<END
				result = 0 /* if $x == 0 AND $y == 0 */
				pi = (4*a(1/5) - a(1/239))*4
				if ($y == 0 && $x != 0) {
					result = pi / 2
				}
				if ($y != 0) {
					result = a($x/$y)
					if($y < 0) {
						result += pi
					}
				}
				if (result > pi) {
						result -= (2 * pi)
				}
				result 
END
)
		echo $result
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
		"geoDist")
			geoDistance $@
		;;
		"atan2")
			atan2 $1 $2
		;;
		*)
			notImplemented
		;;
	esac	
}

export -f Math
