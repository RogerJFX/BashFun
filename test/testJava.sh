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

function callJava() {
	echo $(java -cp $there Abs $1)
}

minSignedInt32=$(echo -2^31 | bc -l) # -2147483648 = min int in Java
maxSignedInt32=$(echo "2^31 - 1" | bc -l) # 2147483647 = max int in Java

function testJavaMathAbs() {
	Assertions assertEquals $minSignedInt32 $(callJava minInteger) "Min value of 32 bit signed integer" # should pass
	Assertions assertEquals $maxSignedInt32 $(callJava maxInteger) "Max value of 32 bit signed integer" # should pass
	Assertions assertEquals $(Math abs $minSignedInt32) $(callJava absOfMinInteger) "Math abs should work in Java like in our lib :P" # :O
}

Assertions testUnit testJavaMathAbs "Math abs in Java should work."
