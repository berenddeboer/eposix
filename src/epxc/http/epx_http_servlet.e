indexing

	description: "Class that can produce output for a certain resource (url). Like a CIG program, but compiled into the HTTP server."

	usage: "Preferably, a servlet should not send something straight to the client. It's better to build the header and body in a STRING and send it as one block."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


class

	EPX_HTTP_SERVLET


inherit

	EPX_XHTML_WRITER

	EPX_HTTP_METHODS
		export
			{NONE} all
		end

	EPX_MIME_FIELD_NAMES
		export
			{NONE} all
		end


create

	make


feature -- Access

	allow_cached_content: BOOLEAN
			-- Can content in `as_string' survive an activate/deactivate sequence?

	allowed_methods: STRING is
			-- What methods does the resource captured by this servlet
			-- allow?
			-- This is a comma-separated list, for example "HEAD,DELETE,GET,PUT"
		once
			Result := ""
		ensure
			allowed_methods_not_void: Result /= Void
		end

	resource_location: STRING
			-- Location of resource;
			-- Set by `activate'.


feature -- Status

	is_activated: BOOLEAN is
			-- Has `activate' been called?
		do
			Result := connection /= Void
		end


feature {EPX_HTTP_SERVER} -- Status

	are_request_form_fields_valid_for_delete (a_request_form_fields: DS_HASH_TABLE [EPX_KEY_VALUE, STRING]): BOOLEAN is
			-- Is data passed to this servlet enough to perform the delete request?
		do
			Result := True
		end

	are_request_form_fields_valid_for_get (a_request_form_fields: DS_HASH_TABLE [EPX_KEY_VALUE, STRING]): BOOLEAN is
			-- Is data passed to this servlet enough to perform the get request?
		do
			Result := True
		end

	are_request_form_fields_valid_for_head (a_request_form_fields: DS_HASH_TABLE [EPX_KEY_VALUE, STRING]): BOOLEAN is
			-- Is data passed to this servlet enough to perform the head request?
		do
			Result := True
		end

	are_request_form_fields_valid_for_post (a_request_form_fields: DS_HASH_TABLE [EPX_KEY_VALUE, STRING]): BOOLEAN is
			-- Is data passed to this servlet enough to perform the post request?
		do
			Result := True
		end

	are_request_form_fields_valid_for_put (a_request_form_fields: DS_HASH_TABLE [EPX_KEY_VALUE, STRING]): BOOLEAN is
			-- Is data passed to this servlet enough to perform the post request?
		do
			Result := True
		end


feature -- Start/stop

	shutdown is
			-- Send to every servlet when server goes down.
		do
			-- do nothing
		end


feature {EPX_HTTP_SERVER} -- Execution

	activate (a_connection: EPX_HTTP_CONNECTION; a_http_method, a_resource: STRING) is
			-- Called before the servlet is asked to produce output.
			-- Servlet is asked to act upon `a_resource' with method
			-- `a_http_method'.
		require
			not_activated: not is_activated
			no_tag_started: not allow_cached_content implies not is_tag_started
			empty_body: not allow_cached_content implies as_string.is_empty
			connection_not_void: a_connection /= Void
			connection_has_request_form_fields: a_connection.request_form_fields /= Void
			http_method_not_empty: a_http_method /= Void and then not a_http_method.is_empty
			a_resource_not_empty: a_resource /= Void and then not a_resource.is_empty
		do
			connection := a_connection
			resource_location := a_resource
			request_form_fields := connection.request_form_fields
		ensure
			activated: is_activated
		end

	deactivate is
			-- Called after servlet has done its work.
		require
			activated: is_activated
		do
			connection := Void
			request_form_fields := Void
			if not allow_cached_content then
				clear
			end
			resource_location := Void
		ensure
			not_activated: not is_activated
			no_tag_started: not allow_cached_content implies not is_tag_started
			empty_body: not allow_cached_content implies as_string.is_empty
		end

	delete_body is
			-- Write response body to DELETE request.
		require
			activated: is_activated
			body_not_send: not connection.is_body_send
			valid_data: are_request_form_fields_valid_for_delete (request_form_fields)
		do
			-- not implemented
		end

	delete_header is
			-- Write response header to DELETE request. You have to
			-- write everything, including the response code.
		require
			activated: is_activated
			valid_data: are_request_form_fields_valid_for_delete (request_form_fields)
		do
			connection.report_method_not_allowed (http_method_DELETE, allowed_methods)
		end

	get_body is
			-- Write response body to GET request.
		require
			activated: is_activated
			body_not_send: not connection.is_body_send
			valid_data: are_request_form_fields_valid_for_get (request_form_fields)
		do
			-- not implemented
		end

	get_header is
			-- Write response header to GET request. You have to
			-- write everything, including the response code.
		require
			activated: is_activated
			valid_data: are_request_form_fields_valid_for_get (request_form_fields)
		do
			connection.report_method_not_allowed (http_method_GET, allowed_methods)
		ensure
			no_body_separator_added:
				not connection.is_header_send implies
					not connection.response_header_ends_with_body_separator
		end

	head_header is
			-- Write response header to HEAD request. You have to
			-- write everything, including the response code.
		require
			activated: is_activated
			valid_data: are_request_form_fields_valid_for_head (request_form_fields)
		do
			connection.report_method_not_allowed (http_method_HEAD, allowed_methods)
		end

	post_body is
			-- Write response body to POST request.
		require
			activated: is_activated
			body_not_send: not connection.is_body_send
			valid_data: are_request_form_fields_valid_for_post (request_form_fields)
		do
			-- not implemented
		end

	post_header is
			-- Write response header to POST request. You have to
			-- write everything, including the response code.
		require
			activated: is_activated
			valid_data: are_request_form_fields_valid_for_post (request_form_fields)
		do
			connection.report_method_not_allowed (http_method_POST, allowed_methods)
		end

	put_body is
			-- Write response body to PUT request.
		require
			activated: is_activated
			body_not_send: not connection.is_body_send
			valid_data: are_request_form_fields_valid_for_put (request_form_fields)
		do
			-- not implemented
		end

	put_header is
			-- Write response header to PUT request. You have to
			-- write everything, including the response code.
		require
			activated: is_activated
			valid_data: are_request_form_fields_valid_for_put (request_form_fields)
		do
			connection.report_method_not_allowed (http_method_PUT, allowed_methods)
		end

	request_form_fields: DS_HASH_TABLE [EPX_KEY_VALUE, STRING]
			-- Data passed to this servlet, either as part of a dynamic
			-- path, as query parameter or as form input

	connection: EPX_HTTP_CONNECTION
			-- Connection which this servlet  currently serves

	server: EPX_HTTP_CONNECTION is
		obsolete "2006-02-06: Use `connection' instead"
		do
			Result := connection
		end


