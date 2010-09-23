# Process this file with automake to produce Makefile.in

EXTRA_DIST = system.xace

MOSTLYCLEANFILES = precompile.ecf precomp.epr


dist-hook: precompile.ecf
	source ~/bin/new-gobo; ec -precompile -config $<

# C compiler runs out of memory
#	if [ -e EIFGENs/eposix_precompile/W_code/Makefile.SH ]; then cd EIFGENs/eposix_precompile/W_code; finish_freezing; fi

precompile.ecf: $(top_srcdir)/src/library.xace system.xace
	source ~/bin/new-gobo; gexace --define="GOBO_OS=unix" --system=ise --output=$@

windows.ecf: $(top_srcdir)/src/library.xace system.xace
	gexace --define="GOBO_OS=windows" --system=ise --output=$@

clean-generic:
	rm -rf EIFGENs
