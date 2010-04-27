indexing

	description: "eposix's file and socket classes (STDC_FILE, POSIX_FILE_DESCRIPTOR, SUS_SOCKET) all inherit from this class. This makes eposix plug compatible with Gobo and any other library using a KI_CHARACTER_INPUT_STREAM."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


deferred class

	EPX_CHARACTER_INPUT_STREAM


inherit

	STDC_BASE
		export
			{NONE} all;
			{ANY} errno
		end

	KI_CHARACTER_INPUT_STREAM
		undefine
			close
		redefine
			is_rewindable,
			read_to_string
		end


feature -- Access

	is_rewindable: BOOLEAN is
			-- Can current input stream be rewound to return input from
			-- the beginning of the stream?
		once
			Result := True
		end

	is_streaming: BOOLEAN is
			-- Is data coming from a network stream?
		require
			open: is_open_read
		deferred
		end


feature -- Input

	last_read: INTEGER is
			-- Last bytes read by `read_buffer'.
			-- Can be less than requested for non-blocking input.
			-- Check `last_blocked' in that case.
		deferred
		end

	read_buffer (buf: STDC_BUFFER; offset, nbytes: INTEGER) is
			-- Read data into `buf' at `offset' for `nbytes' bytes.
			-- Number of bytes actually read are available in `last_read'.
		require
			is_open_read: is_open_read
			not_end_of_input: not end_of_input
			nbytes_not_negative: nbytes >= 0
			offset_not_negative: offset >= 0
			buf_not_void: buf /= Void
			dont_overflow: buf.capacity >= offset + nbytes
		deferred
		ensure
			read_no_more_than_requested: last_read <= nbytes
		end

	read_to_string (a_string: STRING; pos, nb: INTEGER): INTEGER is
			-- Fill `a_string', starting at position `pos', with
			-- at most `nb' characters read from input stream.
			-- Return the number of characters actually read.
		local
			buf: STDC_BUFFER
		do
			create buf.allocate (nb)
			read_buffer (buf, 0, nb)
			Result := last_read
			buf.put_to_string (a_string, pos, 0, nb - 1)
		end



feature -- Debug

	set_dump_input (a_file_name: STRING) is
		do
			debug ("dump-input")
				create {STDC_TEXT_FILE} dump_input.open_write (a_file_name)
			end
		ensure
			dump_input_set: dump_input /= Void
		end


feature {NONE} -- Debug

	dump_input: EPX_TEXT_OUTPUT_STREAM
			-- When the debug option "dump-input" is enabled and this is
			-- set via `set_dump_input', all input is written to the
			-- given stream immediately after reading.


end