feature {NONE} -- Header

	add_content_length is
			-- Add a Content-Length header based on the currently
			-- generated XML in `as_uc_string'.
			-- Assume output is written as UTF-8.
		require
			header_not_send: not connection.is_header_send
		do
			connection.add_field (field_name_content_length, as_uc_string.byte_count.out)
		end

	write_default_header is
			-- If you implement an XXXX_header method, a call to this
			-- routine will suffice in most cases.
			-- The header will not add the separator and is not send to
			-- the client (this is usually done by the HTTP server when
			-- the servlet returns).
			-- This also means that you can call this feature after you
			-- have generated the body for example.
		require
			activated: is_activated
			response_header_empty: connection.response_header.is_empty
		do
			connection.write_response_code (200)
			connection.write_mime_header (Void)
		ensure
			header_has_no_body_separator: not connection.response_header_ends_with_body_separator
		end


feature {NONE} -- Values

	adjusted_item (a_key: STRING): STRING is
			-- Value defined for `a_key' if it exists, else the empty string.
			-- Item is left and right trimmed for spaces, tabs, LF's and CR's.
		require
			key_not_empty: a_key /= Void and then not a_key.is_empty
			request_form_fields_not_void: request_form_fields /= Void
		local
			i: INTEGER
		do
			Result := item (a_key)
			if not Result.is_empty then
				-- right adjust
				Result := Result.twin
				from
					i := Result.count
				variant
					i
				until
					i < 1 or else
					not blanks.has (Result.item (i))
				loop
					i := i - 1
				end
				Result.keep_head (i)
				-- left adjust
				if not Result.is_empty then
					from
						i := 1
					variant
						Result.count - i
					until
						i > Result.count or else
						not blanks.has (Result.item (i))
					loop
						i := i + 1
					end
					Result.keep_tail ((Result.count - i) + 1)
				end
			end
		ensure
			item_not_void: Result /= Void
			value_returned:
				request_form_fields.has (a_key) implies
					request_form_fields.item (a_key).value.has_substring (Result)
			empty_string_returned:
				not request_form_fields.has (a_key) implies
					Result.is_empty
			does_not_start_with_a_blank: not Result.is_empty implies not blanks.has (Result.item (1))
			does_not_end_with_a_blank: not Result.is_empty implies not blanks.has (Result.item (Result.count))
		end

	item (a_key: STRING): STRING is
			-- Value defined for `a_key' if it exists, else the empty string.
		require
			key_not_empty: a_key /= Void and then not a_key.is_empty
			request_form_fields_not_void: request_form_fields /= Void
		do
			if request_form_fields.has (a_key) then
				Result := request_form_fields.item (a_key).value
			else
				Result := once_empty_string
			end
		ensure
			item_not_void: Result /= Void
			value_returned:
				request_form_fields.has (a_key) implies
					STRING_.same_string (request_form_fields.item (a_key).value, Result)
			empty_string_returned:
				not request_form_fields.has (a_key) implies
					Result.is_empty
		end


feature {NONE} -- Once strings

	once_empty_string: STRING is ""

	blanks: STRING is " %T%N%R"


invariant

	activate_implies_server: is_activated = (connection /= Void)
	activate_implies_resource_location:
		is_activated implies
			resource_location /= Void and then not resource_location.is_empty
	activate_implies_request_form_fields: is_activated implies request_form_fields /= Void
	request_form_fields_in_sync:
		is_activated implies connection.request_form_fields = request_form_fields

end
