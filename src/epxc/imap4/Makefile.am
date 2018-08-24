# Process this file with automake to produce Makefile.in

BUILT_SOURCES = epx_imap4_response_scanner.e epx_imap4_response_parser.e

MOSTLYCLEANFILES = $(BUILT_SOURCES)

EXTRA_DIST = \
	epx_imap4_response_scanner.l \
	epx_imap4_response_parser.y \
	$(BUILT_SOURCES)

epx_imap4_response_scanner.e: epx_imap4_response_scanner.l
	gelex -o $@.tmp epx_imap4_response_scanner.l
	mv $@.tmp $@

epx_imap4_response_parser.e: epx_imap4_response_parser.y
	geyacc -t EPX_IMAP4_RESPONSE_TOKENS -v verbose.txt -o $@.tmp epx_imap4_response_parser.y
	mv $@.tmp $@
