indexing

	description: "Class that implements whatever an HTTP 1.0 client can do."

	author: "Berend de Boer"
	date: "$Date: 2007/05/17 $"
	revision: "$Revision: #10 $"


class

	EPX_HTTP_10_CLIENT


inherit

	EPX_HTTP_CLIENT
		export
			{ANY} response_code, http
		end

	EPX_MIME_TYPE_NAMES
		export
			{NONE} all;
			{ANY} mime_type_application_x_www_form_urlencoded, mime_type_multipart_form_data
		end

	EPX_MIME_FIELD_NAMES
		export
			{NONE} all;
			{ANY} field_name_content_type
		end

	EPX_MIME_PARAMETER_NAMES
		export
			{NONE} all
		end

	EPX_HTTP_METHODS
		export
			{NONE} all
		end

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		end

	UC_IMPORTED_UTF8_ROUTINES
		export
			{NONE} all
		end


creation

	make,
	make_from_port,
	make_with_port,
	make_from_host,
	make_from_host_and_port,
	make_secure,
	make_secure_with_port


feature -- Access

	client_version: STRING is
			-- Client http version
		once
			Result := "HTTP/1.0"
		end

	last_data: EPX_MIME_PART
			-- Data of last request send to server;
			-- Used by `read_response_with_redirect' to properly redirect
			-- a request.

	last_verb: STRING
			-- Verb of last request send to server;
			-- Used by `read_response_with_redirect' to properly redirect
			-- a request.


