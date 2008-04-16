indexing

	description: "Field Content-Transfer-Encoding"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_MIME_FIELD_CONTENT_TRANSFER_ENCODING


inherit

	EPX_MIME_STRUCTURED_FIELD
		rename
			value as mechanism
		end


creation

	make



feature -- Initialization

	make (a_mechanism: STRING) is
			-- Initialize Content-Transfer-Encoding.
		require
			mechanism_not_empty: a_mechanism /= Void and then not a_mechanism.is_empty
		do
			mechanism := a_mechanism
		end


feature -- Access

	mechanism: STRING
			-- Type of encoding

	name: STRING is "Content-Transfer-Encoding"
			-- Authorative name


feature -- Decoders

	new_decoder: EPX_STREAM_INPUT_STREAM [CHARACTER] is
			-- Return a new decoder that can decode text encoded
			-- according to `mechanism'.
			-- Returns Void if there is no known encoder.
		local
			s: STRING
		do
			create s.make_from_string (mechanism)
			s.to_lower
			if s.is_equal (once_base64) then
				create {EPX_BASE64_INPUT_STREAM} Result.make
			elseif s.is_equal (once_quoted_printable) then
				create {EPX_QUOTED_PRINTABLE_INPUT_STREAM} Result.make
			end
		end


feature {NONE} -- Known encodings

	once_base64: STRING is "base64"
	once_quoted_printable: STRING is "quoted-printable"


invariant

	mechanism_not_empty: mechanism /= Void and then not mechanism.is_empty

end
