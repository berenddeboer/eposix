indexing

	description: "Base class for a header field in a MIME message."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


deferred class

	EPX_MIME_FIELD


inherit

	EPX_MIME_ROUTINES


feature -- Output

	append_to_string (s: STRING) is
			-- Stream contents of MIME structure to a STRING.
		require
			s_not_void: s /= Void
		do
			s.append_string (name)
			s.append_string (once_space_colon)
			s.append_string (value)
			s.append_string (once_crlf)
		end


feature -- Access

	name: STRING is
			-- Name of MIME field;
			-- Names are case-insensitive.
		deferred
		ensure
			name_valid: is_valid_mime_name (Result)
		end

	value: STRING is
			-- Contents of this field flattened as a string;
			-- Result can contain 8-bit characters.
		deferred
		ensure
			valid_value: is_valid_field_body (Result)
		end


feature {NONE} -- Once strings

	once_crlf: STRING is "%R%N"
	once_space_colon: STRING is ": "


end
