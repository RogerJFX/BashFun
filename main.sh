#!/bin/bash

passed=true

logFile="testResults.log"

# declare all tests here
declare -a tests=(
	./test/testSuite.sh
	./test/testStandalone.sh
)

echo "Test report, date: $(date '+%Y-%m-%d %H:%M:%S')" > $logFile

function checkFailures() {
	while IFS= read -r line; do
		echo $line >> $logFile
		echo $line >&2
		if [[ $line == *"Assertion failed"* ]] ; then 
			passed=false
		fi
	done < <($1)
}

for test in "${tests[@]}"; do
	checkFailures $test
done

echo
echo "---"

if $passed; then
	echo "Everything is right. Continue your excellent work"
	exit 0
else 
	echo "Something went wrong. Have a look at result.txt"
	exit 1
fi
