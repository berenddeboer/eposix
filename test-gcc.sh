#!/bin/sh

# cygwin posix test
rm *.o *.obj *.h *.c *.id *.a
echo gcc>$SEDIR/sys/compiler.se
SEDIR=//m/elj-win32/SmallEiffel

# make library
rm lib/libeposix.a
rm loadpath.se
make clean
make
if [ $? -gt 0 ]; then exit 1; fi
make loadpath.se
if [ $? -gt 0 ]; then exit 1; fi

# compile
compile -cecil src/supportc/cecil.se -no_split -no_style_warning -no_gc test_all make  -Llib -leposix-SE -o test_all.exe
if [ $? -gt 0 ]; then exit 1; fi
./test_all.exe
if [ $? -gt 0 ]; then exit 1; fi

compile -no_split -no_style_warning -no_gc test_epx_all make  -Llib -leposix-SE -o test_epx_all.exe
if [ $? -gt 0 ]; then exit 1; fi
./test_epx_all.exe
if [ $? -gt 0 ]; then exit 1; fi

compile -cecil src/supportc/cecil.se -no_split -no_style_warning -no_gc test_p_all make  -Llib -leposix-SE -o test_p_all.exe
if [ $? -gt 0 ]; then exit 1; fi
./test_p_all.exe -o test_p_all.exe
if [ $? -gt 0 ]; then exit 1; fi
