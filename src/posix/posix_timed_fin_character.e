indexing

	description: "Class that reads a character from a stream,%
	%waiting a given number of seconds for that character, or else returns."

	author: "Berend de Boer"
	date: "$Date";
	revision: "$Revision: #3 $"

class

	POSIX_TIMED_FIN_CHARACTER


inherit

	POSIX_TIMED_COMMAND
		rename
			make as inherited_make
		end


create

	make


feature -- Initialization

	make (a_seconds: INTEGER; a_stream: POSIX_FILE) is
		require
			valid_seconds: a_seconds >= 1 and a_seconds <= 65535
			stream_not_void: a_stream /= Void
		do
			inherited_make (a_seconds)
			stream := a_stream
		end


feature -- Access

	stream: POSIX_FILE


feature {NONE}

	do_execute is
		do
			-- stream.read_string (256)
			stream.read_character
		end


invariant

	stream_not_void: stream /= Void

end
