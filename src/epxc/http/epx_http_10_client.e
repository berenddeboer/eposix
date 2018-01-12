note

	description: "Class that implements whatever an HTTP 1.0 client can do."

	author: "Berend de Boer"


class

	EPX_HTTP_10_CLIENT


inherit

	EPX_HTTP_CLIENT
		rename
			authenticate as unsupported_authenticate
		export
			{ANY} response_code, http
		redefine
			make_with_port
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


create

	make,
	make_with_port,
	make_from_host,
	make_from_host_and_port,
	make_secure,
	make_secure_with_port


feature {NONE} -- Initialization

	make_with_port (a_server_name: STRING; a_port: INTEGER)
		do
			precursor (a_server_name, a_port)
			create server_version.make_empty
			create response_phrase.make_empty
			create authentication_scheme.make_empty
			create raw_response.make_empty
		end


feature -- Access

	client_version: STRING
			-- Client http version
		once
			Result := "HTTP/1.0"
		end

	last_data: detachable EPX_MIME_PART
			-- Data of last request send to server;
			-- Used by `read_response_with_redirect' to properly redirect
			-- a request.

	last_verb: detachable STRING
			-- Verb of last request send to server;
			-- Used by `read_response_with_redirect' to properly redirect
			-- a request.

	last_uri: detachable STRING
			-- URI of last request

	max_redirects: INTEGER = 20
			-- How often we follow a Location field?

	max_authentication_retries: INTEGER = 20
			-- How often we retry authentication failures


feature -- Status

	reuse_connection: BOOLEAN
			-- Should HTTP connection be reused for more than 1 request?


