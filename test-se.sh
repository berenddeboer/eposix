#!/bin/sh

# Remove every trace.
rm -f *.c *.h
rm -Rf *.obj

# Compiles all tests.
cp src/windows/loadpath.se loadpath.se
echo \$\{EPOSIX\}\\test_suite\\>> loadpath.se

echo Compiling test_all...
compile -cecil src\\supportc\\cecil.se -no_style_warning test_all make lib\\libeposix.lib
if [ $? -gt 0 ]; then exit 1; fi
if [ ! -x ./test_all.exe ]; then exit 1; fi
./test_all.exe
if [ $? -gt 0 ]; then exit 1; fi

echo Compiling test_epx_all...
compile -no_style_warning test_epx_all make lib\\libeposix.lib
if [ $? -gt 0 ]; then exit 1; fi
if [ ! -x ./test_epx_all.exe ]; then exit 1; fi
./test_epx_all.exe
if [ $? -gt 0 ]; then exit 1; fi

rm loadpath.se