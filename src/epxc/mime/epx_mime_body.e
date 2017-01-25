note

	description: "Base class for MIME single and multipart bodies."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	EPX_MIME_BODY


feature -- Access to body content

	append_to_string (s: STRING)
			-- Stream contents of MIME structure to a STRING.
		require
			s_not_void: s /= Void
		deferred
		end

	as_plain_text: STRING
			-- Return the contents of the body as 8bit text/plain data.
			-- It is not checked if the resulting string does contain
			-- NULL characters.
			-- The decoding can be expensive, cache the result instead of
			-- asking for it multiple times.
		require
			not_multipart: not is_multipart
		deferred
		ensure
			as_string_not_void: Result /= Void
		end

	as_string: STRING
			-- Return body as STRING.
			-- If body is multipart, it is returned as a MIME structure.
			-- If the body is encoded in a certain way (BASE64 for
			-- example), it is returned in that encoding.
			-- This can be an expensive operation.
		do
			create Result.make_empty
			append_to_string (Result)
		ensure
			as_string_not_void: Result /= Void
		end


feature -- Queries

	has_every_part_a_form_content_disposition_field: BOOLEAN
			-- Does every part have a Content-Disposition field?
			-- Necessary in case the MIME structure describes HTML form data.
		deferred
		end

	has_parts_with_multipart_bodies: BOOLEAN
			-- Is one of the bodies itself multipart?
		deferred
		ensure
			self_is_multipart: not is_multipart implies not Result
		end

	is_multipart: BOOLEAN
			-- True if body is multipart.
		deferred
		end

	parts_count: INTEGER
		-- The number of parts if is_multipart.
		deferred
		end

	part (index: INTEGER): EPX_MIME_PART
			-- Part number `index' if this is a multipart body.
		require
			multipart: is_multipart
			valid_index: index >= 1 and index <= parts_count
		deferred
		end


invariant

	no_parts_if_not_multipart: not is_multipart implies parts_count = 0

end
