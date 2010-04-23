indexing

	description:

		"MIME header with specific functionality for a (Fast)CGI program"

	library: "epoxis library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_MIME_CGI_HEADER


inherit

	EPX_MIME_HTTP_HEADER

	EPX_HTTP_RESPONSE
		export
			{NONE} all;
			{ANY} is_three_digit_response
		end

	EPX_MIME_PARAMETER_NAMES
		export
			{NONE} all
		end

	EPX_MIME_TYPE_NAMES
		export
			{NONE} all
		end


create

	make_default


feature -- Access

	status_code: INTEGER is
			-- Three digit status code if any, else zero
		local
			f: EPX_MIME_FIELD_STATUS
		do
			f := status_field
			if f /= Void then
				Result := f.status_code
			end
		end


feature -- Access to well-known fields

	last_modified_field: EPX_MIME_FIELD_LAST_MODIFIED is
			-- Field `Last_Modified' if it exists, else Void.
		do
			fields.search (field_name_last_modified)
			if fields.found then
				Result ?= fields.found_item
			end
		ensure
			definition: fields.has (field_name_last_modified) = (Result /= Void)
		end

	location_field: EPX_MIME_UNSTRUCTURED_FIELD is
			-- Field `Location' if it exists, else Void.
		do
			fields.search (field_name_location)
			if fields.found then
				Result ?= fields.found_item
			end
		ensure
			definition: fields.has (field_name_location) = (Result /= Void)
		end

	status_field: EPX_MIME_FIELD_STATUS is
			-- Field `Status' if it exists, else Void.
		do
			fields.search (field_name_status)
			if fields.found then
				-- Oops, this may fail if user tricks us...
				Result ?= fields.found_item
			end
		ensure
			definition: fields.has (field_name_status) = (Result /= Void)
		end


feature -- Change

	set_content_type_application_xml is
			-- Set Content-Type to application/xml. Character set is set to
			-- UTF-8.
		do
			set_content_type (mime_type_application, mime_subtype_xml, charset_utf8)
		ensure
			content_type_set: content_type /= Void
			content_type_is_text_xml:
				STRING_.same_string (content_type.type, mime_type_application) and then
				STRING_.same_string (content_type.subtype, mime_subtype_xml)
			charset_is_utf8:
				content_type.parameters.has (parameter_name_charset) and then
				STRING_.same_string (content_type.parameters.item (parameter_name_charset).value, charset_utf8)
		end

	set_content_type_text_xml is
			-- Set Content-Type to text/xml. Character set is set to
			-- UTF-8.
		obsolete
			"2010-03-20: please use `set_content_type_application_xml'"
		do
			set_content_type (mime_type_text, mime_subtype_xml, charset_utf8)
		ensure
			content_type_set: content_type /= Void
			content_type_is_text_xml:
				STRING_.same_string (content_type.type, mime_type_text) and then
				STRING_.same_string (content_type.subtype, mime_subtype_xml)
			charset_is_utf8:
				content_type.parameters.has (parameter_name_charset) and then
				STRING_.same_string (content_type.parameters.item (parameter_name_charset).value, charset_utf8)
		end

	set_last_modified (a_dt: STDC_TIME) is
		require
			dt_not_void: a_dt /= Void
		local
			last_modified: EPX_MIME_FIELD_LAST_MODIFIED
		do
			last_modified := last_modified_field
			if last_modified = Void then
				create last_modified.make (a_dt)
				add_field (last_modified)
			else
				last_modified.make (a_dt)
			end
		end

	set_location (a_url: STRING) is
			-- Redirect to `a_url' by emitting a Location header.
			-- This is used to specify to the server that you are
			-- returning a reference to a document rather than an actual
			-- document.
			-- If the argument to this is a URL, the server will issue a
			-- redirect to the client.
			-- If the argument to this is a virtual path, the server will
			-- retrieve the document specified as if the client had
			-- requested that document originally. ? directives will work
			-- in here, but # directives must be redirected back to the
			-- client.
			-- If you return a status as well, it must be 200 it seems.
		require
			a_url_not_empty: a_url /= Void and then not a_url.is_empty
		local
			field: EPX_MIME_UNSTRUCTURED_FIELD
		do
			field := location_field
			if field = Void then
				create field.make (field_name_location, a_url)
				add_field (field)
			else
				field.set_value (a_url)
			end
		ensure
			location_field_set: location_field /= Void
			location_set: STRING_.same_string (location_field.value, a_url)
		end

	set_status (a_status_code: INTEGER; a_reason: STRING) is
			-- Set the status code sent back to the client.
			-- This is used to give the server an HTTP/1.0 status line to
			-- send to the client. The format is nnn xxxxx, where nnn is
			-- the 3-digit status code, and xxxxx is the reason string,
			-- such as "Forbidden".
			-- If `a_reason' is Void or empty, the default reason is used.
		require
			valid_status_code: is_three_digit_response (a_status_code)
		local
			field: EPX_MIME_FIELD_STATUS
		do
			field := status_field
			if field = Void then
				create field.make (a_status_code, a_reason)
				add_field (field)
			else
				field.set_status (a_status_code, a_reason)
			end
		ensure
			status_field_set: status_field /= Void
			status_set: status_field.status_code = a_status_code
		end


end
