#!/bin/bash

passed=true

now=$(date '+%Y-%m-%d %H:%M:%S')

# same date (not another call), mind the nanos. :D
now4File=$(echo $now | sed "s/:/-/g; s/ /_/g")

logFile="testResults_$now4File.log"

# declare all tests here
declare -a tests=(
	./test/testSuite.sh
	./test/testStandalone.sh
)

echo "Test report, date: $now" > $logFile

# Free line from bash formatting chars for writing to a file.
function trimLine() {
	echo "$1" | sed -E "s/^[\x1bBm0123\(\[;]*([<>#A-Z])/\1/g"
}

function checkFailures() {
	while IFS= read -r line; do
		echo $(trimLine "$line") >> $logFile
		echo $line >&2
		if [[ $line == *"Assertion failed"* ]] ; then 
			passed=false
		fi
	done < <($1 2>&1)
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
	echo "Something went wrong. Have a look at $logFile"
	exit 1
fi
