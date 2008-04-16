indexing

	description: "Well-known MIME parameter names and values."

	usage: "Inherit from this class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	EPX_MIME_PARAMETER_NAMES


feature -- Status

	is_valid_parameter_name (a_name: STRING): BOOLEAN is
			-- Is `a_name' valid parameter name?
			-- It cannot be empty, must be lowercase and contain only
			-- valid characters.
		do
			-- @@BdB: must check for valid characters here...
			Result :=
				a_name /= Void and then
				not a_name.is_empty and then
				a_name.as_lower.is_equal (a_name)
		end


feature -- Content-Type parameter names

	parameter_name_boundary: STRING is "boundary"

	parameter_name_charset: STRING is "charset"


feature -- Content-Disposition parameter name

	parameter_name_filename: STRING is "filename"

	parameter_name_name: STRING is "name"


feature -- charset parameter

	charset_utf8: STRING is "UTF-8"


feature -- WWW-Authenticate

	parameter_name_realm: STRING is "realm"


end
