note

	description:

		"Use eposix MIME parser to parse input"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2012, Berend de Boer"
	license: "MIT License (see LICENSE)"


class

	EPX_WSF_MULTIPART_FORM_DATA_HANDLER


inherit

	WSF_MIME_HANDLER

	WSF_MIME_HANDLER_HELPER


feature -- Status report

	valid_content_type (a_content_type: READABLE_STRING_8): BOOLEAN
		do
			Result := a_content_type.same_string ({HTTP_MIME_TYPES}.multipart_form_data)
		end


feature -- Execution

	handle (a_content_type: READABLE_STRING_8; req: WSF_REQUEST;
				a_vars: HASH_TABLE [WSF_VALUE, READABLE_STRING_32]; a_raw_data: detachable CELL [detachable STRING_8])
		local
			parser: EPX_MIME_PARSER
			input: EPX_WGI_FASTCGI_INPUT_STREAM
			cgi_data: DS_HASH_TABLE [EPX_KEY_VALUE, STRING]
		do
			input ?= req.input
			parser := new_parser (input)
			parser.set_header (mime_header (a_content_type))
			parser.parse
			if not parser.syntax_error then
				if parser.part.body.is_multipart then
					cgi_data := epx_url_encoder.mime_encoded_to_field_name_value_pair (Void, parser.part.body)
				else
					create cgi_data.make (0)
				end
				from
					cgi_data.start
				until
					cgi_data.after
				loop
					add_string_value_to_table (cgi_data.item_for_iteration.key, cgi_data.item_for_iteration.value, a_vars)
					cgi_data.forth
				end
			else
				-- TODO: error handling
				--exceptions.raise ("Syntax error detected during parsing of POSTed data.")
				req.error_handler.add_custom_error (0, "Syntax error", "Syntax error detected during parsing of POSTed data.")
			end

		end


feature {NONE} -- Implementation

	new_parser (an_input: EPX_CHARACTER_INPUT_STREAM): EPX_MIME_PARSER
			-- A new MIME parser
		require
			input_not_void: an_input /= Void
			input_open: an_input.is_open_read
		do
			create Result.make_from_stream (an_input)
		ensure
			not_void: Result /= Void
		end

	mime_header (a_content_type: STRING): STRING
			-- Suitable MIME header for POST data
		require
			content_type_not_empty: a_content_type /= Void and then not a_content_type.is_empty
		local
			fixed_content_type: STRING
			i: INTEGER
			value_start,
			value_end: INTEGER
		do
			-- Opera contains a boundary parameter with invalid characters.
			-- Fix this by making sure the boundary parameter is properly quoted.
			create fixed_content_type.make_from_string (a_content_type)
			i := fixed_content_type.substring_index ("boundary=", 1)
			if i /= 0 then
				value_start := i + 9
				if value_start <= fixed_content_type.count then
					if fixed_content_type.item (value_start) /= '"' then
						fixed_content_type.insert_character ('"', value_start)
						from
							value_end := value_start
						until
							value_end > fixed_content_type.count or else
							fixed_content_type.item (value_end) = ' ' or else
							fixed_content_type.item (value_end) = ';' or else
							fixed_content_type.item (value_end) = '%T' or else
							fixed_content_type.item (value_end) = '%N' or else
							fixed_content_type.item (value_end) = '%R'
						loop
							value_end := value_end + 1
						end
						if value_end > fixed_content_type.count then
							fixed_content_type.append_character ('"')
						else
							fixed_content_type.insert_character ('"', value_end)
						end
					end
				end
			end
			create Result.make ({HTTP_HEADER_NAMES}.header_content_type.count + 2 + fixed_content_type.count + 4)
			Result.append_string ({HTTP_HEADER_NAMES}.header_content_type)
			Result.append_character (':')
			Result.append_character (' ')
			Result.append_string (fixed_content_type)
			Result.append_character ('%R')
			Result.append_character ('%N')
			Result.append_character ('%R')
			Result.append_character ('%N')
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	epx_url_encoder: EPX_URL_ENCODING
			-- Decoding of encoded passed values
		once
			create Result
		ensure
			not_void: Result /= Void
		end


end
