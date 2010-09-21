indexing

	description: "Base class for simple CGI programs. Outputs XHTML."

	usage: "Implement `execute'. Never write to stdout, use `puts' or `add_data' instead."
	standards: "CGI draft spec 1.2: http://hoohoo.ncsa.uiuc.edu/cgi/interface.html"

	known_bugs:
		"[
1. Does not handle inputs with same name (checkboxes) correctly.
2. When Content-Type is specified QUERY_STRING is ignored for GET (and possibly all verbs). Should always parse QUERY_STRING.
]"

	todo:
		"1. should use binary search allowed_new_line_tag"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


deferred class

	EPX_CGI


inherit

	STDC_CURRENT_PROCESS

	EPX_XHTML_WRITER
		rename
			make as make_xhtml_writer
		end

	EPX_MIME_FIELD_NAMES
		export
			{NONE} all
		end

	EPX_HTTP_METHODS
		export
			{NONE} all
		end

	EPX_HTTP_RESPONSE


feature {NONE} -- Initialization

	make is
			-- Initialise, but handle any exceptions during execution in
			-- a more browser friendly way.
		do
			make_no_rescue
		rescue
			handle_fatal_error
		end

	make_no_rescue is
			-- Initialise without rescue clause so SmartEiffel prints the
			-- correct stack when the exception occurs.
		do
			make_xhtml_writer
			-- Buffer output, else because of unrolled loop in
			-- stderr.put_string only one byte at a time might appear in
			-- the log files.
			stderr.set_line_buffering (default_pointer, 1024)
			-- Same for output
			stdout.set_full_buffering (default_pointer, 4096)
			debug ("cgi")
				dump_input
				exit_with_failure
			end
			create header.make_default
			if is_valid_request_method then
				if is_authorized then
					-- Output can be accumulated in the XML string in case the
					-- output is text. In case the output is binary the
					-- `execute' method should write the header and output
					-- itself.
					stdout.set_full_buffering (default_pointer, 8192)
					execute
					-- Write output now.
					if not is_http_header_written then
						-- If header has not been written we may safely assume
						-- the body, if any is in `as_uc_string'.
						-- This is therefore a good time to write
						-- Content-Length if it has not been set, but we do
						-- that only if Content-Type has been set.
						if
							header.content_type /= Void and then
							header.content_length = Void
						then
							header.set_content_length (as_uc_string.byte_count)
						end
						finish_header
					end
					if not is_head_method then
						stdout.put_string (as_uc_string)
					end
				else
					error_unauthorized
				end
			else
				error_invalid_method
			end
		end


feature -- Output

	execute is
			-- Execute the CGI action by emiting a valid MIME header and
			-- an optional body.
			-- Header and/or body text can be accumulated in
			-- `as_uc_string' and will be send to the client when this
			-- feature returns.
			-- In case of binary output it is advised to write the header
			-- yourself (build it up in `header' and use `finish_header'
			-- to write it, and write the binary output straight to
			-- `stdout'.
		require
			is_valid_request_method
		deferred
		end


feature -- Error handling

	error_unauthorized is
			-- Signal authorization error to client.
		do
			-- Sometimes parameter checking takes place in
			-- `is_authorized', for example when the parameters are
			-- needed to check authorization. So only set 401 if no
			-- previous status code has been set.
			if header.status_code = 0 then
				header.set_status (401, Void)
			end
			finish_header
			stdout.put_string (as_uc_string)
		ensure
			header_written: is_http_header_written
		end

	error_invalid_method is
			-- Signal invalid method to client.
		do
			status (405, "Method " + request_method + " Not Allowed")
			finish_header
		ensure
			header_written: is_http_header_written
		end


feature {NONE} -- When script fails

	handle_fatal_error is
			-- Your last change to emit something when the script has
			-- failed unexpectedly. Call only in rescue clause.
		require
			is_exception: exceptions.exception /= 0
		do
			if not is_http_header_written then
				if header.status_code = 0 then
					stdout.put_string (once "Status: 500%N")
				else
					status (500, "Fatal error")
				end
				content_text_plain
			end
			stdout.put_string (once "A fatal error prevents this program from continuing.%N")
			if exceptions.is_developer_exception then
				stdout.put_string (once "The error message was: ")
				stdout.put_string (exceptions.developer_exception_name)
				stdout.put_character ('%N')
			end
			stdout.put_string (once "Exception code: ")
			stdout.put_string (exceptions.exception.out)
			stdout.put_character ('%N')
			stdout.flush
			exit_with_failure
		end