feature -- Requests

	delete (a_request_uri: STRING; a_delete_data: EPX_MIME_PART)
			-- Send DELETE request to server.
			-- Use `read_response' to fetch the response and actual response code.
		require
			a_request_uri_not_empty: a_request_uri /= Void and then not a_request_uri.is_empty
		do
			send_request (http_method_DELETE, a_request_uri, a_delete_data)
		end

	get (a_request_uri: READABLE_STRING_GENERAL)
			-- Send GET request to server.
			-- Sets `response_code' to 200 if the request was send successfully.
			-- If sending the request failed (usually because the server refused
			-- the connection), 500 is returned.
			-- Use `read_response' to fetch the response and actual response code.
		do
			send_request (http_method_GET, a_request_uri.out, Void)
		end

	head (a_request_uri: STRING)
			-- Send HEAD request to server.
			-- `a_request_uri' should not include http: and the host name, only
			-- the page that is requested. Any query and fragment parts are ok.
			-- Sets `response_code' to 200 if the request was send successfully.
			-- If sending the request failed (usually because the server refused
			-- the connection), 500 is returned.
			-- Use `read_response' to fetch the response and actual response code.
		require
			a_request_uri_not_empty: attached a_request_uri and then not a_request_uri.is_empty
		do
			send_request (http_method_HEAD, a_request_uri, Void)
		end

	options (a_request_uri: STRING)
			-- Get server options. `a_request_uri' is required when the
			-- request is being made to a proxy.
			-- Sets `response_code' to 200 if the request was send successfully.
			-- If sending the request failed (usually because the server refused
			-- the connection), 500 is returned.
			-- Use `read_response' to fetch the response and actual response code.
		do
			if not attached a_request_uri or else a_request_uri.is_empty then
				send_request (http_method_OPTIONS, "*", Void)
			else
				send_request (http_method_OPTIONS, a_request_uri, Void)
			end
		end

	put (a_request_uri: STRING; a_put_data: EPX_MIME_PART)
			-- Put `a_put_data' to `host' using the HTTP PUT request.
			-- Sets `response_code' to 200 if the request was send successfully.
			-- If sending the request failed (usually because the server refused
			-- the connection), 500 is returned.
			-- Use `read_response' to fetch the response and actual response code.
			-- Tip: use EPX_MIME_FORM.make_form_data to build the
			-- most common form data messages.
		require
			a_request_uri_not_empty: attached a_request_uri and then not a_request_uri.is_empty
			put_data_not_void: attached a_put_data
			put_data_has_content_type: attached a_put_data.header.content_type
			put_data_content_type_has_boundary_if_multipart:
				attached a_put_data.header.content_type as ct and then ct.value.is_equal (mime_type_multipart_form_data) implies
					attached ct.boundary as a_boundary and then
					not a_boundary.is_empty
			put_data_has_body: attached a_put_data.body
		do
			send_request (http_method_PUT, a_request_uri, a_put_data)
		end

	post (a_request_uri: STRING; a_post_data: EPX_MIME_PART)
			-- Post `a_post_data' to `host' using the HTTP POST
			-- request. `a_post_data' may be empty in which case no data
			-- will be send with this POST request.
			-- Sets `response_code' to 200 if the request was send successfully.
			-- If sending the request failed (usually because the server refused
			-- the connection), 500 is returned.
			-- Use `read_response' to fetch the response and actual response code.
			-- Tip: use EPX_MIME_FORM.make_form_data to build the
			-- most common form data messages.
			-- Tip 2: `post_data_content_type_recognized' is usually true if
			-- you sent data to an HTTP server.
		require
			a_request_uri_not_empty: attached a_request_uri and then not a_request_uri.is_empty
			post_data_has_content_type: attached a_post_data as pd implies attached pd.header.content_type
			post_data_content_type_has_boundary_if_multipart:
				attached a_post_data as pd implies
					(attached pd.header.content_type as ct and then ct.value.is_equal (mime_type_multipart_form_data) implies
						attached ct.boundary as a_boundary and then
						not a_boundary.is_empty)
			post_data_has_body: attached a_post_data as pd implies attached pd.body
		do
			send_request (http_method_POST, a_request_uri, a_post_data)
		end

	post_xml (a_request_uri: STRING; a_post_data: STRING)
			-- Post `a_post_data' to `host' using the HTTP POST request.
			-- Sets `response_code' to 200 if the request was send successfully.
			-- If sending the request failed (usually because the server refused
			-- the connection), 500 is returned.
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
			if attached msg.text_body as b then
				b.append_string (utf8.to_utf8 (a_post_data))
			end
			send_request (http_method_POST, a_request_uri, msg)
		end

	send_request (a_verb, a_request_uri: STRING; a_request_data: detachable EPX_MIME_PART)
			-- Send request `a_verb' with `a_request_uri' to `host'.
			-- Additional header fields and an optional body can be passed in
			-- `a_request_data'.
			-- Sets `response_code' to 200 if the request was send successfully.
			-- If sending the request failed (usually because the server refused
			-- the connection), 500 is returned.
		require
			verb_not_empty: attached a_verb and then not a_verb.is_empty
			request_uri_not_empty: attached a_request_uri and then not a_request_uri.is_empty
		local
			request: STRING
		do
			if not reuse_connection then
				assert_closed
			end
			if not is_open then
				open
				if is_open and then attached tcp_socket as a_tcp_socket then
					a_tcp_socket.set_throughput
					a_tcp_socket.set_nodelay
				end
			end
			last_uri := escape_spaces (a_request_uri)
			if is_open then
				response_code := reply_code_ok
				create request.make (512)
				request.append_string (a_verb)
				request.append_character (' ')
				request.append_string (last_uri)
				request.append_character (' ')
				request.append_string (client_version)
				request.append_string (once_new_line)
				-- Add required field Host
				if attached host as a_host then
					request.append_string (field_name_host)
					request.append_string (once_colon_space)
					request.append_string (a_host.name)
					request.append_string (once_new_line)
				end
				append_other_fields (a_verb, a_request_uri, a_request_data, request)
				if not reuse_connection then
					request.append_string (once_connection_close)
				end
				if not attached a_request_data then
					request.append_string (once_new_line)
				else
					-- If body isn't multi-part, assume it is already form
					-- urlencoded
					if attached a_request_data.header.content_type as ct and then ct.value.is_equal (mime_type_application_x_www_form_urlencoded) and then a_request_data.body.is_multipart then
						a_request_data.append_urlencoded_to_string (request)
					else
						a_request_data.append_to_string (request)
					end
				end
				debug ("http_client")
					print (request)
					print (once_new_line)
				end
				if attached http as a_http then
					a_http.put_string (request)
				end
				last_verb := a_verb
				last_data := a_request_data
			else
				response_code := 500
				response_phrase := "Internal Server Error"
			end
		ensure
			last_uri_set: attached last_uri as lu and then STRING_.same_string (lu, escape_spaces (a_request_uri))
			last_verb_set: response_code = reply_code_ok implies attached last_verb as lv and then STRING_.same_string (a_verb, lv)
			last_data_set: response_code = reply_code_ok implies a_request_data = last_data
		end


feature -- Authentication response

	is_authentication_required: BOOLEAN
			-- Set if response from server indicates that proper
			-- authentication is required

	-- authentication_realm: STRING
	-- 		-- Realm of authentication if defined; but according to the
	-- 		-- spec all schemes should have one.
	-- 	require
	-- 		authentication_required: is_authentication_required
	-- 	do
	-- 		Result := www_authenticate.realm
	-- 	end

	authentication_scheme: STRING


feature -- Authentication setup

	set_basic_authentication (a_user_name, a_password: STRING)
			-- Make sure the Authorization header is included in the
			-- request.
			-- Header will be appended when the first request is made, so
			-- avoids a round-trip.
			-- Use `set_user_name_and_password' to only send password
			-- when authentication is required.
		require
			user_name_not_empty: a_user_name /= Void and then not a_user_name.is_empty
			password_not_empty: a_password /= Void and then not a_password.is_empty
		do
			authentication_scheme := "Basic"
			set_user_name_and_password (a_user_name, a_password)
		end


