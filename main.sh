#!/bin/bash

passed=true

echo "Test report, date: $(date '+%Y-%m-%d %H:%M:%S')" > result.txt

function checkFailures() {
	while IFS= read -r line; do
		echo $line >> result.txt
		echo $line >&2
		if [[ $line == *"Assertion failed"* ]] ; then 
			passed=false
		fi
	done < <($1)
}

checkFailures ./test/testSuite.sh
checkFailures ./test/testStandalone.sh

echo
echo "---"

if $passed; then
	echo "Everything is right. Continue your excellent work"
	exit 0
else 
	echo "Something went wrong. Have a look at result.txt"
	exit 1
fi