feature -- Debug support

	dump_input is
			-- Write cgi input to $TMPDIR/cgi_input.
			-- First line contains the content header, is not actually in input!
		local
			file: STDC_BINARY_FILE
			clen: INTEGER
			i: INTEGER
		do
			create file.create_write (file_system.temporary_directory + "/cgi_input")
			if request_method.is_equal (http_method_GET) then
				file.puts (query_string)
			else
				file.put_string (mime_header)
				from
					i := 0
					clen := content_length
				until
					stdin.end_of_input or else
					i >= clen
				loop
					stdin.get_character
					file.putc (stdin.last_byte)
					i := i + 1
				end
			end
			file.close
		end


feature -- Status

	is_authorized: BOOLEAN is
			-- May `request_method' be applied this resource?
			-- This method may implement any kind of authentication.
		do
			Result := True
		end

	is_delete_method: BOOLEAN is
			-- Is `request_method' equal to "DELETE"?
		do
			Result :=
				request_method.is_equal (http_method_DELETE) or else
				has_key (once_remapped_delete_method)
		end

	is_get_method: BOOLEAN is
			-- Is `request_method' equal to "GET"?
		do
			Result := request_method.is_equal (http_method_GET)
		end

	is_head_method: BOOLEAN is
			-- Is `request_method' equal to "GET"?
		do
			Result := request_method.is_equal (http_method_HEAD)
		end

	is_post_method: BOOLEAN is
			-- Is `request_method' equal to "POST"?
		do
			Result :=
				request_method.is_equal (http_method_POST) and then
				not (has_key (once_remapped_put_method) or else has_key (once_remapped_delete_method))
		end

	is_put_method: BOOLEAN is
			-- Is `request_method' equal to "PUT"?
		do
			Result :=
				request_method.is_equal (http_method_PUT) or else
				has_key (once_remapped_put_method)
		end

	is_http_header_written: BOOLEAN
			-- Has header been written to stdout?
			-- Such an action cannot be undone, and no more headers can
			-- be written.

	is_valid_key (a_key: STRING): BOOLEAN is
			-- Is `a_key' a valid key for `value' or `raw_value'?
		do
			Result := a_key /= Void and then not a_key.is_empty
		end

	is_valid_request_method: BOOLEAN is
			-- Is `request_method' valid for this CGI?
		do
			Result := True
		end


feature -- Access

	header: EPX_MIME_CGI_HEADER
			-- Response header


feature -- Standard CGI variables

	auth_type: STRING is
			-- Type of authentication used
		do
			Result := env_auth_type.value
		end

	content_type: STRING is
			-- MIME type of data when invoked with POST method
		do
			Result := env_content_type.value
		end

	content_length: INTEGER is
			-- Length, in bytes, of data when invoked with POST method
		do
			if env_content_length.value.is_empty then
				Result := 0
			else
				Result := env_content_length.value.to_integer
			end
		end

	gateway_interface: STRING is
			-- Name and version of the gateway, for example CGI/1.1
		do
			Result := env_gateway_interface.value
		end

	http_accept: STRING is
			-- Contents of the Accept header line sent by the client
		do
			Result := env_http_accept.value
		end

	http_cookie: STRING is
			-- All cookies sent by the client in the form of key=value,
			-- semi-colon separated
		do
			Result := env_http_cookie.value
		ensure
			http_cookie_not_void: Result /= Void
		end

	http_referer: STRING is
			-- Contents of the Referer header line
		do
			Result := env_http_referer.value
		end

	http_user_agent: STRING is
			-- Name of the client program that is making the request
		do
			Result := env_http_user_agent.value
		end

	path_info: STRING is
			-- Extra path information as it was passed to the server in
			-- the query URL
		do
			Result := env_path_info.value
		end

	path_translated: STRING is
			-- Extra path information translated to a final, usable
			-- form; the Web document root is prepended to the query
			-- path, and any other path translations are executed.
		do
			Result := env_path_translated.value
		end

	query_string: STRING is
			-- The input when invoked with the GET method
		do
			Result := env_query_string.value
		ensure
			query_string_not_void: Result /= Void
		end

	remote_addr: STRING is
		obsolete "Use `remote_address' instead"
		do
			Result := remote_address
		end

	remote_address: STRING is
			-- IP address of the client that made the request
		do
			Result := env_remote_addr.value
		end

	remote_host: STRING is
			-- Name of the remote computer that made the request
		do
			Result := env_remote_host.value
		end

	remote_ident: STRING is
			-- User name as given by the ident protocol
		do
			Result := env_remote_ident.value
		end

	remote_user: STRING is
			-- Name of the remote user, if any, that made the request
		once
			Result := env_remote_user.value
		ensure
			not_void: Result /= Void
		end

	request_method: STRING is
			-- Name of the method used to invoke the CGI application
		do
			Result := env_request_method.value
		end

	remapped_request_method: STRING is
			-- As `request_method' but if method remapping is enabled,
			-- return the remapped method
		do
			if is_get_method then
				Result := request_method
			elseif is_post_method then
				Result := request_method
			elseif is_put_method then
				Result := once "PUT"
			elseif is_delete_method then
				Result := once "DELETE"
			else
				Result := request_method
			end
		end

	script_name: STRING is
			-- Name of script that was invoked
		do
			Result := env_script_name.value
		end

	server_name: STRING is
			-- Domain name of the computer that is running the server software
		do
			Result := env_server_name.value
		end

	server_port: INTEGER is
			-- TCP port number on which the server that invoked the CGI
			-- application is operating
		local
			s: STRING
		do
			s := env_server_port.value
			if s.is_empty then
				Result := 0
			else
				Result := s.to_integer
			end
		end

	server_protocol: STRING is
			-- Name of the protocol that the server is using and the
			-- version of that protocol. The protocol name and version
			-- are separated by a forward slash with no spaces, for
			-- instance HTTP/1.0
		do
			Result := env_server_protocol.value
		end

	server_software: STRING is
			-- Name of the server that is handling the request
		do
			Result := env_server_software.value
		end


feature {NONE} -- CGI environment variables

	env_auth_type: STDC_ENV_VAR is
		once
			create Result.make ("AUTH_TYPE")
		end

	env_content_length: STDC_ENV_VAR is
		once
			create Result.make ("CONTENT_LENGTH")
		end

	env_content_type: STDC_ENV_VAR is
		once
			create Result.make ("CONTENT_TYPE")
		end

	env_gateway_interface: STDC_ENV_VAR is
		once
			create Result.make ("GATEWAY_INTERFACE")
		end

	env_http_accept: STDC_ENV_VAR is
		once
			create Result.make ("HTTP_ACCEPT")
		end

	env_http_cookie: STDC_ENV_VAR is
		once
			create Result.make ("HTTP_COOKIE")
		ensure
			env_http_cookie_not_void: Result /= Void
		end

	env_http_referer: STDC_ENV_VAR is
		once
			create Result.make ("HTTP_REFERER")
		end

	env_http_user_agent: STDC_ENV_VAR is
		once
			create Result.make ("HTTP_USER_AGENT")
		end

	env_path_info: STDC_ENV_VAR is
		once
			create Result.make ("PATH_INFO")
		end

	env_path_translated: STDC_ENV_VAR is
		once
			create Result.make ("PATH_TRANSLATED")
		end

	env_query_string: STDC_ENV_VAR is
		once
			create Result.make ("QUERY_STRING")
		end

	env_remote_addr: STDC_ENV_VAR is
		once
			create Result.make ("REMOTE_ADDR")
		end

	env_remote_host: STDC_ENV_VAR is
		once
			create Result.make ("REMOTE_HOST")
		end

	env_remote_user: STDC_ENV_VAR is
		once
			create Result.make ("REMOTE_USER")
		end

	env_remote_ident: STDC_ENV_VAR is
		once
			create Result.make ("REMOTE_IDENT")
		end

	env_request_method: STDC_ENV_VAR is
		once
			create Result.make ("REQUEST_METHOD")
		end

	env_script_name: STDC_ENV_VAR is
		once
			create Result.make ("SCRIPT_NAME")
		end

	env_server_name: STDC_ENV_VAR is
		once
			create Result.make ("SERVER_NAME")
		end

	env_server_port: STDC_ENV_VAR is
		once
			create Result.make ("SERVER_PORT")
		end

	env_server_protocol: STDC_ENV_VAR is
		once
			create Result.make ("SERVER_PROTOCOL")
		end

	env_server_software: STDC_ENV_VAR is
		once
			create Result.make ("SERVER_SOFTWARE")
		end


feature -- HTTP headers

	if_match: STRING is
			-- The contents of the If-Match header if set or if
			-- made available by the server;
			-- Void otherwise
			-- Bugs: If-Match: '*' not handled, has to be done manually.
		local
			env: STDC_ENV_VAR
		do
			create env.make (once "HTTP_IF_MATCH")
			if not env.value.is_empty then
				Result := env.value
			end
		end

	if_none_match: STRING is
			-- The contents of the If-None-Match header if set or if
			-- made available by the server;
			-- Void otherwise
			-- Bugs: If-None-Match: '*' not handled, has to be done manually.
		local
			env: STDC_ENV_VAR
		do
			create env.make (once "HTTP_IF_NONE_MATCH")
			if not env.value.is_empty then
				Result := env.value
			end
		end

		if_modified_since: STDC_TIME is
			-- The contents of the If-Modified-Since header if set or if
			-- made available by the server;
			-- Void otherwise
		local
			env: STDC_ENV_VAR
			v: STRING
			parser: EPX_MIME_PARSER
			date_field: EPX_MIME_FIELD_IF_MODIFIED_SINCE
		do
			create env.make (once "HTTP_IF_MODIFIED_SINCE")
			v := env.value
			if not v.is_empty then
				-- parse Tue, 13 Mar 2007 09:12:09 GMT
				create parser.make_from_string (field_name_if_modified_since + ": " + v + "%N%N")
				parser.parse_header
				if parser.part.header.has (field_name_if_modified_since) then
					date_field ?= parser.part.header.item (field_name_if_modified_since)
					Result := date_field.date_time
				end
			end
		end


feature -- CGI headers

	content_text_html is
			-- Write Content-Type: text/html to stdout.
			-- Clients will guess the charset, so it's better to use the
			-- explicit `context_text_html_utf8' function.
		do
			stdout.put_string (once "Content-Type: text/html%N")
			finish_header
		ensure
			header_written: is_http_header_written
		end

	content_text_html_utf8 is
			-- Write Content-Type: text/html with explicit character ste
			-- UTF-8 to stdout.
			-- Use this when emitting UTF-8.
		do
			stdout.put_string ("Content-Type: text/html; charset=UTF-8%N")
			finish_header
		ensure
			header_written: is_http_header_written
		end

	content_text_plain is
			-- Write Content-Type: text/plain to stdout.
		do
			stdout.put_string ("Content-Type: text/plain%N")
			finish_header
		ensure
			header_written: is_http_header_written
		end

	finish_header is
			-- Finish the header by emitting an empty line.
			-- If `cookies' have been set, they are written as well.
		require
			header_not_written: not is_http_header_written
		local
			cookie: EPX_HTTP_COOKIE
			s: STRING
		do
			if not header.all_fields.is_empty then
				create s.make (256)
				header.append_fields_to_string (s)
				stdout.put_string (s)
			end
			from
				cookies.start
			until
				cookies.after
			loop
				cookie := cookies.item_for_iteration
				stdout.put_string ("Set-Cookie: ")
				stdout.put_string (cookie.key)
				stdout.put_string ("=")
				stdout.put_string (cookie.value)
				if cookie.domain /= Void then
					stdout.put_string ("; domain=")
					stdout.put_string (cookie.domain)
				end
				if cookie.path /= Void then
					stdout.put_string ("; path=")
					stdout.put_string (cookie.path)
				end
				if cookie.secure then
					stdout.put_string ("; secure")
				end
				if cookie.expires /= Void then
					stdout.put_string ("; expires=")
					stdout.put_string (cookie.expires.format ("%%a, %%d-%%b-%%Y %%H:%%M:%%S GMT"))
				end
				stdout.write_character ('%N')
				cookies.forth
			end
			stdout.write_character ('%N')
			stdout.flush
			is_http_header_written := True
		ensure
			header_written: is_http_header_written
		end

	location (a_url: STRING) is
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
			header_not_written: not is_http_header_written
		do
			stdout.put_string (field_name_location)
			stdout.put_string (": ")
			stdout.put_string (a_url)
			stdout.put_string ("%N%N")
			-- flush here seems to cause a SIGTERM. Not sure why Apache
			-- would send this. So you might want to catch/ignore this signal.
			stdout.flush
			is_http_header_written := True
		ensure
			header_written: is_http_header_written
		end

	status (a_status_code: INTEGER; a_reason: STRING) is
			-- Set the status code sent back to the client.
			-- This is used to give the server an HTTP/1.0 status line to
			-- send to the client. The format is nnn xxxxx, where nnn is
			-- the 3-digit status code, and xxxxx is the reason string,
			-- such as "Forbidden".
			-- Leave `a_reason' empty to return the default reason.
		require
			valid_status_code: is_three_digit_response (a_status_code)
		do
			header.set_status (a_status_code, a_reason)
		end