feature -- Cookies

	cookies: DS_HASH_TABLE [EPX_HTTP_COOKIE, STRING]
			-- Cookies that will be sent with the request to the server
		once
			create Result.make (4)
		end

	set_cookie (a_cookie_name, a_cookie_value: STRING)
			-- Add or update a cookie that will be send to the browser
			-- then `context_text_html' is called.
		require
			cookie_name_not_empty: a_cookie_name /= Void and then not a_cookie_name.is_empty
			cookie_value_not_void: a_cookie_value /= Void
		local
			cookie: EPX_HTTP_COOKIE
		do
			create cookie.make (a_cookie_name, a_cookie_value)
			cookies.search (a_cookie_name)
			if cookies.found then
				cookies.remove_found_item
			end
			cookies.force_last (cookie, a_cookie_name)
		ensure
			cookie_known: cookies.has (a_cookie_name)
			cookie_value_set: cookies.item (a_cookie_name).value.is_equal (a_cookie_value)
		end

	wipe_out_cookies
			-- Remove all cookies
		do
			cookies.wipe_out
		end


feature {NONE} -- Request implementation

	append_other_fields (a_verb, a_path: STRING; a_request_data: detachable EPX_MIME_PART; request: STRING)
			-- Append any other field to `request'.
			-- `a_request_data' contains fields passed in by client and
			-- can be modified before they are written.
		require
			verb_not_empty: a_verb /= Void and then not a_verb.is_empty
			path_not_empty: a_path /= Void and then not a_path.is_empty
			request_not_empty: request /= Void and then not request.is_empty
		local
			cookie: EPX_HTTP_COOKIE
			authorization: STRING
		do
			request.append_string (once_mime_version)
			if attached accept then
				request.append_string (field_name_accept)
				request.append_string (once_colon_space)
				request.append_string (accept)
				request.append_string (once_new_line)
			end
			if attached user_agent then
				request.append_string (field_name_user_agent)
				request.append_string (once_colon_space)
				request.append_string (user_agent)
				request.append_string (once_new_line)
			end
			if not user_name.is_empty and then not password.is_empty and then attached authentication_scheme and then attached last_uri as lu then
				authorization := authorization_value (a_verb, lu)
				request.append_string (field_name_authorization)
				request.append_string (once_colon_space)
				request.append_string (authorization)
				request.append_string (once_new_line)
			end
			from
				cookies.start
			until
				cookies.after
			loop
				cookie := cookies.item_for_iteration
				request.append_string (once "Cookie: ")
				request.append_string (cookie.key)
				request.append_character ('=')
				request.append_string (cookie.value)
				request.append_string (once_new_line)
				cookies.forth
			end
		end


feature -- Fields that are send with a request if set

	accept: detachable STRING
			-- What kind of output can the client handle?
			-- Examples are:
			--   Accept: text/plain; q=0.5, text/html,
			--           text/x-dvi; q=0.8, text/x-c

	user_agent: detachable STRING
			-- Identification of client program;
			-- Common examples are:
			--   Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)
			--   Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.0.0) Gecko/20020529
			--   Microsoft Internet Explorer

	set_accept (value: STRING)
			-- Set the media types which are acceptable for the response.
		require
			value_void_or_not_empty: value = Void or else not value.is_empty
		do
			accept := value
		ensure
			accept_set:
				(not attached value implies not attached accept) or else
				(attached value as v and then attached accept as a and then a ~ v)
		end

	set_user_agent (value: STRING)
			-- Set the client identification.
		require
			value_void_or_not_empty: value = Void or else not value.is_empty
		do
			user_agent := value
		ensure
			user_agent_set:
				(not attached value implies not attached user_agent) or else
				(attached value as v and then attached user_agent as ua and then ua ~ v)
		end


feature -- Response

	body: detachable EPX_MIME_BODY_TEXT
			-- Body as text, if applicable, else Void
		local
			stream: KI_CHARACTER_INPUT_STREAM
		do
			if attached response as r then
				if attached {EPX_MIME_BODY_TEXT} r.body as text_body then
					Result := text_body
					if Result.stream.name.is_empty then
						-- Set name of stream to full URI.
						stream := Result.stream
						stream.name.wipe_out
						stream.name.append_string (last_uri)
					end
				end
			end
		end

	fields: DS_HASH_TABLE [EPX_MIME_FIELD, STRING]
			-- Header fields of response
		require
			response_attached: attached response
		do
			if attached response as a_response then
				Result := a_response.header.fields
			end
				check attached Result end
		ensure
			fields_not_void: attached Result
		end

	is_response_ok: BOOLEAN
			-- Does the returned `response_code' indicate success?
		do
			Result := response_code >= 200 and response_code <= 299
		end

	read_response
			-- Read entire response and make it available in
			-- `response'. Header is available in `fields', and text body, if
			-- any in `body'.
			-- If a redirect response is returned, the redirect is not
			-- automatically read. Use `read_response_with_redirect' to
			-- automatically handle redirects.
			-- If the server has returned an invalid response, the
			-- `response_code' is set to 500.
		do
			debug ("http_client_dump_response")
				if attached http as a_http then
					from
						a_http.read_character
					until
						a_http.end_of_input
					loop
						print (a_http.last_character)
						a_http.read_character
					end
				end
			end
			do_read_response (True)
		end

	read_response_header
			-- Read the header and make it available in
			-- `response'. Header is available in `fields'. Due to
			-- buffering first part of body is usually also available in
			-- `response'.`body'.
			-- If a redirect response is returned, the redirect is not
			-- automatically read. Use `read_response_with_redirect' to
			-- automatically handle redirects.
			-- If the server has returned an invalid response, the
			-- `response_code' is set to 500.
			-- First part of body is made available in `first_body_part'
		do
			do_read_response (False)
		end

	read_response_with_redirect
			-- As `read_response', but if a redirect response code is
			-- received, request is automatically redirected.
			-- It assumes `last_verb' contains the verb of the last
			-- request send.
			-- A maximum of twenty redirects are followed, after that
			-- this routine just returns.
			-- Note then when a redirect is followed, the `server_name'
			-- and `port' will change to the redirected server.
		require
			last_verb_set: attached last_verb
		local
			redirected_counter: INTEGER
			url: UT_URI
		do
			from
				read_response
			until
				response_code >= 500 or else
				redirected_counter > max_redirects or else
				not is_redirect_response
			loop
				if attached location as new_location then
					-- Redirect will still fail if returned Location includes
					-- a username, as we don't pick that up.
					create url.make (new_location)

					-- Support both absolute URL (as per spec) and relative
					-- urls, as returning an absolute url from a server is
					-- very hard to get right.
					if url.is_server_authority then
						url.parse_authority (80)
						if not STRING_.same_string (server_name, url.host) or http_service.port /= url.port then
							make_with_port (url.host, url.port)
						end
					end
					if url.has_path then
						if response_code = reply_code_see_other then
							send_request (http_method_GET, url.path, last_data)
						elseif attached last_verb as lv then
							send_request (lv, url.path, last_data)
						end
						read_response
						redirected_counter := redirected_counter + 1
					else
						response_code := 500
					end
				else
					-- No location specified, bail
					redirected_counter := max_redirects + 1
				end
			end
		end

	response: detachable EPX_MIME_PART
			-- The entire parsed MIME message;
			-- It is set by `read_response'. May be Void if there is no body.

	response_phrase: STRING
			-- HTTP server response phrase;
			-- set by `read_response'.

	server_version: STRING
			-- HTTP server version;
			-- set by `read_response'.


