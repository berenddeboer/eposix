note

	description: "Reader for STDC_TEXT_FILE class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

class

	EPX_FILE_READER

obsolete "Use STDC_TEXT_FILE instead"

inherit

	EPX_READER


create

	make


feature -- creation

	make (a_input: STDC_TEXT_FILE)
		require
			is_a_file: a_input /= Void
		do
			file := a_input
		end


feature -- state


	last_character: CHARACTER
		do
			Result := file.last_character
		end

	last_string: STRING
		do
			Result := file.last_string
		end


feature -- queries

	eof: BOOLEAN
		do
			Result := file.eof
		end


feature -- commands

	chop_last_string
		obsolete "Not needed anymore. last_string does not have end-of-line characters."
		do
			-- not needed anymore
			--file.chop_last_string
		end

	read (buf: POINTER; bytes: INTEGER)
		do
			file.read (buf, 0, bytes)
		end

	read_character
		do
			file.read_character
		end

	read_string (bytes: INTEGER)
		do
			file.read_line
		end

	set_buffer (size: INTEGER)
		do
			file.set_full_buffering (default_pointer, size)
		end


feature {NONE} -- private state

	file: STDC_TEXT_FILE


invariant

	can_read: file /= Void

end
