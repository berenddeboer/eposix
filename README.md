# About #

Welcome to eposix, the complete Eiffel to Standard C and Posix binding.
It also contains Windows and Single Unix Specification support.

This library allows you to write daemeons, networking code, do forks,
use pipes, and start and communicate with child processes.

See http://www.berenddeboer.net/eposix/ for more.


# Install #

If installed via git, run `bootstrap`:

    ./bootstrap

This generates the `configure` file.

Set the EPOSIX variable to where your package is, then configure and make.

    export EPOSIX=~/src/eposix
    ./configure --with-compiler=ge|ise --prefix=$EPOSIX
    make && make install

For detailed installation instructions, see [INSTALL](INSTALL).


# Documentation #

The manual is in [doc/eposix-manual.pdf](doc/eposix-manual.pdf).


# Development status #

[![Build Status](https://api.travis-ci.org/berenddeboer/eposix.svg?branch=master)](https://travis-ci.org/berenddeboer/eposix/)
