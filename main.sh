#!/bin/bash

. ./lib/Tuples.sh
. ./lib/Math.sh
	
echo $(Math sum 11.2 1.3 900.1)

echo $(Math avg 1.1 2.2 3.3)

echo $(Math fact 32)

time echo $(Math fib 1000)

coords1=$(Tuple 50.111511 8.680506) # Frankfurt
coords2=$(Tuple 49.45052 11.08048) # Nuremberg

time echo $(Math geoDist $coords1 $coords2)

echo $(Math atan2 -12 0)
