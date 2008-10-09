indexing

	description: "Headers for a MIME message or MIME part."

	library: "epoxis library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"


class

	EPX_MIME_HEADER


inherit

	ANY

	EPX_MIME_TYPE_NAMES
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

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		end

create

	make_default


feature -- Initialization

	make_default is
			-- Make MIME header with no fields. Useful during parsing to
			-- construct the message gradually.
		local
			equality_tester: KL_STRING_EQUALITY_TESTER
		do
			create all_fields.make
			create fields.make (64)
			create equality_tester
			fields.set_key_equality_tester (equality_tester)
		end


feature -- Measurement

	count: INTEGER is
			-- The number of fields in this header.
		do
			Result := all_fields.count
		end


feature -- Status report

	found: BOOLEAN is
			-- Did last call to `search' succeed?
		do
			Result := fields.found
		end

	found_item: EPX_MIME_FIELD is
			-- Item found by last call to `search'
		require
			found: found
		do
			Result := fields.found_item
		end

	has (a_field_name: STRING): BOOLEAN is
			-- Does `a_field_name' exists just once in the header?
			-- Be aware that the comparison is case-sensitive unfortunately.
		require
			a_field_name_not_empty: a_field_name /= Void and then not a_field_name.is_empty
		do
			Result := fields.has (a_field_name)
		end


feature -- Access

	all_fields: DS_LINKED_LIST [EPX_MIME_FIELD]
			-- All fields in this header

	fields: DS_HASH_TABLE [EPX_MIME_FIELD, STRING]
			-- All fields that appeared just once in this MIME
			-- message;
			-- Add/delete fields by calling `add_field' and
			-- `delete_field'. Never modify this structure directly!

	item (a_field_name: STRING): EPX_MIME_FIELD is
			-- Field corresponding to `a_field_name' if it exists
			-- just once in the header
		require
			has_item: has (a_field_name)
		do
			Result := fields.item (a_field_name)
		ensure
			found: Result /= Void
		end


feature -- Access to well-known fields

	content_length: EPX_MIME_FIELD_CONTENT_LENGTH
			-- Field `Content-Length' if it exists, else Void

	content_disposition: EPX_MIME_FIELD_CONTENT_DISPOSITION
			-- Field `Content-Disposition' if it exists, else Void

	content_transfer_encoding: EPX_MIME_FIELD_CONTENT_TRANSFER_ENCODING
			-- Field `Content-Transfer-Encoding' if it exists, else Void

	content_type: EPX_MIME_FIELD_CONTENT_TYPE
			-- Field `Content-Type' if it exists, else Void

	transfer_encoding: EPX_MIME_FIELD_TRANSFER_ENCODING
			-- Field `Transfer-Encoding' if it exists, else Void


feature -- Change

	set_content_length (a_bytes: INTEGER) is
			-- Set Content-Length.
		require
			bytes_not_negative: a_bytes >= 0
		local
			field: EPX_MIME_FIELD_CONTENT_LENGTH
		do
			if content_length = Void then
				create field.make (a_bytes)
				add_field (field)
			else
				content_length.set_length (a_bytes)
			end
		ensure
			content_length_set: content_length /= Void
			length_set: content_length.length = a_bytes
		end


feature {NONE} -- Set well-known fields

	set_cached_field (a_field: EPX_MIME_FIELD) is
			-- Make some often used fields more easily available.
		do
			if STRING_.same_string (a_field.name, field_name_content_length) then
				content_length ?= a_field
			elseif STRING_.same_string (a_field.name, field_name_content_disposition) then
				content_disposition ?= a_field
			elseif STRING_.same_string (a_field.name, field_name_content_transfer_encoding) then
				content_transfer_encoding ?= a_field
			elseif STRING_.same_string (a_field.name, field_name_content_type) then
				content_type ?= a_field
			elseif STRING_.same_string (a_field.name, field_name_transfer_encoding) then
				transfer_encoding ?= a_field
			end
		end


feature -- Search

	search (a_field_name: STRING) is
			-- Search if `a_field_name' is a unique field name.
			-- If found, set `found' to true, and set
			-- `found_item' to the found field.
		require
			a_field_name_not_empty: a_field_name /= Void and then not a_field_name.is_empty
		do
			fields.search (a_field_name)
		end


feature -- Change

	add_field (a_field: EPX_MIME_FIELD) is
			-- Append `a_field' to header. `a_field' must not already exist.
		require
			a_field_not_void: a_field /= Void
			field_not_exists: not has (a_field.name)
		do
			all_fields.put_last (a_field)
			fields.put_last (a_field, a_field.name)
			set_cached_field (a_field)
		ensure
			field_added_to_fields: fields.has (a_field.name)
			field_added_to_all_fields: all_fields.has (a_field)
			field_is_last: all_fields.last = a_field
		end

	add_non_unique_field (a_field: EPX_MIME_FIELD) is
			-- Append `a_field' to header. There may already exist a
			-- field with this name.
		require
			a_field_not_void: a_field /= Void
		do
			all_fields.put_last (a_field)
			fields.put_last (a_field, a_field.name)
			set_cached_field (a_field)
		ensure
			field_added_to_fields: fields.has (a_field.name)
			field_added_to_all_fields: all_fields.has (a_field)
			field_is_last: all_fields.last = a_field
		end

	delete_field (a_field_name: STRING) is
			-- Remove the unique field with name `a_field_name'.
		require
			has_field: has (a_field_name)
		local
			field: EPX_MIME_FIELD
		do
			field := item (a_field_name)
			all_fields.delete (field)
			fields.remove (a_field_name)
			if a_field_name.is_equal (field_name_content_length) then
				content_length := Void
			elseif a_field_name.is_equal (field_name_content_disposition) then
				content_disposition := Void
			elseif a_field_name.is_equal (field_name_content_transfer_encoding) then
				content_transfer_encoding := Void
			elseif a_field_name.is_equal (field_name_content_type) then
				content_type := Void
			elseif a_field_name.is_equal (field_name_transfer_encoding) then
				transfer_encoding := Void
			end
		ensure
			field_removed: not has (a_field_name)
		end


