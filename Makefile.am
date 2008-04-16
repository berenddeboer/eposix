# Process this file with automake to produce Makefile.in

SUBDIRS = src test_suite doc ise_precompile

EXTRA_DIST = \
	config/myrules.mak \
	makelib.exe makelib.cfg \
	eposix.ecf


# Override TAGS

TAGS:
	cd src; make TAGS
