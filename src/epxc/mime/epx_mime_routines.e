indexing

	description: "Various MIME specific routines, useful for validating input."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_MIME_ROUTINES


feature -- Queries

	is_valid_field_body (a_body: STRING): BOOLEAN is
			-- Is `a_body' valid content for a MIME header field?
			-- `a_body' is valid if it does not contain the %U, %R and %N
			-- characters.
			-- 8-bit characters are considered ok. It is the duty of the
			-- serialization process to make sure 8-bit characters are
			-- properly encoded.
		local
			i: INTEGER
			c: CHARACTER
		do
			Result := a_body /= Void
			from
				i := 1
			variant
				a_body.count - (i - 1)
			until
				not Result or else
				i > a_body.count
			loop
				c := a_body.item (i)
				Result :=
					c /= '%U' and then
					c /= '%R' and then
					c /= '%N'
				i := i + 1
			end
		ensure
			no_end_of_line: Result implies a_body /= Void and then not a_body.has ('%N')
		end

	is_valid_mime_name (a_name: STRING): BOOLEAN is
			-- Is `a_name' a valid MIME field name?
			-- Valid names only consist of the US-ASCII characters with
			-- the values 33-126 and it does not contain a colon.
		local
			i: INTEGER
			c: CHARACTER
		do
			Result := a_name /= Void
			from
				i := 1
			variant
				a_name.count - (i - 1)
			until
				not Result or else
				i > a_name.count
			loop
				c := a_name.item (i)
				Result :=
					c.code >= 33 and then
					c.code <= 126 and then
					c /= ':'
				i := i + 1
			end
		ensure
			no_colon: Result implies a_name /= Void and then not a_name.has (':')
		end

end
