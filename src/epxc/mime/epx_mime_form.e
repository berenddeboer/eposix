note

	description:

		"MIME part that makes creating HTML form input for an HTTP POST or PUT request easier."

	bugs: "Boundary created by make_from_data is not guaranteed to be unique."
	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"


class

	EPX_MIME_FORM


inherit

	EPX_MIME_PART

	KL_ARRAY_ROUTINES [EPX_KEY_VALUE]
		export
			{NONE} all
		end

	UT_URL_ENCODING
		export
			{NONE} all
		end


create

	make_empty,
	make_form_data,
	make_form_urlencoded


feature {NONE} -- Initialization

	make_form_data (a_key_value_pairs: ARRAY [EPX_KEY_VALUE])
			-- Create a MIME part that holds HTML form data using the
			-- multipart/form-data encoding as specified in RFC 2388.
		require
			key_value_pairs_not_void: a_key_value_pairs /= Void
			key_value_pairs_has_only_unique_keys: True -- I hope
			-- assume void-safe: key_value_pairs_has_no_void_values: not has (a_key_value_pairs, Void)
		local
			content_type: EPX_MIME_FIELD_CONTENT_TYPE
			content_disposition: EPX_MIME_FIELD_CONTENT_DISPOSITION
			-- main_body: EPX_MIME_BODY_MULTIPART
			input_part: EPX_MIME_PART
			kv: EPX_KEY_VALUE
			i: INTEGER
			time: STDC_TIME
		do
			make_empty
			-- TODO: this boundary might not be unique...
			create time.make_from_now
			create content_type.make_multipart (mime_subtype_form_data, "__=_the_boundary_" + time.value.out + "_" + current_process.random.out + "_=__")
			header.add_field (content_type)
			create_multipart_body
			if attached multipart_body as main_body then
				from
					i := a_key_value_pairs.lower
				until
					i > a_key_value_pairs.upper
				loop
					kv := a_key_value_pairs.item (i)
					input_part := main_body.new_part
					create content_disposition.make_name ("form-data", kv.key)
					input_part.header.add_field (content_disposition)
					input_part.create_singlepart_body
					if attached input_part.text_body as input_text then
						input_text.append_string (kv.value)
					end
					i := i + 1
				variant
					a_key_value_pairs.count - (i - a_key_value_pairs.lower)
				end
			end
		ensure
			multipart_body_not_void: attached multipart_body
			all_fields_in_body: attached multipart_body as b and then b.parts_count = a_key_value_pairs.count
		end

	make_form_urlencoded (a_key_value_pairs: ARRAY [EPX_KEY_VALUE])
			-- Create a MIME part that holds HTML form data using the
			-- application/x-www-form-urlencoded encoding.
		require
			key_value_pairs_not_void: a_key_value_pairs /= Void
			key_value_pairs_has_only_unique_keys: True -- I hope
			-- assume void-safe: key_value_pairs_has_no_void_values: not has (a_key_value_pairs, Void)
		local
			content_type: EPX_MIME_FIELD_CONTENT_TYPE
			kv: EPX_KEY_VALUE
			i: INTEGER
		do
			make_empty
			create content_type.make (mime_type_application, mime_subtype_x_www_form_urlencoded)
			header.add_field (content_type)
			create_singlepart_body
			if attached text_body as tb then
				from
					i := a_key_value_pairs.lower
				until
					i > a_key_value_pairs.upper
				loop
					kv := a_key_value_pairs.item (i)
					tb.append_string  (kv.key)
					tb.append_character ('=')
					tb.append_string (escape_string (kv.value))
					i := i + 1
					if i <= a_key_value_pairs.upper then
						tb.append_character  ('&')
					end
				variant
					a_key_value_pairs.count - (i - a_key_value_pairs.lower)
				end
			end
		ensure
			text_body_not_void: attached text_body
		end

end
