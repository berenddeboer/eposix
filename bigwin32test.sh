#!/bin/sh

# Compile eposix library against all supported compilers and
# compile all tests using SmallEiffel and these different compilers.

if [ "$SEDIR" = "" ]; then exit 1; fi

# lcc fails mostly on my system, have to send bug report
#./singlewin32test.sh lcc-win32 -lcc
#if [ $? -gt 0 ]; then exit 1; fi
#if [ ! -r lib/libeposix.lib ]; then exit 1; fi

./singlewin32test.sh bcb -bcb
if [ $? -gt 0 ]; then exit 1; fi
if [ ! -r lib/libeposix.lib ]; then exit 1; fi

./singlewin32test.sh cl -msc
if [ $? -gt 0 ]; then exit 1; fi
if [ ! -r lib/libeposix.lib ]; then exit 1; fi

./test-gcc.sh
if [ $? -gt 0 ]; then exit 1; fi
if [ ! -r lib/libeposix.lib ]; then exit 1; fi
