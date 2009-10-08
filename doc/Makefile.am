# Process this file with automake to produce Makefile.in

# This Makefile needs gmake!

include $(top_srcdir)/config/myrules.mak


# redefine clean to remove SE files.

mostlyclean-generic:
	geant clean
	rm -f compile_short.ace

# A user cannot built eposix-manual.pdf, but we include it with this
# package. Because of EXTRA_DIST, make distcheck will fail, it tries
# to built the distribution from the installed files.
EXTRA_DIST = \
	$(EXSRC) \
	system.xace \
	eposix-manual.tex eposix-manual.pdf \
	eposix-classes.tex eposix-classes.pdf \
	eposix-format.tex fmapping.tex \
	inherit.mp \
	Makefile.e_sources Makefile.short Makefile.flat


# assume a texexec with bibtex support

eposix-manual.pdf: eposix-manual.tex fmapping.tex inherit.1 directory.png eposix-bw.png eposix.png .examples-compile
	texexec --output=pdftex --result=temp.pdf $<
	mv temp.pdf $@

eposix-classes.pdf: eposix-classes.tex eposix-bw.png eposix.png $(SHORTTEX) $(FLATTEX) system.xace
	texexec --output=pdftex --result=temp.pdf $<
	mv temp.pdf $@


# include sources

ESRC = $(shell find ../src/ -name "*.e")


# include example sources

include Makefile.e_sources

# Short/flat classes produced in the manual.

include Makefile.short
include Makefile.flat

# turn them into binaries

EXBIN = $(patsubst %.e,%.bin,$(EXSRC))

# override example targets that are no root classes

fork_child.bin: fork_child.e
	touch $@


# make sure all examples compile
.examples-compile: $(EXBIN)
	touch $@

# turn those shorts/flats into filenames

# .short-tex: system.xace compile_short.ace $(ESRC)
#	for i in $(SHORT_CLASSES); do short -short -no_style_warning compile_short.ace $$i > `echo $$i.tex | tr '[:upper:]' '[:lower:]'`; done;
#	touch $@

# .flat-tex: system.xace compile_short.ace $(ESRC)
#	for i in $(FLAT_CLASSES); do short -no_style_warning compile_short.ace $$i > `echo $$i.tex | tr '[:upper:]' '[:lower:]'`; done;
#	touch $@

compile_short.ace: system.xace $(top_srcdir)/src/library.xace
	gexace --define="SE_1_0=true GOBO_OS=unix ROOT_CLASS=EXAMPLE" --system="se" --output="compile_short.ace" $(top_srcdir)/doc/system.xace


# templates

.e.bin: system.xace $(ESRC)
	gexace --define="SE_1_0=true DEBUG=true GOBO_OS=unix GOBO_EIFFEL=${GOBO_EIFFEL} ROOT_CLASS=`basename $< .e | tr [:lower:] [:upper:]`" --system="${GOBO_EIFFEL}" --output="compile_${GOBO_EIFFEL}.ace" $(top_srcdir)/doc/system.xace
if ISE
	mv compile_${GOBO_EIFFEL}.ace compile_${GOBO_EIFFEL}.ecf
	rm -rf EIFGEN
	ec -finalize -config compile_${GOBO_EIFFEL}.ecf
	cd EIFGENs/eposix_test/F_code && finish_freezing
	mv EIFGENs/eposix_test/F_code/eposix_test $@
endif
if SE
	compile compile_${GOBO_EIFFEL}.ace
	mv eposix_test $@
endif
if GE
	mv compile_${GOBO_EIFFEL}.ace compile_${GOBO_EIFFEL}.xace
	gec compile_${GOBO_EIFFEL}.xace
	mv eposix_test $@
endif

.mp.1:
	mpost \&metafun $<
