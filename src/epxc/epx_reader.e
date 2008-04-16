indexing

	description: "Abstract reader (input) class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	EPX_READER

obsolete "Use KI_CHARACTER_INPUT_STREAM instead."

feature -- state

	last_character: CHARACTER is
			-- last character read by `read_character'
			-- assume CHARACTER is an 8-bit value
		deferred
		end

	last_string: STRING is
			-- last string read by `read_string'
		deferred
		end


feature -- queries

	eof: BOOLEAN is
			-- True if end of input encountered
		deferred
		end

feature -- commands

	chop_last_string is
			-- remove end-of-line (Unix or Windows)
		deferred
		end

	read (buf: POINTER; bytes: INTEGER) is
			-- read chunk of `bytes' size
		deferred
		end

	read_character is
		deferred
		end

	read_string (bytes: INTEGER) is
			-- Read at most `n' characters.
			-- result is placed in `last_string'
			-- `last_string' includes the newline character!
		deferred
		end

	set_buffer (size: INTEGER) is
			-- optimize reading by doing it in `size' bytes at a time
		deferred
		end

end -- class EPX_READER