feature -- Requests

	delete (a_request_uri: STRING) is
			-- Send DELETE request to server.
			-- Use `read_response' to fetch the response and actual response code.
		require
			a_request_uri_not_empty: a_request_uri /= Void and then not a_request_uri.is_empty
		do
			send_request (http_method_DELETE, a_request_uri, Void)
		end

	get (a_request_uri: STRING) is
			-- Send GET request to server.
			-- Sets `response_code' to 200 if the request was send successfully.
			-- If sending the request failed (usually because the server refused
			-- the connection), 503 is returned.
			-- Use `read_response' to fetch the response and actual response code.
		do
			send_request (http_method_GET, a_request_uri, Void)
		end

	head (a_request_uri: STRING) is
			-- Send HEAD request to server.
			-- `a_request_uri' should not include http: and the host name, only
			-- the page that is requested. Any query and fragment parts are ok.
			-- Sets `response_code' to 200 if the request was send successfully.
			-- If sending the request failed (usually because the server refused
			-- the connection), 503 is returned.
			-- Use `read_response' to fetch the response and actual response code.
		require
			a_request_uri_not_empty: a_request_uri /= Void and then not a_request_uri.is_empty
		do
			send_request (http_method_HEAD, a_request_uri, Void)
		end

	options (a_request_uri: STRING) is
			-- Get server options. `a_request_uri' is required when the
			-- request is being made to a proxy.
			-- Sets `response_code' to 200 if the request was send successfully.
			-- If sending the request failed (usually because the server refused
			-- the connection), 503 is returned.
			-- Use `read_response' to fetch the response and actual response code.
		do
			if a_request_uri = Void or else a_request_uri.is_empty then
				send_request (http_method_OPTIONS, "*", Void)
			else
				send_request (http_method_OPTIONS, a_request_uri, Void)
			end
		end

	put (a_request_uri: STRING; a_put_data: EPX_MIME_PART) is
			-- Put `a_put_data' to `host' using the HTTP PUT request.
			-- Sets `response_code' to 200 if the request was send successfully.
			-- If sending the request failed (usually because the server refused
			-- the connection), 503 is returned.
			-- Use `read_response' to fetch the response and actual response code.
			-- Tip: use EPX_MIME_FORM.make_form_data to build the
			-- most common form data messages.
		require
			a_request_uri_not_empty: a_request_uri /= Void and then not a_request_uri.is_empty
			put_data_not_void: a_put_data /= Void
			put_data_has_content_type: a_put_data.header.content_type /= Void
			put_data_content_type_recognized:
				a_put_data.header.content_type.value.is_equal (mime_type_multipart_form_data) or else
				a_put_data.header.content_type.value.is_equal (mime_type_application_x_www_form_urlencoded)
			put_data_content_type_has_boundary_if_multipart:
				a_put_data.header.content_type.value.is_equal (mime_type_multipart_form_data) implies
					a_put_data.header.content_type.boundary /= Void and then
					not a_put_data.header.content_type.boundary.is_empty
			put_data_has_body: a_put_data.body /= Void
		do
			send_request (http_method_PUT, a_request_uri, a_put_data)
		end

	post (a_request_uri: STRING; a_post_data: EPX_MIME_PART) is
			-- Post `a_post_data' to `host' using the HTTP POST request.
			-- Sets `response_code' to 200 if the request was send successfully.
			-- If sending the request failed (usually because the server refused
			-- the connection), 503 is returned.
			-- Use `read_response' to fetch the response and actual response code.
			-- Tip: use EPX_MIME_FORM.make_form_data to build the
			-- most common form data messages.
			-- Tip 2: `post_data_content_type_recognized' is usually true if
			-- you sent data to an HTTP server.
		require
			a_request_uri_not_empty: a_request_uri /= Void and then not a_request_uri.is_empty
			post_data_not_void: a_post_data /= Void
			post_data_has_content_type: a_post_data.header.content_type /= Void
-- 			post_data_content_type_recognized:
-- 				a_post_data.header.content_type.value.is_equal (mime_type_multipart_form_data) or else
-- 				a_post_data.header.content_type.value.is_equal (mime_type_application_x_www_form_urlencoded)
			post_data_content_type_has_boundary_if_multipart:
				a_post_data.header.content_type.value.is_equal (mime_type_multipart_form_data) implies
					a_post_data.header.content_type.boundary /= Void and then
					not a_post_data.header.content_type.boundary.is_empty
			post_data_has_body: a_post_data.body /= Void
		do
			send_request (http_method_POST, a_request_uri, a_post_data)
		end

	post_xml (a_request_uri: STRING; a_post_data: STRING) is
			-- Post `a_post_data' to `host' using the HTTP POST request.
			-- Sets `response_code' to 200 if the request was send successfully.
			-- If sending the request failed (usually because the server refused
			-- the connection), 503 is returned.
			-- Use `read_response' to fetch the response and actual response code.
			-- `a_post_data' should be valid XML.
		require
			a_request_uri_not_empty: a_request_uri /= Void and then not a_request_uri.is_empty
			post_data_not_void: a_post_data /= Void
		local
			msg: EPX_MIME_PART
		do
			create msg.make_empty
			msg.create_singlepart_body
			msg.header.set_content_type ("text", "xml", charset_utf8)
			msg.text_body.append_string (utf8.to_utf8 (a_post_data))
			send_request (http_method_POST, a_request_uri, msg)
		end


feature -- Authentication response

	is_authentication_required: BOOLEAN
			-- Set if response from server indicates that proper
			-- authentication is required

	authentication_realm: STRING is
			-- Realm of authentication if defined; but according to the
			-- spec all schemes should have one.
		require
			authentication_required: is_authentication_required
		local
			www_authenticate: EPX_MIME_FIELD_WWW_AUTHENTICATE
		do
			www_authenticate ?= response.header.fields.item (field_name_www_authenticate)
			Result := www_authenticate.realm
		end

	authentication_scheme: STRING is
			-- Required authentication scheme
		require
			authentication_required: is_authentication_required
		local
			www_authenticate: EPX_MIME_FIELD_WWW_AUTHENTICATE
		do
			www_authenticate ?= response.header.fields.item (field_name_www_authenticate)
			Result := www_authenticate.scheme
		end


feature -- Authentication setup

	basic_authentication: STRING
			-- Optional authentication header to send with a request

	set_basic_authentication (a_user_name, a_password: STRING) is
			-- Make sure the Authorization header is included in the
			-- request.
		require
			user_name_not_empty: a_user_name /= Void and then not a_user_name.is_empty
			password_not_empty: a_password /= Void and then not a_password.is_empty
		local
			basic_credentials: STRING
			base64_output: KL_STRING_OUTPUT_STREAM
			base64_encoder: UT_BASE64_ENCODING_OUTPUT_STREAM
		do
			create basic_credentials.make (a_user_name.count + 1 + a_password.count)
			basic_credentials.append_string (a_user_name)
			basic_credentials.append_character (':')
			basic_credentials.append_string (a_password)
			create basic_authentication.make (32)
			create base64_output.make(basic_authentication)
			create base64_encoder.make (base64_output, True, True)
			base64_encoder.put_string (basic_credentials)
			base64_encoder.close
		end


feature -- Cookies

	cookies: DS_HASH_TABLE [EPX_HTTP_COOKIE, STRING]
			-- Cookies that will be sent with the request to the server

	set_cookie (a_cookie_name, a_cookie_value: STRING) is
			-- Add or update a cookie that will be send to the browser
			-- then `context_text_html' is called.
		require
			cookie_name_not_empty: a_cookie_name /= Void and then not a_cookie_name.is_empty
			cookie_value_not_void: a_cookie_value /= Void
		local
			cookie: EPX_HTTP_COOKIE
		do
			create cookie.make (a_cookie_name, a_cookie_value)
			if cookies = Void then
				create cookies.make (4)
			end
			cookies.search (a_cookie_name)
			if cookies.found then
				cookies.remove_found_item
			end
			cookies.force_last (cookie, a_cookie_name)
		ensure
			cookie_known: cookies.has (a_cookie_name)
			cookie_value_set: cookies.item (a_cookie_name).value.is_equal (a_cookie_value)
		end

	wipe_out_cookies is
			-- Remove all cookies
		do
			if cookies /= Void then
				cookies.wipe_out
			end
		end


