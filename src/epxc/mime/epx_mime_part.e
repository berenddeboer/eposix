indexing

	description:
		"Can be an entire MIME message, or a part of a multipart message."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


class

	EPX_MIME_PART


inherit

	ANY

	EPX_FACTORY
		export
			{NONE} all
		end

	EPX_MIME_TYPE_NAMES
		export
			{NONE} all
		end

	EPX_MIME_FIELD_NAMES
		export
			{NONE} all;
			{ANY} field_name_content_length, field_name_content_transfer_encoding
		end

	EPX_MIME_PARAMETER_NAMES
		export
			{NONE} all
		end


create

	make_empty


feature {NONE} -- Initialization

	make_empty is
			-- Make an empty MIME part. Useful during parsing to
			-- construct the message gradually.
		do
			create header.make_default
			auto_insert_content_length := True
		end


feature -- Output

	append_to_string (s: STRING) is
			-- Serialize contents of MIME structure to `s'.
			-- Adds the Content-Length field with the proper length, if
			-- this field does not exist. If there is a Content-Length
			-- field, it is assumed that this size is correct.
			-- Line lengths should remain within the limit set by RFC
			-- 822, i.e. no more than 998 characters, and preferably no
			-- more than 78 (this length excludes the CRLF).
		require
			s_not_void: s /= Void
			valid_mime_part: is_valid
			content_length_is_integer:
				header.has (field_name_content_length) implies
					header.item (field_name_content_length).value.is_integer
		local
			body_text: STRING
			cl: EPX_MIME_FIELD_CONTENT_LENGTH
			body_size: INTEGER
		do
			if body /= Void then
				create body_text.make_empty
				body.append_to_string (body_text)
				body_size := body_text.count
				-- If there is a Content-Length field, assume it is correct.
				if not header.has (field_name_content_length) then
					if auto_insert_content_length then
						create cl.make (body_size)
						header.add_field (cl)
					end
				else
					body_size := header.item (field_name_content_length).value.to_integer
					-- check body size for client
						check
							content_length_correct: body_size = body_text.count
						end
				end
			end
			header.append_fields_to_string (s)
			s.append_string (once_crlf)
			if body_text /= Void then
				s.append_string (body_text)
			end
		end

	append_urlencoded_to_string (s: STRING) is
			-- Append fields of this MIME structure to `s', and the body
			-- as x-www-form-urlencoded. Message must conform to RFC 2388.
		require
			s_not_void: s /= Void
			multipart_body: body = Void or else body.is_multipart
			has_no_parts_with_multipart_bodies: body = Void or else not body.has_parts_with_multipart_bodies
			every_part_has_a_form_content_disposition_field: body = Void or else body.has_every_part_a_form_content_disposition_field
		local
			body_text: STRING
			cl: EPX_MIME_FIELD_CONTENT_LENGTH
		do
			if multipart_body /= Void then
				create body_text.make_empty
				multipart_body.append_urlencoded_to_string (body_text)
				if auto_insert_content_length then
					if not header.has (field_name_content_length) then
						create cl.make (body_text.count)
						header.add_field (cl)
					else
						header.content_length.set_length (body_text.count)
					end
				end
			end
			header.append_fields_to_string (s)
			s.append_string (once_crlf)
			if body_text /= Void then
				s.append_string (body_text)
			end
		end


feature -- Access

	as_string: STRING is
			-- Serialized MIME message
		require
			valid_mime_part: is_valid
		do
			create Result.make (4096)
			append_to_string (Result)
		ensure
			as_string_not_void: Result /= Void
		end

	auto_insert_content_length: BOOLEAN
			-- If a Content-Length field does not exist, should
			-- `append_to_string' automatically add one?

	body: EPX_MIME_BODY
			-- The body, can be multipart

	header: EPX_MIME_HEADER
			-- Fields for this part

	multipart_body: EPX_MIME_BODY_MULTIPART
			-- `body' if `body' contains multiple parts, Void otherwise

	text_body: EPX_MIME_BODY_TEXT
			-- `body' if `body' is a text body and not multi-part, Void otherwise


feature -- Status

	is_valid: BOOLEAN is
			-- Does this message conform to the MIME specification?
			-- If so, it can be serialized.
			-- If the body is multi-part, the boundary must be set.
		do
			Result :=
				(body /= Void and then body.is_multipart) implies
					(header.content_type /= Void implies
						(header.content_type.boundary /= Void and then
						 not header.content_type.boundary.is_empty))
		end


feature -- Body creation/removal

	clear_body is
			-- Set `body' to Void.
		do
			body := Void
			multipart_body := Void
			text_body := Void
		ensure
			body_void: body = Void
		end

	create_multipart_body is
			-- Set `body' to a container.
		require
			body_not_set: body = Void
		do
			create multipart_body.make (header)
			body := multipart_body
		ensure
			body_not_void: body /= Void
			body_is_multipart: body.is_multipart
			multipart_body_set: multipart_body = body
		end

	create_singlepart_body is
			-- Set `body' to a single part body.
			-- If we find a Content-Disposition field with a filename
			-- parameter, body data wil be saved to a temporary file when
			-- set, insted of kept in memory.
		require
			body_not_set: body = Void
		local
			cd: EPX_MIME_FIELD_CONTENT_DISPOSITION
		do
			cd := header.content_disposition
			if cd = Void then
				text_body := new_string_body
			else
				if cd.parameters.has (parameter_name_filename) then
					text_body := new_file_body
				else
					text_body := new_string_body
				end
			end
			body := text_body
		ensure
			body_not_void: body /= Void
			body_is_singlepart: not body.is_multipart
			text_body_set: text_body = body
		end

	create_base64_body is
			-- Create a single part body whose content is base 64
			-- encoded when writing to it.
		require
			transfer_encoding_not_set: not header.fields.has (field_name_content_transfer_encoding)
		local
			cte: EPX_MIME_FIELD_CONTENT_TRANSFER_ENCODING
			encoder: KL_PROXY_CHARACTER_OUTPUT_STREAM
		do
			create cte.make_base64
			header.add_field (cte)
			create_singlepart_body
			encoder := cte.new_encoder (text_body.output_stream)
			if encoder /= Void then
				text_body.set_encoder (encoder)
			end
		end


feature -- Change

	set_auto_insert_content_length (a_value: BOOLEAN) is
			-- Set if Content-Length fields should be automatically
			-- supplied, if onen doesn't exist, in `append_to_string'.
		do
			auto_insert_content_length := a_value
		ensure
			definition: auto_insert_content_length = a_value
		end


feature {NONE} -- Implementation

	new_file_body: EPX_MIME_BODY_TEXT is
			-- New body where data is hold on disk
		do
			create {EPX_MIME_BODY_FILE} Result.make
		ensure
			not_void: Result /= Void
		end

	new_string_body: EPX_MIME_BODY_TEXT is
			-- New body where data is held in a string
		do
			create {EPX_MIME_BODY_STRING} Result.make
		ensure
			not_void: Result /= Void
		end


feature {NONE} -- Once strings

	once_crlf: STRING is "%R%N"


invariant

	header_not_void: header /= Void
	bodies_in_sync:
		body /= Void implies
			(body.is_multipart = (multipart_body /= Void)) and
			(not body.is_multipart = (text_body /= Void))

end
