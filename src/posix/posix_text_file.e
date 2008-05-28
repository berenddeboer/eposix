indexing

	description: "Class that describes a POSIX text file. POSIX doesn't %
	%have a distinction between text and binary files, but code ported to %
	%other platforms likes it (Cygwin)."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

class

	POSIX_TEXT_FILE


inherit

	POSIX_FILE

	STDC_TEXT_FILE


create

	create_read_write,
	create_write,
	open,
	open_append,
	open_read,
	open_read_write,
	open_write,
	attach_to_stream,
	make_from_file_descriptor


end
