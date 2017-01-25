note

	description:

		"Reads stdin from fastcgi socket; to be used with EWF"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2012, Berend de Boer"
	license: "MIT License (see LICENSE)"


class

	EPX_WGI_FASTCGI_INPUT_STREAM


inherit

	WGI_INPUT_STREAM

	EPX_CHARACTER_INPUT_STREAM
		undefine
			read_to_string
		redefine
			valid_unread_character
		end


create

	make


feature {NONE} -- Initialization

	make (a_fcgi: like fcgi)
		require
			valid_fcgi: a_fcgi /= Void
		do
			fcgi := a_fcgi
			initialize
		end

	initialize
			-- Initialize Current
		do
			create last_string.make_empty
		end


feature -- Status report

	is_open_read: BOOLEAN
			-- Can items be read from input stream?
		do
			Result := fcgi.socket.is_open_read
		end

	is_streaming: BOOLEAN
		do
			Result := True
		end

	end_of_input: BOOLEAN
			-- Has the end of input stream been reached?
		do
			Result := fcgi.end_of_input
		end

	valid_unread_character (a_character: CHARACTER): BOOLEAN
			-- Can `a_character' be put back in input stream?
		do
			Result := False
		end


feature -- Access

	name: STRING
			-- Name of input stream
		once
			Result := "fastcgi"
		end

	last_string: STRING
			-- Last string read

	last_character: CHARACTER_8
			-- Last item read

	last_read: INTEGER
			-- Last bytes read by `read_buffer'.
			-- Can be less than requested for non-blocking input.
			-- Check `last_blocked' in that case.
		do
			Result := fcgi.last_read
		end


feature -- Input

	read_character
			-- Read the next character in input stream.
			-- Make the result available in `last_character'.
		do
			if last_string_index = 0 or last_string_index > fcgi.last_string.count then
				fcgi.read_string
				if not fcgi.last_string.is_empty then
					last_character := fcgi.last_string.item (1)
					last_string_index := 2
				else
					last_character := '%U'
				end
			else
				last_character := fcgi.last_string.item (last_string_index)
				last_string_index := last_string_index + 1
			end
		end

	read_string (nb: INTEGER)
			-- Read a string of at most `nb' bound characters
			-- or until end of file.
			-- Make result available in `last_string'.
		local
			next_index: INTEGER
		do
			if last_string_index = 0 then
				fcgi.read_string
				if fcgi.last_string.count <= nb then
					last_string := fcgi.last_string
				else
					last_string := fcgi.last_string.substring (last_string_index + 1, last_string_index + nb)
					last_string_index := last_string_index + nb
				end
			else
				next_index := last_string_index + nb
				if next_index > fcgi.last_string.count then
					next_index := fcgi.last_string.count
				end
				last_string := fcgi.last_string.substring (last_string_index + 1, next_index)
				if next_index = fcgi.last_string.count then
					last_string_index := 0
				else
					last_string_index := next_index
				end
			end
		ensure then
			last_index_in_bounds: last_string_index = 0 or else last_string_index <= fcgi.last_string.count
		end

	unread_character (an_item: CHARACTER)
			-- Put `an_item' back in input stream.
			-- This item will be read first by the next
			-- call to a read routine.
		do
			-- Unsupported
		end

	read_buffer (buf: STDC_BUFFER; offset, nbytes: INTEGER)
			-- Read data into `buf' at `offset' for `nbytes' bytes.
			-- Number of bytes actually read are available in `last_read'.
		do
			fcgi.read_buffer (buf, offset, nbytes)
		end


feature -- Commands

	close
		do
		end


feature {NONE} -- Implementation

	last_string_index: INTEGER
			-- Index into `fcgi'.`last_string' if entire string not read

	fcgi: EPX_FAST_CGI
			-- Bridge to Fast CGI world

invariant

	last_string_index_not_negative: last_string_index >= 0

end
