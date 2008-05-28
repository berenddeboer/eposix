indexing

	description: "key=value pairs as used in HTML forms. Used for CGI programs and the HTTP server."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"

class

	EPX_KEY_VALUE


create

	make


feature {NONE} -- Initialization

	make (a_key, a_value: STRING) is
			-- Initialize.
		require
			has_key: a_key /= Void and then not a_key.is_empty
			has_value: a_value /= Void
		do
			key := a_key
			if a_value = Void then
				value := ""
			else
				value := a_value
			end
		end


feature -- Access

	key: STRING
			-- Field name of variable.

	value: STRING
			-- Its value.
			-- If input type is file, this is the filename as seen by the
			-- user.

	file: EPX_CHARACTER_IO_STREAM
			-- Optional, valid for input type file, gives access to file
			-- as saved on server disk.
			-- File is temporary, and removed when `file' is closed or when
			-- the program shuts down.


feature -- Change state

	set_file (a_file: EPX_CHARACTER_IO_STREAM) is
			-- Set `file'.
		require
			filename_known: not value.is_empty
			valid_file: a_file /= Void and then a_file.is_open
		do
			file := a_file
		end

	set_value (a_value: STRING) is
			-- Set `value'.
		require
			a_value_not_void: a_value /= Void
		do
			value := a_value
		ensure
			value_set: value.is_equal (a_value)
		end


invariant

	has_key: key /= Void and then not key.is_empty
	has_value: value /= Void
	filename_known: file /= Void implies not value.is_empty
	file_readable: file /= Void implies file.is_open_read

end
