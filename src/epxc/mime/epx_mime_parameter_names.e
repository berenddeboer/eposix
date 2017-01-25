note

	description: "Well-known MIME parameter names and values."

	usage: "Inherit from this class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	EPX_MIME_PARAMETER_NAMES


feature -- Status

	is_valid_parameter_name (a_name: STRING): BOOLEAN
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

	parameter_name_boundary: STRING = "boundary"

	parameter_name_charset: STRING = "charset"


feature -- Content-Disposition parameter name

	parameter_name_filename: STRING = "filename"

	parameter_name_name: STRING = "name"


feature -- charset parameter

	charset_utf8: STRING = "UTF-8"


feature -- WWW-Authenticate

	parameter_name_algorithm: STRING = "algorithm"

	parameter_name_nonce: STRING = "nonce"

	parameter_name_opaque: STRING = "opaque"

	parameter_name_realm: STRING = "realm"

	parameter_name_qop: STRING = "qop"

	parameter_name_stale: STRING = "stale"

	parameter_name_uri: STRING = "uri"


end
