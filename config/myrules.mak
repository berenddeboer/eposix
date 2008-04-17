# we need to tell the C compiler what Eiffel compiler we use
# and we need to tell the include directory where the header file
# for our Eiffel compiler resides.
SUFFIXES = .e .mc .rc .res .dll .pdf .tex .bbl .aux .1 .mp .bin

AM_CFLAGS=-DEIFFEL_VENDOR_$(GOBO_EIFFEL) -I$(EIFFEL_COMPILER_HEADER_DIR) $(OPTIONAL_MULTITHREAD_FLAG)
