#!/bin/sh

SAVEPATH=$PATH
export SEDIR='m:\elj-win32\SmartEiffel'

PATH=/cygdrive/e/BCC55/Bin:$SAVEPATH
./makelib -bcc -se
if [ $? -gt 0 ]; then exit 1; fi

PATH=/m/elj-win32/lcc/bin:$SAVEPATH
./makelib -lcc -se
if [ $? -gt 0 ]; then exit 1; fi

./makelib -msc -se
if [ $? -gt 0 ]; then exit 1; fi

PATH=/cygdrive/e/BCC55/Bin:$SAVEPATH
./makelib -bcc -ise
if [ $? -gt 0 ]; then exit 1; fi

./makelib -msc -ise
if [ $? -gt 0 ]; then exit 1; fi

./makelib -mingw -ise
if [ $? -gt 0 ]; then exit 1; fi

./makelib -mingw -ge
if [ $? -gt 0 ]; then exit 1; fi