feature {NONE} -- Request implementation

	append_other_fields (request: STRING) is
			-- Append any optional fields.
		local
			cookie: EPX_HTTP_COOKIE
		do
			request.append_string (once_mime_version)
			if accept /= Void then
				request.append_string (field_name_accept)
				request.append_string (once_colon_space)
				request.append_string (accept)
				request.append_string (once_new_line)
			end
			if user_agent /= Void then
				request.append_string (field_name_user_agent)
				request.append_string (once_colon_space)
				request.append_string (user_agent)
				request.append_string (once_new_line)
			end
			if basic_authentication /= Void then
				request.append_string (field_name_authorization)
				request.append_string (once_colon_space)
				request.append_string (once_basic)
				request.append_character (' ')
				request.append_string (basic_authentication)
				request.append_string (once_new_line)
			end
			if cookies /= Void then
				from
					cookies.start
				until
					cookies.after
				loop
					cookie := cookies.item_for_iteration
					request.append_string ("Cookie: ")
					request.append_string (cookie.key)
					request.append_string ("=")
					request.append_string (cookie.value)
					request.append_string (once_new_line)
					cookies.forth
				end
			end
		end

	send_request (a_request, a_request_uri: STRING; a_request_data: EPX_MIME_PART) is
			-- Send request `a_request' with `a_request_uri' to `host'.
			-- Additional fields and an optional body can be passed in
			-- `a_request_data'.
			-- Sets `response_code' to 200 if the request was send successfully.
			-- If sending the request failed (usually because the server refused
			-- the connection), 503 is returned.
		require
			request_not_empty: a_request /= Void and then not a_request.is_empty
			request_uri_not_empty: a_request_uri /= Void and then not a_request_uri.is_empty
		local
			request: STRING
			error_message: STRING
		do
			assert_closed
			open
			last_uri := clone (a_request_uri)
			if is_open then
				response_code := reply_code_ok
				create request.make (512)
				request.append_string (a_request)
				request.append_character (' ')
				request.append_string (a_request_uri)
				request.append_character (' ')
				request.append_string (client_version)
				request.append_string (once_new_line)
				-- Add required field Host
				request.append_string (field_name_host)
				request.append_string (once_colon_space)
				request.append_string (host.name)
				request.append_string (once_new_line)
				append_other_fields (request)
				request.append_string (once_connection_close)
				if a_request_data = Void then
					request.append_string (once_new_line)
				else
					if a_request_data.header.content_type /= Void and then a_request_data.header.content_type.value.is_equal (mime_type_application_x_www_form_urlencoded) then
						a_request_data.append_urlencoded_to_string (request)
					else
						a_request_data.append_to_string (request)
					end
				end
				http.put_string (request)
				last_verb := a_request
				last_data := a_request_data
			else
				response_code := reply_code_service_unavailable
				response_phrase := error_message
			end
		ensure
			last_uri_set: STRING_.same_string (last_uri, a_request_uri)
			last_verb_set: response_code = reply_code_ok implies STRING_.same_string (a_request, last_verb)
			last_data_set: response_code = reply_code_ok implies a_request_data = last_data
		end


feature -- Fields that are send with a request if set

	accept: STRING
			-- What kind of output can the client handle?
			-- Examples are:
			--   Accept: text/plain; q=0.5, text/html,
			--           text/x-dvi; q=0.8, text/x-c

	user_agent: STRING
			-- Identification of client program;
			-- Common examples are:
			--   Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)
			--   Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.0.0) Gecko/20020529
			--   Microsoft Internet Explorer

	set_accept (value: STRING) is
			-- Set the media types which are acceptable for the response.
		require
			value_void_or_not_empty: value = Void or else not value.is_empty
		do
			accept := value
		ensure
			accept_set:
				(value = Void implies accept = Void) or else
				(accept.is_equal (value))
		end

	set_user_agent (value: STRING) is
			-- Set the client identification.
		require
			value_void_or_not_empty: value = Void or else not value.is_empty
		do
			user_agent := value
		ensure
			user_agent_set:
				(value = Void implies user_agent = Void) or else
				(user_agent.is_equal (value))
		end


