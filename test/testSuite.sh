#!/bin/bash

export KILL_ON_FAILURE=false
export UNIT_TEST_BEHAVIOUR=true

dir=$(dirname "$0")
. "$dir/../lib/Assertions.sh"
. "$dir/testSimple.sh"
. "$dir/testMath.sh"
. "$dir/testJava.sh"

Assertions summary
