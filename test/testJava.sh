#!/bin/bash

here=$(pwd)

dir=$(dirname "$0")
. "$dir/../lib/Math.sh"
# . "$dir/../lib/Assertions.sh" # DON'T, if this should run inside a suite! 
# If you do that, there will be another instance of Assertions which will break the summary

# Compile java and store the path
cd $dir/../java
there=$(pwd)
javac Abs.java

# just go back where you came from (not needed, but one never knows)
cd $here

# TODO: move this somewhere else
function callExternal() {
	local result exitVal
	result=$($@ 2>&1)
	exitVal=$?
	if [ $exitVal != 0 ]; then
		echo "ERROR from external: $result" >&2
		echo "ERROR from external: $result" # twice? Hm...
		return $exitVal
	else
		echo $result	
	fi
}

function callJava() {
	echo $(callExternal java -cp $there Abs $@)
}

minSignedInt32=$(echo -2^31 | bc -l) # -2147483648 = min int in Java
maxSignedInt32=$(echo "2^31 - 1" | bc -l) # 2147483647 = max int in Java

function testJavaMathAbs() {
	Assertions assertEquals $minSignedInt32 $(callJava minInteger) "Min value of 32 bit signed integer" # should pass 
	Assertions assertEquals $maxSignedInt32 $(callJava maxInteger) "Max value of 32 bit signed integer" # should pass
	Assertions assertEquals $(Math abs $minSignedInt32) $(callJava absOfMinInteger) "Math abs should work in Java like in our lib :P" # :O
}

function testJavaException() {
	# Something seems wrong here... - too many arguments
	Assertions assertEquals $minSignedInt32 "$(callJava minInteger 12)" "Java should throw exception" # should fail 
}

Assertions testUnit testJavaMathAbs "Math abs in Java should work."
Assertions testUnit testJavaException "Java exception"
