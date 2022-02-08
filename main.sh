#!/bin/bash

# Next to come: a testing framework. *lol* - for the bash. I think, I will do that stuff ...

. ./Math.sh

# Just some "object" to hold two values. Lazy echo.
function coords() {
	echo "$1 $2"
}
	
echo $(Math sum 11.2 1.3 900.1)

echo $(Math avg 1.1 2.2 3.3)

echo $(Math fact 32)

echo "This should take some time"
time echo $(Math fibFun 14)

echo "This as well"
time echo $(Math fib 1000)

coords1=$(coords 50.111511 8.680506) # Frankfurt
coords2=$(coords 49.45052 11.08048) # Nuremberg

time echo $(Math geoDist $coords1 $coords2)

echo $(Math atan2 -12 0)
