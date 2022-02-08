#!/bin/bash

# Only works inside a suite.

Assertions assertTrue $[ 1 == 2 ] "'one equals two' should be true"

Assertions assertEquals 1 2 "three should equal two"

Assertions assertEquals 1 1 "one should equal one"

Assertions assertTrue $[ 1 == 12 ] "'one equals twelve' should be true"
