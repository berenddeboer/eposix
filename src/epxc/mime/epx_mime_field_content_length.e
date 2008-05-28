indexing

	description: "Field Content-Length"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	EPX_MIME_FIELD_CONTENT_LENGTH


inherit

	EPX_MIME_STRUCTURED_FIELD


create

	make



feature -- Initialization

	make (a_length: INTEGER) is
			-- Initialize Content-Length.
		require
			length_not_negative: a_length >= 0
		do
			length := a_length
		ensure
			length_set: length = a_length
		end


feature -- Access

	name: STRING is "Content-Length"
			-- Authorative name

	length: INTEGER
			-- Number of bytes in body

	value: STRING is
			-- Value of a field
		do
			Result := length.out
		end


feature -- Change

	set_length (a_length: INTEGER) is
			-- Set `a_length'.
		require
			length_not_negative: a_length >= 0
		do
			length := a_length
		ensure
			definition: length = a_length
		end


invariant

	length_not_negative: length >= 0

end
