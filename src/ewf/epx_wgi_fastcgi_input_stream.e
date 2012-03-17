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

	end_of_input: BOOLEAN
			-- Has the end of input stream been reached?
		do
			Result := fcgi.socket.end_of_input
		end


feature -- Input

	read_character
			-- Read the next character in input stream.
			-- Make the result available in `last_character'.
		do
			if last_string_index = 0 then
				fcgi.read_string
				if not fcgi.last_string.is_empty then
					last_character := fcgi.last_string.item (1)
					last_string_index := 2
				else
					last_character := '%U'
				end
			else
				-- TODO
						check
							todo: false
						end
			end
		end

	read_string (nb: INTEGER)
			-- Read a string of at most `nb' bound characters
			-- or until end of file.
			-- Make result available in `last_string'.
		do
			if last_string_index = 0 or else last_string_index > last_string.count then
				fcgi.read_string
				if fcgi.last_string.count <= nb then
					last_string := fcgi.last_string
				else
					-- TODO
						check
							todo: false
						end
				end
			else
				-- TODO
						check
							todo: false
						end
			end
		end


feature -- Access

	last_string: STRING
			-- Last string read

	last_character: CHARACTER_8
			-- Last item read


feature {NONE} -- Implementation

	last_string_index: INTEGER
			-- Index into `fcgi'.`last_string' if entire string not read

	fcgi: EPX_FAST_CGI
			-- Bridge to Fast CGI world

end