feature -- Change specific fields

	set_content_type (a_type, a_subtype, a_charset: STRING) is
			-- Set `content_type' to `a_type'/`a_subtype'.
			-- Optionally set the the character set of `a_charset' is not
			-- Void or not empty.
		require
			type_not_empty: a_type /= Void and then not a_type.is_empty
			subtype_not_empty: a_subtype /= Void and then not a_subtype.is_empty
		local
			field: EPX_MIME_FIELD_CONTENT_TYPE
		do
			if content_type = Void then
				create field.make (a_type, a_subtype)
				add_field (field)
			else
				content_type.make (a_type, a_subtype)
			end
			if a_charset /= Void and then not a_charset.is_empty then
				content_type.set_parameter (parameter_name_charset, a_charset)
			end
		ensure
			content_type_set: content_type /= Void
			content_type_is_text_html:
				STRING_.same_string (content_type.type, a_type) and then
				STRING_.same_string (content_type.subtype, a_subtype)
		end

	set_content_type_text_html_utf8 is
			-- Set Content-Type to text/html. Character set is set to
			-- UTF-8.
		do
			set_content_type (mime_type_text, mime_subtype_html, charset_utf8)
		ensure
			content_type_set: content_type /= Void
			content_type_is_text_html:
				STRING_.same_string (content_type.type, mime_type_text) and then
				STRING_.same_string (content_type.subtype, mime_subtype_html)
			charset_is_utf8:
				content_type.parameters.has (parameter_name_charset) and then
				STRING_.same_string (content_type.parameters.item (parameter_name_charset).value, charset_utf8)
		end

	set_content_type_text_plain is
		obsolete "2008-03-17: please use set_content_type_text_plain_utf8"
		do
			set_content_type_text_plain_utf8
		end

	set_content_type_text_plain_utf8 is
			-- Set Content-Type to text/plain. Character set is set to
			-- UTF-8.
		do
			set_content_type (mime_type_text, mime_subtype_plain, charset_utf8)
		ensure
			content_type_set: content_type /= Void
			content_type_is_text_plain:
				STRING_.same_string (content_type.type, mime_type_text) and then
				STRING_.same_string (content_type.subtype, mime_subtype_plain)
			charset_is_utf8:
				content_type.parameters.has (parameter_name_charset) and then
				STRING_.same_string (content_type.parameters.item (parameter_name_charset).value, charset_utf8)
		end


feature -- Output

	append_fields_to_string (s: STRING) is
			-- Stream `fields' to `s' Does not add the body separator.
		require
			s_not_void: s /= Void
		do
			from
				all_fields.start
			until
				all_fields.after
			loop
				all_fields.item_for_iteration.append_to_string (s)
				all_fields.forth
			end
		end

	as_string: STRING is
			-- Header in readable format;
			--  Does not include the body separator.
		do
			create Result.make (1024)
			append_fields_to_string (Result)
		ensure
			not_void: Result /= Void
		end


feature {NONE} -- Implementation

	fields_and_all_fields_are_in_sync: BOOLEAN is
			-- Are `all_fields' and `fields' synchronized?
			-- Every field in `fields' should appear in `all_fields' and
			-- every field name in `all_fields' should appear in
			-- `fields'.
		local
			c: DS_LINEAR_CURSOR [EPX_MIME_FIELD]
		do
			Result := True
			-- All `fields' are in `all_fields'?
			c := fields.new_cursor
			from
				c.start
			until
				not Result or else
				c.after
			loop
				Result := all_fields.has (c.item)
				c.forth
			end
			if Result then
				-- Every field name in `all_fields' is in `fields?'
				c := all_fields.new_cursor
				from
					c.start
				until
					not Result or else
					c.after
				loop
					Result := fields.has (c.item.name)
					c.forth
				end
			end
		end


invariant

	fields_not_void: fields /= Void
	all_fields_not_void: all_fields /= Void
	content_length_set: fields.has (field_name_content_length) = (content_length /= Void)
	content_disposition_set: fields.has (field_name_content_disposition) = (content_disposition /= Void)
	content_transfer_encoding_set: fields.has (field_name_content_transfer_encoding) = (content_transfer_encoding /= Void)
	content_type_set: fields.has (field_name_content_type) = (content_type /= Void)
	transfer_encoding_set: fields.has (field_name_transfer_encoding) = (transfer_encoding /= Void)
	fields_and_all_fields_are_in_sync: fields_and_all_fields_are_in_sync

end