feature -- Cookies

	cookies: DS_HASH_TABLE [EPX_HTTP_COOKIE, STRING] is
			-- Cookies that will be returned to the browser
		once
			create Result.make (4)
		ensure
			cookies_not_void: cookies /= Void
		end

	set_cookie (a_cookie: EPX_HTTP_COOKIE) is
			-- Add a new cookie that will be send to the browser then
			-- `context_text_html' is called.
		require
			cookie_not_void: a_cookie /= Void
			cookie_not_added: not cookies.has (a_cookie.key)
		do
			cookies.force_last (a_cookie, a_cookie.key)
		ensure
			cookie_known: cookies.has (a_cookie.key)
		end


feature -- Server push, multipart header

	content_multipart_x_mixed_replace (boundary: STRING) is
			-- Initiate server push.
		require
			valid_boundary: boundary /= Void and then not boundary.is_empty
		do
			stdout.put_string ("Content-Type: multipart/x-mixed-replace;boundary=")
			stdout.put_string (boundary)
			my_boundary := boundary
			stdout.put_string ("%N%N")
			-- start first part immediately
			stdout.put_string (my_boundary)
			stdout.put_string ("%N")
			stdout.flush
		end

	content_next_part is
			-- Write boundary so next part of multipart msg can be written.
		require
			multipart: is_multipart_message
		do
			stdout.write_character ('%N')
			stdout.put_string (my_boundary)
			stdout.write_character ('%N')
			stdout.flush
		end

	content_multipart_end is
			-- Write boundary of multipart.
		require
			multipart: is_multipart_message
		do
			stdout.write_character ('%N')
			stdout.put_string (my_boundary)
			stdout.put_string ("--%N")
			stdout.flush
		end

	is_multipart_message: BOOLEAN is
			-- Are we writing server push, multipart output?
		do
			Result := my_boundary /= Void
		end


feature -- Form input

	has_input: BOOLEAN is
			-- Is input passed to cgi program?
		do
			Result := not request_method.is_empty
		end

	has_key (a_key: STRING): BOOLEAN is
			-- Is `a_key' passed as parameter/form-data?
		require
			key_valid: is_valid_key (a_key)
		do
			assert_key_value_pairs_created
			Result := cgi_data.has (a_key)
		ensure
			definition: Result = cgi_data.has (a_key)
		end

	is_meta_char (c: CHARACTER): BOOLEAN is
			-- Is `c' a commonly used meta character?
		do
			Result :=
				(c.code = 0) or else
				meta_chars.has (c)
		end

	meta_chars: STRING is
			-- Commonly used meta characters.
		once
			-- BdB: Check if this list is complete...
			Result := "`[]<>|&`\%%"
		ensure
			meta_chars_not_empty: meta_chars /= Void and then not meta_chars.is_empty
		end

	new_key_value_cursor (a_key_re, a_value_re: RX_PCRE_REGULAR_EXPRESSION; an_on_match_found: EPX_KEY_VALUE_MATCH): EPX_CGI_KEY_VALUE_CURSOR is
			-- New cursor to iterate over all keys, optionally including
			-- those keys and/or values that match `a_key_re' and
			-- `a_value_re;
			-- Useful when a form returns table like names and you want
			-- to iterate over the keys for that table.
		require
			match_found_callback: an_on_match_found /= Void
		do
			assert_key_value_pairs_created
			create {EPX_CGI_KEY_VALUE_CURSOR} Result.make (cgi_data, a_key_re, a_value_re, an_on_match_found)
		ensure
			cursor_returned: Result /= Void
		end

	raw_value (a_key: STRING): STRING is
			-- Returns value for key.
			-- if key does not exist, the empty string is returned.
		require
			key_valid: is_valid_key (a_key)
		do
			search_key (a_key)
			if found_key then
				create Result.make_from_string (found_key_item.value)
			else
				Result := ""
			end
		ensure
			raw_value_not_void: Result /= Void
		end

	remove_meta_chars (s: STRING) is
			-- If `s' contains meta characters, they're removed.
		require
			s_not_void: s /= Void
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > s.count
			loop
				if is_meta_char (s.item (i)) then
					s.remove (i)
				else
					i := i + 1
				end
			end
		end

	value (a_key: STRING): STRING is
			-- As `raw_value' but meta characters are removed
		require
			key_valid: is_valid_key (a_key)
		do
			Result := raw_value (a_key)
			remove_meta_chars (Result)
		ensure
			value_not_void: Result /= Void
		end


feature {NONE} -- Cached key/value

	assert_key_value_pairs_created is
			-- Make sure any parameters or form contents passed by the
			-- web server is parsed.
			-- This feature is normally called when needed, but in case
			-- you desire to iterate over the values, you might want to
			-- create them first. Else there's nothing to iterate and you
			-- would have to you call `value' or so first.
			-- Cookies are added as key/value pairs as well.
			-- If there is form data with the same name, it overrides the
			-- cookies value (yes, that's a feature).
		local
			given_cookies: DS_HASH_TABLE [EPX_KEY_VALUE, STRING]
			kv: EPX_KEY_VALUE
		do
			if cgi_data = Void then
				if has_input then
					fill_key_value_pairs
				else
					create cgi_data.make_default
				end
				if not http_cookie.is_empty then
					given_cookies := url_encoder.do_url_encoded_to_field_name_value_pair (http_cookie, ';')
					from
						given_cookies.start
					until
						given_cookies.after
					loop
						kv := given_cookies.item_for_iteration
						if not cgi_data.has (kv.key) then
							cgi_data.force (kv, kv.key)
						end
						given_cookies.forth
					end
				end
			end
		ensure
			cgi_data_not_void: cgi_data /= Void
		end

	cgi_data: DS_HASH_TABLE [EPX_KEY_VALUE, STRING]
			-- Array with key-value pairs;
			-- If you want to loop through the values, make sure to call
			-- `assert_key_value_pairs_created'.

	cgi_input: STRING
			-- Raw input data.

	fill_key_value_pairs is
			-- Fill `cgi_data', recognizes default and multipart encodings.
		require
			key_value_pair_not_set: cgi_data = Void
			there_is_input: has_input
		local
			ctype: STRING
		do
			create ctype.make_from_string (content_type)
			ctype.to_lower
			if ctype.is_empty or else ctype.has_substring (mime_type_application_x_www_form_urlencoded) then
				fill_key_value_pairs_from_standard_encoding
			elseif ctype.substring_index (mime_type_multipart_form_data, 1) = 1 then
				fill_key_value_pairs_from_multipart_encoding
			else
				-- unrecognized encoding such as "application/xml" for
				-- example; not sure what to do
				create cgi_data.make (0)
			end
		ensure
			cgi_data_not_void: cgi_data /= Void
		end

	found_key: BOOLEAN
			-- Was `search_key' successful?

	found_key_item: EPX_KEY_VALUE
			-- Item found by `search_key'.

	search_key (key: STRING) is
			-- Locate key in key/value pairs.
			-- Sets `found_key' if found.
		require
			valid_key: key /= Void and then not key.is_empty
		do
			assert_key_value_pairs_created
			cgi_data.search (key)
			if cgi_data.found then
				found_key := True
				found_key_item := cgi_data.found_item
			else
				found_key := False
				found_key_item := Void
			end
		ensure
			found_implies_item: found_key = (found_key_item /= Void)
		end

	set_cgi_input is
			-- Set `cgi_input'. When method is not GET, the variable
			-- Content-Length must be specified.
		local
			len: INTEGER
			i: INTEGER
			input: KI_CHARACTER_INPUT_STREAM
		do
			if is_request_body_in_stdin then
				-- Loop over input. Using content length would be enough,
				-- but for additional protection we also check
				-- `stdin'.`end_of_input'.
				from
					len := content_length
					i := 0
					create cgi_input.make (query_string.count + 1 + len)
					if not query_string.is_empty then
						-- Start with query string, data in body can
						-- override the key/value pairs from the query.
						cgi_input.append_string (query_string)
						cgi_input.append_character ('&')
					end
					input := stdin
					--create {STDC_TEXT_FILE} input.open_read ("test.form")
					input.read_character
				until
					input.end_of_input or else
					i = len
				loop
					cgi_input.append_character (input.last_character)
					i := i + 1
					input.read_character
				end
			else
				cgi_input := query_string
			end
		end

	is_request_body_in_stdin: BOOLEAN is
			-- Is request data available via stdin?
		do
			Result :=
				not env_content_length.value.is_empty and then
				not env_content_type.value.is_empty
		end


feature {NONE} -- Standard or multipart key/value filling

	fill_key_value_pairs_from_multipart_encoding is
			-- Posted data.
		local
			parser: EPX_MIME_PARSER
			input: STDC_TEXT_FILE
			additional: DS_HASH_TABLE [EPX_KEY_VALUE, STRING]
		do
			input := stdin
			--create input.open_read ("test-input")
			parser := new_parser (input)
			parser.set_header (mime_header)
			parser.parse
			if not parser.syntax_error then
				if parser.part.body.is_multipart then
					cgi_data := url_encoder.mime_encoded_to_field_name_value_pair (Void, parser.part.body)
				else
					create cgi_data.make (0)
				end
				-- Add those key/value pairs from query string that do not
				-- yet exist.
				additional := url_encoder.url_encoded_to_field_name_value_pair (query_string)
				from
					additional.start
				until
					additional.after
				loop
					if not cgi_data.has (additional.key_for_iteration) then
						cgi_data.force (additional.item_for_iteration, additional.key_for_iteration)
					end
					additional.forth
				end
			else
				exceptions.raise ("Syntax error detected during parsing of POSTed data.")
			end
		ensure
			cgi_data_not_void: cgi_data /= Void
		end

	fill_key_value_pairs_from_standard_encoding is
			-- Read query values from url request.
		do
			set_cgi_input
			if cgi_input /= Void then
				cgi_data := url_encoder.url_encoded_to_field_name_value_pair (cgi_input)
			end
		ensure
			cgi_data_not_void: cgi_data /= Void
		end

	mime_header: STRING is
			-- Suitable MIME header for POST data
		local
			fixed_content_type: STRING
			i: INTEGER
			value_start,
			value_end: INTEGER
		once
			-- Opera contains a boundary parameter with invalid characters.
			-- Fix this by making sure the boundary parameter is properly quoted.
			create fixed_content_type.make_from_string (content_type)
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
			create Result.make (field_name_content_type.count + 2 + fixed_content_type.count + 4)
			Result.append_string (field_name_content_type)
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

	new_parser (an_input: STDC_TEXT_FILE): EPX_MIME_PARSER is
			-- A new MIME parser
		require
			input_not_void: an_input /= Void
			input_open: an_input.is_open
		do
			create Result.make_from_file (an_input)
		ensure
			not_void: Result /= Void
		end


feature {NONE} -- Implementation

	file_system: EPX_FILE_SYSTEM is
			-- Access to file system routines
		once
			create Result
		ensure
			not_void: Result /= Void
		end

	my_boundary: STRING
			-- Used for server push, multipart header.


	url_encoder: EPX_URL_ENCODING is
			-- Decoding of encoded passed values
		once
			create Result
		ensure
			not_void: Result /= Void
		end


feature {NONE} -- Once strings

	once_remapped_delete_method: STRING is "http-method:DELETE"
	once_remapped_put_method: STRING is "http-method:PUT"


end