feature -- Individual response fields, Void if not available

	location: detachable STRING
			-- The contents of the Location field in the header, if any
		do
			fields.search (field_name_location)
			if fields.found then
				Result := fields.found_item.value
			end
		ensure
			definition: fields.has (field_name_location) = (location /= Void)
		end


feature {NONE} -- Implementation

	www_authenticate: detachable EPX_MIME_FIELD_WWW_AUTHENTICATE
			-- Authenticate field from last request, if any

	authorization_value (a_verb, a_uri: STRING): STRING
			-- Value for Authorization field if `authentication_scheme' is basic
		require
			verb_not_empty: a_verb /= Void and then not a_verb.is_empty
			uri_not_empty: a_uri /= Void and then not a_uri.is_empty
		do
			if not user_name.is_empty and then not password.is_empty and then STRING_.same_string (authentication_scheme, once "Basic") then
				Result := basic_authorization_value (user_name, password)
			else
				create  Result.make_empty
			end
		end

	basic_authorization_value (a_user_name, a_password: STRING): STRING
		require
			valid_user_name: not a_user_name.is_empty
			valid_password: not a_password.is_empty
		local
			basic_credentials: STRING
			base64_output: KL_STRING_OUTPUT_STREAM
			base64_encoder: UT_BASE64_ENCODING_OUTPUT_STREAM
			basic_authentication: STRING
		do
			create basic_credentials.make (a_user_name.count + 1 + a_password.count)
			basic_credentials.append_string (a_user_name)
			basic_credentials.append_character (':')
			basic_credentials.append_string (a_password)
			create basic_authentication.make (32)
			create base64_output.make(basic_authentication)
			create base64_encoder.make (base64_output, False, False)
			base64_encoder.put_string (basic_credentials)
			base64_encoder.close
			Result := once_basic + " " + basic_authentication
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	do_read_response (including_body: BOOLEAN)
			-- Read response. If authentication is required, and
			-- authentication `user_name' and `password' are available,
			-- resend request with suitable authencation.
		require
			last_verb_attached: attached last_verb
			last_uri_attached: attached last_uri
		local
			retries: INTEGER
			stop: BOOLEAN
		do
			from
			until
				stop
			loop
				do_do_read_response (including_body)
				stop :=
					not is_authentication_required or else
					user_name = Void or else
					password = Void or else
					(attached www_authenticate as a_www_authenticate and then attached a_www_authenticate.stale as stale and then STRING_.same_string (stale, once "false")) or else
					retries >= max_authentication_retries
				if not stop then
					-- Authentication scheme should now be set, so simply retry once
					if attached last_verb as lv and then attached last_uri as lu then
						send_request (lv, lu, last_data)
					end
				end
				retries := retries + 1
			end
		end

	do_do_read_response (including_body: BOOLEAN)
		require
			http_attached: attached http
		local
			my_parser: like parser
		do
			if attached http as stream then
				create my_parser.make_from_stream (stream)
				parser := my_parser
				-- First line contains status code and HTTP version.
				read_and_parse_status_line
				-- Parse while reading.
				if including_body then
					if reuse_connection then
						my_parser.parse_header
						my_parser.parse_body
					else
						my_parser.parse
					end
				else
					my_parser.parse_header
				end
				if my_parser.syntax_error then
					response_code := 500
					response_phrase := once "Syntax error parsing response."
					response := Void
					is_authentication_required := False
				else
					if attached my_parser.part as a_response then
						response := a_response
						debug ("http_client")
							print (response_code.out)
							print (" ")
							print (response_phrase)
							print ("%N")
							print (a_response.as_string)
							print ("%N")
						end
						if not including_body then
							my_parser.read_first_body_part
						end
						if a_response.header.has (field_name_connection) and then STRING_.same_string (a_response.header.item (field_name_connection).value.as_lower, once "close") then
							reuse_connection := False
						end
						is_authentication_required :=
							response_code = reply_code_unauthorized and then
							a_response.header.has (field_name_www_authenticate)
						if is_authentication_required then
							if attached {EPX_MIME_FIELD_WWW_AUTHENTICATE} a_response.header.item (field_name_www_authenticate) as my_www_authenticate then
								www_authenticate := my_www_authenticate
								authentication_scheme := my_www_authenticate.scheme
								if not attached my_www_authenticate.realm then
									-- Bad response
									is_authentication_required := False
								end
							else
								-- Bad response
								is_authentication_required := False
							end
						end
					end
				end
			end
		end

	read_and_parse_status_line
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
			if attached parser as a_parser then
				from
					a_parser.read_character
				until
					a_parser.last_character = '%N' or else
					a_parser.end_of_input
				loop
					status_line.append_character (a_parser.last_character)
					a_parser.read_character
				end
			end

			-- Removing %R if part of CRLF
			if status_line.count > 0 and then status_line.item (status_line.count) = '%R' then
				status_line.remove (status_line.count)
			end

			-- Start of response code code
			p := status_line.index_of (' ', 1)
			-- Detect start of response phrase. Some servers return no
			-- phrase, sigh, so cope with that.
			if p > 1 then
				q := status_line.index_of (' ', p+1)
			end
			if q = 0 then
				q := status_line.count + 1
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
				if q < status_line.count then
					response_phrase := status_line.substring (q+1, status_line.count)
					sh.trim (response_phrase)
				else
					response_phrase := ""
				end
			else
				-- Can we recover from garbage??
				response_code := 500
				response_phrase := ""
				server_version := ""
			end
		end


feature {NONE} -- MIME parser

	escape_spaces (s: STRING): STRING
		require
			s_not_void: s /= Void
		local
			i: INTEGER
		do
			Result := s.twin
			from
				i := 1
			until
				i > Result.count
			loop
				if Result.item (i) = ' ' then
					Result.put ('+', i)
				end
				i := i + 1
			end
		ensure
			not_void: Result /= Void
		end

	parser: detachable EPX_MIME_PARSER
			-- Parse response from HTTP server


feature {NONE} -- Once strings

	once_colon_space: STRING = ": "
	once_connection_close: STRING = "Connection: close%R%N"
	once_mime_version: STRING = "MIME-Version: 1.0%R%N"
	once_new_line: STRING = "%R%N"
	once_basic: STRING = "Basic"


invariant

	have_www_authenticate_header_if_authentication_required:
		is_authentication_required implies attached response as r and then r.header.has (field_name_www_authenticate)
	have_www_authenticate:
		is_authentication_required implies attached www_authenticate

end
