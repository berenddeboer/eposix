note

	description: "Abstract reader (input) class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	EPX_READER

obsolete "Use KI_CHARACTER_INPUT_STREAM instead."

feature -- state

	last_character: CHARACTER
			-- last character read by `read_character'
			-- assume CHARACTER is an 8-bit value
		deferred
		end

	last_string: STRING
			-- last string read by `read_string'
		deferred
		end


feature -- queries

	eof: BOOLEAN
			-- True if end of input encountered
		deferred
		end

feature -- commands

	chop_last_string
			-- remove end-of-line (Unix or Windows)
		deferred
		end

	read (buf: POINTER; bytes: INTEGER)
			-- read chunk of `bytes' size
		deferred
		end

	read_character
		deferred
		end

	read_string (bytes: INTEGER)
			-- Read at most `n' characters.
			-- result is placed in `last_string'
			-- `last_string' includes the newline character!
		deferred
		end

	set_buffer (size: INTEGER)
			-- optimize reading by doing it in `size' bytes at a time
		deferred
		end

end -- class EPX_READER
