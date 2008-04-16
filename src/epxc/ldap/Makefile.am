# Process this file with automake to produce Makefile.in

BUILT_SOURCES = epx_ldif_scanner.e epx_ldif_parser.e

MOSTLYCLEANFILES = $(BUILT_SOURCES)

EXTRA_DIST = \
	epx_ldif_scanner.l \
	epx_ldif_parser.y \
	$(BUILT_SOURCES)

epx_ldif_scanner.e: epx_ldif_scanner.l
	gelex -o temp.e epx_ldif_scanner.l
	mv temp.e $@

epx_ldif_parser.e: epx_ldif_parser.y
	geyacc --new_typing -t EPX_LDIF_TOKENS -v verbose.txt -o temp.e epx_ldif_parser.y
	mv temp.e $@
