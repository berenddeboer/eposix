indexing

	description: "CGI key/value pairs."

	author: "Berend de Boer"
	date: "$Date: 2003/01/09 $"
	revision: "$Revision: #2 $"

class

	EPX_KEYVALUE

obsolete "Use EPX_KEY_VALUE instead"

create

	make


feature -- creation

	make (a_key, a_value: STRING) is
		do
			key := a_key
			if a_value = Void then
				create value.make (0)
			else
				value := a_value
			end
		end


feature -- state

	key: STRING
			-- name of variable

	value: STRING
			-- its value
			-- if input type is file, this is the filename as seen by the
			-- user

	file: STDC_TEMPORARY_FILE
			-- optional, valid for input type file
			-- gives access to file as saved on server disk


feature -- change state

	set_file (a_file: STDC_TEMPORARY_FILE) is
		require
			valid_file: a_file /= Void and then a_file.is_open
		do
			file := a_file
		end


invariant

	has_key: key /= Void
	has_value: value /= Void
	valid_file: file /= Void implies not value.is_empty


end -- class EPX_KEYVALUE
