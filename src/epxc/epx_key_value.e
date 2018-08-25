note

	description: "key=value pairs as used in HTML forms. Used for CGI programs and the HTTP server."

	author: "Berend de Boer"


class

	EPX_KEY_VALUE


create

	make


feature {NONE} -- Initialization

	make (a_key, a_value: STRING)
			-- Initialize.
		require
			has_key: a_key /= Void and then not a_key.is_empty
			has_value: a_value /= Void
		do
			key := a_key
			value := a_value
		end


feature -- Access

	key: STRING
			-- Field name of variable.

	value: STRING
			-- Its value.
			-- If input type is file, this is the filename as seen by the
			-- user.

	file: detachable EPX_CHARACTER_IO_STREAM
			-- Optional, valid for input type file, gives access to file
			-- as saved on server disk.
			-- File is temporary, and removed when `file' is closed or when
			-- the program shuts down.


feature -- Change state

	set_file (a_file: EPX_CHARACTER_IO_STREAM)
			-- Set `file'.
		require
			filename_known: not value.is_empty
			valid_file: a_file /= Void and then a_file.is_open
		do
			file := a_file
		end

	set_value (a_value: STRING)
			-- Set `value'.
		require
			a_value_not_void: a_value /= Void
		do
			value := a_value
		ensure
			value_set: value.is_equal (a_value)
		end


invariant

	has_key: attached key and then not key.is_empty
	has_value: attached value
	filename_known: attached file implies not value.is_empty
	file_readable: attached file as a_file implies a_file.is_open_read

end
