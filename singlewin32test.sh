#!/bin/sh

# do a single step in the bigwin32test.sh
# Parameters:
# 1. se compiler
# 2. makelib compiler switch

if [ x$1 = x ] ; then echo Supply two parameters; exit 1; fi

# make sure we found the correct make.exe
case "$1" in
  lcc-win32)
        echo lcc-win32 test
        echo "Changing path to $SEDIR/lcc/bin";
        PATH=`cygpath -2 $SEDIR`/lcc/bin:$PATH;
        export GOBO_CC=bcb
        ;;
    bcb)
        PATH=/cygdrive/e/Eiffel56/BCC55/Bin:$PATH;
        export SmartEiffel=$SEDIR\\sys\\system.se.bcc32
        export GOBO_CC=bcb
        ;;
    msc)
        export SmartEiffel=$SEDIR\\sys\\system.se.cl
        ;;
    *)
        echo "Unknown C compiler "$1" passed"
        exit 1
esac

# generate Makefile.win, build makefile
echo cleaning up...
echo $1>$SEDIR/sys/compiler.se
rm -f lib/libeposix.lib
rm -f *.obj *.h *.c *.id
echo generating Makefile.win and building it...
./makelib.exe -se $2
if [ $? -gt 0 ]; then exit 1; fi
if [ ! -r lib/libeposix.lib ]; then exit 1; fi

# perform tests
echo Starting test...
#./test-se.sh
cd test_suite; geant -v test_debug
if [ $? -gt 0 ]; then exit 1; fi
