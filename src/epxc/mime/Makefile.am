# Process this file with automake to produce Makefile.in

BUILT_SOURCES = epx_mime_scanner.e epx_mime_parser.e epx_mime_encoded_word_scanner.e

MOSTLYCLEANFILES = $(BUILT_SOURCES)

EXTRA_DIST = \
	epx_mime_scanner.l \
	epx_mime_parser.y \
	epx_mime_encoded_word_scanner.l \
	$(BUILT_SOURCES)

epx_mime_scanner.e: epx_mime_scanner.l
	gelex epx_mime_scanner.l

epx_mime_parser.e: epx_mime_parser.y
	geyacc -t EPX_MIME_TOKENS -v verbose.txt -o epx_mime_parser.e epx_mime_parser.y

epx_mime_encoded_word_scanner.e: epx_mime_encoded_word_scanner.l
	gelex epx_mime_encoded_word_scanner.l
