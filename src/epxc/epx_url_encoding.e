indexing

	description: "Routines to encode and decode the mime and x-www-form-urlencoded key/value pairs."

	thanks: "Dustin Sallings for the decoding routines."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"

class

	EPX_URL_ENCODING


inherit

	UT_URL_ENCODING

	EPX_OCTET_ENCODING
		export
			{NONE} all
		end

	EPX_STRING_HELPER
		export
			{NONE} all
		end

	EPX_MIME_FIELD_NAMES
		export
			{NONE} all
		end

	EPX_MIME_PARAMETER_NAMES
		export
			{NONE} all
		end


feature -- Encode/decode field name/value pairs

	mime_encoded_to_field_name_value_pair (name: STRING; body: EPX_MIME_BODY): DS_HASH_TABLE [EPX_KEY_VALUE, STRING] is
			-- Transform a multipart/form-data body to a hash table of
			-- field-names and values.
			-- If a body is not of the proper format, it is skipped.
		require
			body_not_void: body /= Void
			multipart_body: body.is_multipart
		local
			sub_part: EPX_MIME_PART
			sub_keys: DS_HASH_TABLE [EPX_KEY_VALUE, STRING]
			text_body: EPX_MIME_BODY_TEXT
			file_body: EPX_MIME_BODY_FILE
			parameter: EPX_MIME_PARAMETER
			keyname,
			keyvalue: STRING
			i: INTEGER
			kv: EPX_KEY_VALUE
			temporary_file: EPX_CHARACTER_IO_STREAM
			ct: EPX_MIME_FIELD_CONTENT_DISPOSITION
			equality_tester: UC_STRING_EQUALITY_TESTER
		do
			create equality_tester
			create Result.make (body.parts_count)
			Result.set_key_equality_tester (equality_tester)
			from
				i := 1
			until
				i > body.parts_count
			loop
				sub_part := body.part (i)

				-- we take care by checking if mime message is
				-- according to the specs. It should have a
				-- Content-Disposition field with value "form-data".
				-- Every body part that does not have this field, is skipped.
				-- The name parameter can be absent in case of multiple
				-- uploaded files
				ct := sub_part.header.content_disposition
				if ct /= Void and then STRING_.same_string (ct.value, once_form_data) then
					parameter := ct.name_parameter
					if
						(parameter /= Void and then not parameter.value.is_empty) or else
						name /= Void
					then
						if parameter /= Void then
							keyname := parameter.value
						else
							keyname := name
						end

						-- if multipart (multiple uploaded files), recurse
						-- else singlepart with value
						if sub_part.body.is_multipart then
							sub_keys := mime_encoded_to_field_name_value_pair (keyname, sub_part.body)
							if Result.capacity < Result.count + sub_keys.count then
								Result.resize (Result.count + sub_keys.count)
							end
							from
								sub_keys.start
							until
								sub_keys.after
							loop
								kv := sub_keys.item_for_iteration
								Result.put (kv, kv.key)
								sub_keys.forth
							end
						else
							ct.parameters.search (parameter_name_filename)
							if ct.parameters.found then
								parameter := ct.parameters.found_item
							else
								parameter := Void
							end
							if parameter /= Void and then not parameter.value.is_empty then
								keyvalue := remove_directory_part (parameter.value)
								file_body ?= sub_part.body
								if file_body /= Void then
									temporary_file := file_body.file
								end
							else
								text_body ?= sub_part.body
								keyvalue := text_body.as_string
							end
							create kv.make (keyname, keyvalue)
							if temporary_file /= Void then
								kv.set_file (temporary_file)
								temporary_file := Void
							end
							Result.put (kv, kv.key)
						end
					end
				end
				i := i + 1
			end
		end

	url_encoded_to_field_name_value_pair (urlencoded: STRING): DS_HASH_TABLE [EPX_KEY_VALUE, STRING] is
			-- Transform a form-urlencoded string to a hash table of
			-- field-names and values. Invalid entries are skipped silently.
		require
			urlencoded_not_void: urlencoded /= Void
		do
			Result := do_url_encoded_to_field_name_value_pair (urlencoded, '&')
		ensure
			key_value_pair_not_void: Result /= Void
			key_value_pair_not_filled: urlencoded.is_empty implies Result.is_empty
		end

	do_url_encoded_to_field_name_value_pair (urlencoded: STRING; a_split_on: CHARACTER): DS_HASH_TABLE [EPX_KEY_VALUE, STRING] is
			-- Transform a form-urlencoded string to a hash table of
			-- field-names and values. Invalid entries are skipped silently.
		require
			urlencoded_not_void: urlencoded /= Void
		local
			mya, myb: ARRAY [STRING]
			s: STRING
			kv: EPX_KEY_VALUE
			i: INTEGER
			equality_tester: UC_STRING_EQUALITY_TESTER
			field_name: STRING
		do
			create equality_tester
			if urlencoded.is_empty then
				create Result.make_default
				Result.set_key_equality_tester (equality_tester)
			else
				mya := split_on (urlencoded, a_split_on)
				create Result.make (mya.count) -- good enough hash table distribution??
				Result.set_key_equality_tester (equality_tester)
				from
					i := mya.lower
				until
					i > mya.upper
				loop
					s := mya.item (i)
					myb := split_on (s, '=')
					-- If `myb' is invalid, just skip this field.
					if myb.count = 2 then
						-- Remove leading spaces, needed for cookie splitting.
						-- Not sure if this is correct.
						field_name := myb.item (myb.lower)
						field_name.left_adjust
						create kv.make (
							unescape_string (field_name),
							unescape_string (myb.item (myb.upper)))
						Result.put (kv, kv.key)
					end
					i := i + 1
				end
			end
		ensure
			key_value_pair_not_void: Result /= Void
			key_value_pair_not_filled: urlencoded.is_empty implies Result.is_empty
		end


feature {NONE} -- Microsoft Internet Explorer stuff

	remove_directory_part (filename: STRING): STRING is
			-- IE sends full path instead of just filename as everybody
			-- else does. Of course, that isn't a security hole...
		require
			filename_not_void: filename /= Void
		local
			path: STDC_PATH
		do
			create path.make_from_string (filename)
			path.parse (Void)
			path.set_directory (Void)
			Result := path
		ensure
			remove_directory_part_not_void: Result /= Void
		end


feature {NONE} -- Once strings

	once_form_data: STRING is "form-data"

end
