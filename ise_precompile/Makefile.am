# Process this file with automake to produce Makefile.in

EXTRA_DIST = system.xace

MOSTLYCLEANFILES = precompile.ecf precomp.epr


dist-hook: precompile.ecf
	ec -precompile -ace $<
	if [ -e EIFGEN/W_code/Makefile.SH ]; then cd EIFGEN/W_code; finish_freezing; fi

precompile.ecf: $(top_srcdir)/src/library.xace system.xace
	gexace --define="GOBO_OS=unix" --system=ise --output=$@


clean-generic:
	rm -rf EIFGEN
