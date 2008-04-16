# Process this file with automake to produce Makefile.in

EXTRA_DIST = system.xace

MOSTLYCLEANFILES = precompile.ace precomp.epr


dist-hook: precompile.ace
	ec -precompile -ace $<
	if [ -e EIFGEN/W_code/Makefile.SH ]; then cd EIFGEN/W_code; finish_freezing; fi

precompile.ace: $(top_srcdir)/src/library.xace system.xace
	gexace --define="GOBO_OS=unix" --system=ise --output=$@


clean-generic:
	rm -rf EIFGEN
