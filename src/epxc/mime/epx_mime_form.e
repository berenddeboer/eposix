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
			main_body: EPX_MIME_BODY_MULTIPART
			input_part: EPX_MIME_PART
			input_text: EPX_MIME_BODY_TEXT
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
			main_body := multipart_body
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
				input_text := input_part.text_body
				input_text.append_string (kv.value)
				i := i + 1
			variant
				a_key_value_pairs.count - (i - a_key_value_pairs.lower)
			end
		ensure
			multipart_body_not_void: multipart_body /= Void
			all_fields_in_body: multipart_body.parts_count = a_key_value_pairs.count
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
			from
				i := a_key_value_pairs.lower
			until
				i > a_key_value_pairs.upper
			loop
				kv := a_key_value_pairs.item (i)
				text_body.append_string  (kv.key)
				text_body.append_character ('=')
				text_body.append_string (escape_string (kv.value))
				i := i + 1
				if i <= a_key_value_pairs.upper then
					text_body.append_character  ('&')
				end
			variant
				a_key_value_pairs.count - (i - a_key_value_pairs.lower)
			end
		ensure
			text_body_not_void: text_body /= Void
		end

end