feature -- Response

	body: EPX_MIME_BODY_TEXT is
			-- Body as text, if applicable, else Void
		local
			stream: KI_CHARACTER_INPUT_STREAM
		do
			if response /= Void then
				Result ?= response.body
				if Result /= Void and then Result.stream.name.is_empty then
					-- Set name of stream to full URI.
					stream := Result.stream
					stream.name.wipe_out
					stream.name.append_string (last_uri)
				end
			end
		end

	fields: DS_HASH_TABLE [EPX_MIME_FIELD, STRING] is
			-- Header fields of response
		do
			Result := response.header.fields
		ensure
			fields_not_void: fields /= Void
		end

	is_response_ok: BOOLEAN is
			-- Does the returned `response_code' indicate success?
		do
			Result := response_code >= 200 and response_code <= 299
		end

	last_uri: STRING
			-- URI of last request

	part: EPX_MIME_PART is
		obsolete "2006-10-28: use response instead"
		do
			Result := response
		end

	read_response is
			-- Read entire resonse and make it available in
			-- `response'. Header is available in `fields', and text body, if
			-- any in `body'.
			-- If a redirect response is returned, the redirect is not
			-- automatically read. Use `read_response_with_redirect' to
			-- automatically handle redirects.
			-- If the server has returned an invalid response, the
			-- `response_code' is set to 500.
		do
			-- first line is HTTP version
			if parser = Void then
				create parser.make_from_stream (http)
			else
				create parser.make_from_stream (http)
			end
			read_and_parse_status_line
			-- parse while reading.
			parser.parse
			if parser.syntax_error then
				response_code := 500
				response_phrase := "Syntax error parsing response."
				response := Void
				is_authentication_required := False
			else
				response := parser.part
				is_authentication_required :=
					response_code = reply_code_unauthorized and then
					response.header.has (field_name_www_authenticate)
			end
		end

	read_response_with_redirect is
			-- As `read_response', but if a redirect responsen code is
			-- received, request is automatically redirected.
			-- It assumes `last_verb' contains the verb of the last
			-- request send.
			-- A maximum of twenty redirects are followed, after that
			-- this routine just returns.
		local
			new_location: STRING
			redirected_counter: INTEGER
		do
			from
				read_response
			until
				redirected_counter > 20 or else
				not is_redirect_response
			loop
				new_location := location
				if response_code = reply_code_see_other then
					send_request (http_method_GET, new_location, Void)
				else
					send_request (last_verb, new_location, Void)
				end
				read_response
				redirected_counter := redirected_counter + 1
			end
		end

	response: EPX_MIME_PART
			-- The entire parsed MIME message;
			-- It is set by `read_response'. May be Void if there is no body.

	response_phrase: STRING
			-- HTTP server response phrase;
			-- set by `read_response'.

	server_version: STRING
			-- HTTP server version;
			-- set by `read_response'.


feature -- Individual response fields, Void if not available

	location: STRING is
		do
			fields.search (field_name_location)
			if fields.found then
				Result := fields.found_item.value
			end
		end


feature {NONE} -- Implementation

	read_and_parse_status_line is
			-- First line is HTTP version and response.
			-- But not always, there's some s**t out there that
			-- immediately starts with the MIME headers. I don't try to
			-- recover from that.
		local
			p, q: INTEGER
			s: STRING
			status_line: STRING
		do
			create status_line.make (64)
			from
				parser.read_character
			until
				parser.last_character = '%N' or else
				parser.end_of_input
			loop
				status_line.append_character (parser.last_character)
				parser.read_character
			end

			-- Removing %R if part of CRLF
			if status_line.count > 0 and then status_line.item (status_line.count) = '%R' then
				status_line.remove (status_line.count)
			end

			p := status_line.index_of (' ', 1)
			if p > 1 then
				q := status_line.index_of (' ', p+1)
			end
			if p > 1 and q > 1 then
				server_version := status_line.substring (1, p-1)
				sh.trim (server_version)
				s := status_line.substring (p+1, q-1)
				sh.trim (s)
				if s.is_integer then
					response_code := s.to_integer
				else
					response_code := 500
				end
				response_phrase := status_line.substring (q+1, status_line.count)
				sh.trim (response_phrase)
			else
				-- Can we recover from garbage??
				response_code := 500
				response_phrase := ""
				server_version := ""
			end
		end


feature {NONE} -- MIME parser

	parser: EPX_MIME_PARSER
			-- Parse response from HTTP server


feature {NONE} -- Once strings

	once_colon_space: STRING is ": "
	once_connection_close: STRING is "Connection: close%R%N"
	once_mime_version: STRING is "MIME-Version: 1.0%R%N"
	once_new_line: STRING is "%R%N"
	once_basic: STRING is "Basic"


invariant

	have_www_authenticate_header_if_authentication_required:
		is_authentication_required implies response.header.has (field_name_www_authenticate)

end
