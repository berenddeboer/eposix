indexing

	description: "Stores multi-part MIME body."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"

class

	EPX_MIME_BODY_MULTIPART


inherit

	EPX_MIME_BODY


create

	make


feature {NONE} -- Initialization

	make (a_header: EPX_MIME_HEADER) is
		do
			header := a_header
			create parts.make
		end


feature -- Status

	is_multipart: BOOLEAN is True

	has_every_part_a_form_content_disposition_field: BOOLEAN is
			-- Does every part have a Content-Disposition field with the
			-- "name" parameter?
		do
			from
				parts.start
			until
				Result or else
				parts.after
			loop
				Result :=
					parts.item_for_iteration.header.content_disposition /= Void and then
					parts.item_for_iteration.header.content_disposition.name_parameter /= Void
				parts.forth
			end
		end

	has_parts_with_multipart_bodies: BOOLEAN is
			-- Does this body have parts that have multipart bodies themselves?
		do
			from
				parts.start
			until
				Result or else
				parts.after
			loop
				Result :=
					parts.item_for_iteration.body /= Void and then
					parts.item_for_iteration.body.is_multipart
				parts.forth
			end
		end

	parts_count: INTEGER is
		-- The number of parts if is_multipart.
		do
			Result := parts.count
		end

	part (index: INTEGER): EPX_MIME_PART is
			-- Part number `index' if this is a multipart body.
		do
			Result := parts.item (index)
		end


feature -- Commands

	append_to_string (s: STRING) is
			-- Stream contents of MIME structure to a STRING.
		local
			ct: EPX_MIME_FIELD_CONTENT_TYPE
		do
			ct := header.content_type
			s.append_character ('-')
			s.append_character ('-')
			s.append_string (ct.boundary)
			s.append_string (once_crlf)
			from
				parts.start
			until
				parts.after
			loop
				parts.item_for_iteration.append_to_string (s)
				parts.forth
				if not parts.after then
					s.append_string (once_crlf)
					s.append_character ('-')
					s.append_character ('-')
					s.append_string (ct.boundary)
					s.append_string (once_crlf)
				end
			end
			s.append_string (once_crlf)
			s.append_character ('-')
			s.append_character ('-')
			s.append_string (ct.boundary)
			s.append_character ('-')
			s.append_character ('-')
			s.append_string (once_crlf)
		end

	append_urlencoded_to_string (s: STRING) is
			-- Append body as x-www-form-urlencoded to `s'.
		require
			has_no_parts_with_multipart_bodies: not has_parts_with_multipart_bodies
			every_part_has_a_form_content_disposition_field: has_every_part_a_form_content_disposition_field
		local
			cd: EPX_MIME_FIELD_CONTENT_DISPOSITION
			body: EPX_MIME_BODY_TEXT
		do
			from
				parts.start
			until
				parts.after
			loop
				cd := parts.item_for_iteration.header.content_disposition
				s.append_string (url_encoder.escape_string (cd.name_parameter.value))
				s.append_character ('=')
				body ?= parts.item_for_iteration.body
				if body /= Void then
					s.append_string (url_encoder.escape_string (body.as_string))
				end
				parts.forth
				if not parts.after then
					s.append_character ('&')
				end
			end
		end

	as_plain_text: STRING is
			-- Return the contents of the body as 8bit text/plain data.
			-- It is not checked if the resulting string does contain
			-- NULL characters.
		do
			-- not applicable
		end


feature -- Access

	header: EPX_MIME_HEADER
			-- Header for this body

	parts: DS_LINKED_LIST [EPX_MIME_PART]


feature -- New parts

	new_part: EPX_MIME_PART is
			-- New part which is also appended to `parts'
		do
			create Result.make_empty
			Result.set_auto_insert_content_length (False)
			parts.put_last (Result)
		ensure
			part_returned: Result /= Void
			one_part_added: parts.count = old parts.count + 1
			result_is_last_part: parts.last = Result
		end


feature {NONE} -- Implementation

	url_encoder: EPX_URL_ENCODING is
		once
			create Result
		end


feature {NONE} -- Once strings

	once_crlf: STRING is "%R%N"



invariant

	header_not_void: header /= Void
	has_parts: parts /= Void
	parts_count_in_sync: parts_count = parts.count

end
