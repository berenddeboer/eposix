indexing

	description:

		"Connection by some client, as seen from EPX_HTTP_SERVER's point of view"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_HTTP_CONNECTION


inherit

	EPX_CURRENT_PROCESS

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		end

	EPX_MIME_FIELD_NAMES
		export
			{NONE} all
		end

	EPX_HTTP_RESPONSE
		export
			{NONE} all;
			{EPX_HTTP_SERVLET,EPX_HTTP_SERVER} is_three_digit_response
		end

	EPX_HTTP_METHODS
		export
			{NONE} all
		end

	EPX_MIME_TYPE_NAMES
		export
			{NONE} all
		end

	EPX_XML_ROUTINES
		export
			{EPX_HTTP_SERVLET} all
		end


create {EPX_HTTP_SERVER}

	make


feature {NONE} -- Initialisation

	make (a_server: EPX_HTTP_SERVER; a_client: ABSTRACT_TCP_SOCKET) is
			-- Initialisation.
		require
			server_not_void: a_server /= Void
			client_not_void: a_client /= Void
			blocking_client: a_client.is_blocking_io
		do
			server := a_server
			client := a_client
			client.set_continue_on_error
			create response_header.make (256)
		end


feature -- Access

	client_http_version: STRING
			--- Client HTTP version in the form of HTTP/x.x

	last_request_receive_time: STDC_TIME
			-- Time of last received request, Void if no request received

	last_response_send_time: STDC_TIME
			-- Time of last send response, Void if no response send

	method: STRING
			-- Method as requested by client;
			-- Set by `parse_request'.

	request_form_fields: DS_HASH_TABLE [EPX_KEY_VALUE, STRING]
			-- If the request body appears to be form data, the data is
			-- extracted into this table;
			-- For dynamic paths the parts are added to this structure
			-- prefixed with "part ". If the part is not send as a form
			-- field, it is also added as a normal form field. So parts
			-- could be listed twice.

	request_body: EPX_MIME_BODY
			-- Request body if defined for the method

	request_fields: DS_HASH_TABLE [EPX_MIME_FIELD, STRING]
			-- Any request header fields send by the client

	request_uri: UT_URI
			-- Absolute URI of request;
			-- Set by `parse_request'.

	response_code: INTEGER
			-- Response code sent to client

	response_header: STRING
			-- Header that is filled by various routines;
			-- Use `send_header' to output it to the client.

	server: EPX_HTTP_SERVER
			-- Server which accepted this connection

	user_agent: EPX_MIME_FIELD is
			-- User-Agent field if present, Void otherwise
		require
			have_request_fields: request_fields /= Void
		do
			request_fields.search (field_name_user_agent)
			if request_fields.found then
				Result := request_fields.found_item
			end
		ensure
			definition: request_fields.has (field_name_user_agent) = (Result /= Void)
		end


feature -- Status

	has_client_disconnected: BOOLEAN is
			-- Has client decided to disconnect?
		do
			-- If connection is not persistent, it means that when the
			-- socket becomes readable, a close has been received.
			Result := not is_persistent and then is_readable
		end

	is_open: BOOLEAN is
			-- Is connection to client open?
		do
			Result := client.is_open
		end

	is_persistent: BOOLEAN
			-- Has client not signalled that it wants to close the
			-- connection after processing?

	is_readable: BOOLEAN is
			-- Has client send new data?
		do
			select_readable.check_for_reading.wipe_out
			select_readable.check_for_reading.put (client)
			select_readable.set_timeout (select_timeout)
			select_readable.execute
			Result := select_readable.ready_for_reading.has (client)
			select_readable.check_for_reading.wipe_out
			select_readable.ready_for_reading.wipe_out
		end

	is_body_send: BOOLEAN
			-- Is a complete body send to `client'?

	is_header_send: BOOLEAN
			-- Is `response_header' send to `client'?

	is_request_parsed: BOOLEAN is
			-- Was `parse_request' successful?
		do
			Result :=
				request_uri /= Void and then
				not is_header_send and then
				client.errno.is_ok and then
				client.is_open
		end

	is_http_09_request: BOOLEAN
			-- Old style HTTP 0.9 request?

	response_header_ends_with_body_separator: BOOLEAN is
			-- Does `response_header' end with the header/body separator?
		do
			Result :=
				response_header.count >= 2 and then
				response_header.item (response_header.count) = '%N' and then
				response_header.item (response_header.count - 1) = '%R' and then
				((response_header.count = 2) or else
				 (response_header.count >= 4) and then
				 (response_header.item (response_header.count - 2) = '%N') and then
				 (response_header.item (response_header.count - 3) = '%R'))
		end


feature -- Change

	clear_request_state is
			-- Reset state variables build/maintained when handling a
			-- request in `parse_request'.
		do
			client_http_version := Void
			request_fields := Void
			response_header.wipe_out
			request_form_fields := Void
			request_body := Void
			is_header_send := False
			is_body_send := False
			response_code := 0
			client.errno.clear_first
		ensure
			request_fields_unset: request_fields = Void
			request_form_fields_unset: request_form_fields = Void
			response_header_empty: response_header.is_empty
			header_not_send: not is_header_send
			body_not_send: not is_body_send
			no_response_code: response_code = 0
		end

	close is
		do
			if client.is_open then
				-- Windows doesn't do a shutdown when closing the descriptor,
				-- so help Bill.
				if client.is_open_read and then client.is_open_write then
					client.shutdown_read_write
				end
				client.close
			end
		end


feature -- Parsing

	parse_request is
			-- Parse the request in `client'.
		require
			client_open: client.is_open
			response_header_empty: response_header.is_empty
			header_not_send: not is_header_send
			body_not_send: not is_body_send
			request_fields_unset: request_fields = Void
			request_form_fields_unset: request_form_fields = Void
		local
			request: STRING
			ar: ARRAY [STRING]
			mime_parser: EPX_MIME_PARSER
			has_content_length,
			has_transfer_encoding: BOOLEAN
			has_body: BOOLEAN
		do
			create last_request_receive_time.make_from_now
			request := read_request_line
			ar := sh.split_on (request, ' ')
			-- I love error checking...
			if ar.count >= 2 and then ar.count <= 3 then
				method := ar.item (ar.lower)
				request_uri := server.to_absolute_uri (ar.item (ar.lower + 1))
				is_http_09_request := ar.count = 2
				if is_http_09_request then
					client_http_version := "HTTP/0.9"
				else
					client_http_version := ar.item (ar.upper)
				end
				if request_uri /= Void then
					--dump_request
					if is_http_09_request then
						create request_fields.make_default
						query_to_form_fields (request_uri)
					else
						create mime_parser.make_from_stream (client)
						mime_parser.parse_header
						if not mime_parser.syntax_error then
							request_fields := mime_parser.part.header.fields
							debug ("httpd")
								dump_request_header
							end
							-- Host header field is required for HTTP/1.1.
							if request_fields.has (field_name_host) then
								-- Check if there is a message body.
								-- This is signaled by the inclusion of a
								-- Content-Length or Transfer-Encoding header
								-- field, section 4.3.
								has_transfer_encoding := mime_parser.part.header.transfer_encoding /= Void
								has_content_length := mime_parser.part.header.content_length /= Void
								has_body := has_transfer_encoding or else has_content_length
								if has_body then
									-- If the Transfer-Encoding header is
									-- present, we have to ignore Content-Length.
									-- I have to check here for a Expect
									-- request-header with the 100-continue
									-- expectation. If so, I must respond
									-- with the 100 continue status.
									if request_fields.has (field_name_expect) then
										if STRING_.same_string (request_fields.item (field_name_expect).value.as_lower, once_100_continue) then
											send_expect_continue
										else
											report_expectation_failed (mime_parser.part.header.item (field_name_expect).value)
										end
									end
									mime_parser.parse_body
									request_body := mime_parser.part.body
									if mime_parser.part.header.content_type /= Void then
										if STRING_.same_string (mime_parser.part.header.content_type.value, mime_type_application_x_www_form_urlencoded) then
											urlencoded_to_form_fields
										elseif STRING_.same_string (mime_parser.part.header.content_type.value, mime_type_multipart_form_data) then
											mime_body_to_form_fields
										end
									end
								else
									query_to_form_fields (request_uri)
								end
								-- Browsers can't send PUT/DELETE requests.
								-- We change `method' here if the
								-- variable http-method:XXXX exists.
								method := remap_http_method (method)
							else
								report_bad_request ("Field '" + field_name_host + "' not present in header (required for HTTP 1.1 requests)")
							end
						else
							report_bad_request (request)
						end
					end
				else
					report_bad_request (request)
				end
				-- Check if client wants a persistent connection.
				if is_http_09_request then
					is_persistent := False
				elseif STRING_.same_string (client_http_version, once_http_1_0) then
					-- For HTTP/1.0 clients we assume a persistent
					-- connection only when explicitly requested.
					is_persistent :=
						request_fields /= Void and then
						request_fields.has (field_name_connection) and then
						STRING_.same_string (request_fields.item (field_name_connection).value.as_lower, once_keep_alive)

				else
					-- For HTTP/1.1 we assume a persistent connection
					-- unless an explicit close is send.
					is_persistent :=
						request_fields /= Void and then
						(not request_fields.has (field_name_connection) or else
						 not STRING_.same_string (request_fields.item (field_name_connection).value.as_lower, once_close))
				end
			else
				-- Only when the request was read successfully, send a bad
				-- report.
				-- IE seems to open a connection but terminate it
				-- immediately (errno 10054) in certain cases.
				if client.errno.is_ok then
					report_bad_request (request)
				else
					close
					debug ("httpd")
						stderr.put_string ("Skip reporting bad request.%N")
					end
				end
			end
			-- According to RFC 2616 8.2.3, if there is no 100-continue
			-- expection, the connection must not be closed until the
			-- entire request body has been read or until the client
			-- closes the connection. Otherwise, the client
			-- might not reliably receive the response message.
			-- I think my code reads the entire body, if the header and
			-- body are well-formed.
		ensure
			last_request_receive_time_not_void: last_request_receive_time /= Void
		end

	read_request_line: STRING is
			-- Read Request-Line from client.
		require
			client_open: client /= Void and then client.is_open
		do
			-- Follow RFC 2616 4.1 in skipping initial empty lines.
			from
				client.read_line
				create Result.make_from_string (client.last_string)
			until
				not client.errno.is_ok or else
				client.end_of_input or else
				not Result.is_empty
			loop
				client.read_line
				create Result.make_from_string (client.last_string)
			end
			debug ("httpd")
				stderr.put_string ("====================%N")
				stderr.put_string (client.last_string)
				stderr.put_character ('%N')
				if not client.errno.is_ok then
					stderr.put_string ("Client reported error reading string: ")
					stderr.put_string (client.errno.first_message)
					stderr.put_string ("%N")
				end
			end
		ensure
			request_line_not_void: Result /= Void
		end


feature -- Access that you probably shouldn't use

	client: ABSTRACT_TCP_SOCKET
			-- Socket to client


feature {EPX_HTTP_SERVER, EPX_HTTP_SERVLET} -- Redirects

	respond_see_other (a_location: STRING) is
			-- Send a 303 (or 302 for older clients) after a successful
			-- PUT/POST/DELETE.
		require
			a_location_not_empty: a_location /= Void and then not a_location.is_empty
		do
			-- For 1.0 or earlier clients a 302 seems to work better.
			if client_http_version >= once_http_1_1 then
				write_response_code (303)
			else
				write_response_code (302)
			end
			write_mime_header (Void)
			add_field (field_name_location, a_location)
			add_field (field_name_content_length, "0")
		end


feature {EPX_HTTP_SERVER, EPX_HTTP_SERVLET} -- Report errors to client

	error_reasons: DS_HASH_TABLE [STRING, INTEGER] is
			-- Slightly more verbose errors than the reason phrase.
		once
			create Result.make (16)
			Result.put ("Request not understood due to malformed syntax", 400)
			Result.put ("Access to this resource is not allowed", 403)
			Result.put ("Resource not found", 404)
			Result.put ("HTTP method not allowed", 405)
			Result.put ("Content-Length field required", 411)
			Result.put ("Internal server error", 500)
			Result.put ("HTTP method or Transfer-Encoding not implemented", 501)
			Result.put ("Timeout waiting for response to request", 504)
		ensure
			error_reasons_not_void: Result /= Void
		end

	report_bad_request (a_request: STRING) is
			-- Return 400 to client.
			-- The request could not be understood by the server due to
			-- malformed syntax. The client SHOULD NOT repeat the request
			-- without modifications.
			-- The bad request, if any , is in `client'.`last_string'.
		require
			header_not_send: not is_header_send
		do
			write_report (400, a_request)
		ensure
			body_send: is_body_send
		end

	report_conflict (a_message: STRING) is
			-- Return 409 to client.
			-- The request could not be completed due to a conflict with
			-- the current state of the resource. This code is only
			-- allowed in situations where it is expected that the user
			-- might be able to resolve the conflict and resubmit the
			-- request. The response body SHOULD include enough
			-- information for the user to recognize the source of the
			-- conflict.  Ideally, the response entity would include
			-- enough information for the user or user agent to fix the
			-- problem; however, that might not be possible and is not
			-- required.
		require
			header_not_send: not is_header_send
		do
			write_report (409, a_message)
		ensure
			body_send: is_body_send
		end

	report_content_length_required is
			-- The server refuses to accept the request without a defined
			-- Content-Length. The client MAY repeat the request if it
			-- adds a valid Content-Length header field containing the
			-- length of the message-body in the request message.
		require
			header_not_send: not is_header_send
		do
			write_report (411, Void)
		ensure
			body_send: is_body_send
		end

	report_expectation_failed (an_expectation: STRING) is
			-- The expectation given in an Expect request-header field
			-- could not be met by this server.
		require
			header_not_send: not is_header_send
		do
			write_report (417, an_expectation)
		ensure
			body_send: is_body_send
		end

	report_forbidden (a_file: STRING) is
			-- Return 403 to the client.
			-- The server understood the request, but is refusing to
			-- fulfill it.  Authorization will not help and the request
			-- SHOULD NOT be repeated.
		require
			header_not_send: not is_header_send
			file_not_empty: a_file /= Void and then not a_file.is_empty
		do
			write_report (403, a_file)
		ensure
			body_send: is_body_send
		end

	report_gateway_timeout is
		require
			header_not_send: not is_header_send
		do
			response_header.wipe_out
			write_report (504, Void)
		ensure
			body_send: is_body_send
		end

	report_internal_server_error (a_message: STRING) is
		require
			header_not_send: not is_header_send
		do
			response_header.wipe_out
			write_report (500, a_message)
		ensure
			body_send: is_body_send
		end

	report_method_not_allowed (a_method, a_allowed_methods: STRING) is
			-- The method specified in the Request-Line is not allowed
			-- for the resource identified by the Request-URI. The
			-- response MUST include an Allow header containing a list of
			-- valid methods for the requested resource.
		require
			header_not_send: not is_header_send
			a_method_not_empty: a_method /= Void and then not a_method.is_empty
			a_allowed_methods_not_void: a_allowed_methods /= Void
		do
			write_report_header (405)
			add_field (field_name_allow, a_allowed_methods)
			write_report_body (405, a_method)
		ensure
			body_send: is_body_send
		end

	report_not_found (a_uri: STRING) is
			-- Return 404 to the client.
			-- The server has not found anything matching the Request-URI.
		require
			header_not_send: not is_header_send
			file_not_empty: a_uri /= Void and then not a_uri.is_empty
		do
			write_report (404, a_uri)
		ensure
			body_send: is_body_send
		end

	report_not_implemented (a_method: STRING) is
			-- Return 501 to client.
			-- The server does not support the functionality required to
			-- fulfill the request. This is the appropriate response when
			-- the server does not recognize the request method and is
			-- not capable of supporting it for any resource.
		require
			header_not_send: not is_header_send
		do
			write_report (501, a_method)
		ensure
			body_send: is_body_send
		end

	report_unmodified is
			-- Resource is not modified, respond with 304.
		require
			header_not_send: not is_header_send
		local
			time: STDC_TIME
		do
			write_response_code (304)
			create time.make_from_now
			time.to_utc
			add_field (field_name_date, time.rfc_date_string)
			if not is_persistent then
				add_field (field_name_connection, once_close)
			end
			-- And blank line to separate body
			add_new_line
			send_header
		end


	write_report (a_code: INTEGER; a_parameter: STRING) is
			-- Send an error report to `client'.
		require
			header_not_send: not is_header_send
			three_digit_response: is_three_digit_response (a_code)
		do
			write_report_header (a_code)
			write_report_body (a_code, a_parameter)
		ensure
			body_send: is_body_send
		end

	write_report_header (a_code: INTEGER) is
			-- Generate header of an error report to `client'.
			-- Header will be send by `write_report_body'.
		require
			three_digit_response: is_three_digit_response (a_code)
		do
			response_header.wipe_out
			write_response_code (a_code)
			write_mime_header (Void)
		end

	write_report_body (a_code: INTEGER; a_parameter: STRING) is
			-- Assumes header is in `response_header' and not yet send.
		require
			three_digit_response: is_three_digit_response (a_code)
			header_not_send: not is_header_send
		local
			reason: STRING
			xhtml: EPX_XHTML_WRITER
		do
			if not response_header_ends_with_body_separator then
				add_new_line
			end
			send_header
			-- No errors when returning header?
			if client.is_open then
				if error_reasons.has (a_code) then
					reason := error_reasons.item (a_code)
				else
					reason := reason_phrase (a_code)
					if reason.is_empty then
						reason := a_code.out
					end
				end
				create xhtml.make
				xhtml.doctype_strict
				xhtml.b_html
				xhtml.b_head
				xhtml.title (reason)
				xhtml.e_head
				xhtml.b_body
				xhtml.b_p
				xhtml.add_data (reason)
				if a_parameter /= Void then
					if not is_string (a_parameter) then
						xhtml.add_data (": [passed parameter has invalid control characters]")
					else
						xhtml.add_data (": ")
						if a_parameter.has ('%N') then
							xhtml.e_p
							xhtml.b_pre
							xhtml.add_data (a_parameter)
							xhtml.e_pre
							xhtml.b_p
						else
							xhtml.add_data (a_parameter)
						end
					end
				end
				if
					(a_parameter = Void) or else
					(a_parameter.count > 0 and then
					 a_parameter.item (a_parameter.count) /= '.')
				then
					xhtml.add_data (".")
				end
				xhtml.e_p
				xhtml.e_body
				reach_ie_error_treshold (xhtml)
				xhtml.e_html
				send_body (xhtml.as_uc_string)
			else
				-- Fake this for postcondition
				is_body_send := True
			end
		ensure
			header_send: is_header_send
			body_send: is_body_send
		end


feature {EPX_HTTP_SERVLET,EPX_HTTP_SERVER} -- Response and headers to client

	write_mime_header (content_type: STRING) is
			-- Add default mime header fields for this server. Result is
			-- not written immediately to client. Call `send_header' to do that.
		require
			header_not_ended: not response_header_ends_with_body_separator
		local
			time: STDC_TIME
		do
			add_field (field_name_server, server.server_name)
			create time.make_from_now
			time.to_utc
			add_field (field_name_date, time.rfc_date_string)
			add_field (field_name_mime_version, once_mime_version)
			-- text/html works for all browsers
			-- but I rather want to serve application/xhtml+xml
			-- Test if client accepts that and if it isn't Opera.
			-- Opera 7 says it accepts it, but doesn't execute JavaScript.
			-- It's up to the client to actually supply XHTML in the
			-- served files and servlets, but it's a great debugging help.
			if content_type /= Void and then not content_type.is_empty then
				add_field (field_name_content_type, content_type)
			else
				if request_fields /= Void and then request_fields.has (field_name_accept) and then request_fields.item (field_name_accept).value.has_substring (mime_type_application_xhtml_plus_xml) then
					if
						server.serve_xhtml_if_supported and then
						user_agent /= Void and then
						user_agent.value.substring_index (once_opera_7, 1) = 0
					then
						add_field (field_name_content_type, mime_type_application_xhtml_plus_xml)
					else
						add_field (field_name_content_type, mime_type_text_html)
					end
				else
					add_field (field_name_content_type, mime_type_text_html)
				end
			end
			add_field (field_name_accept_ranges, once_none)
			if not is_persistent then
				add_field (field_name_connection, once_close)
			end
		end

	write_response_code (a_code: INTEGER) is
			-- Add HTTP response status line to `response_header'.
		require
			response_header_empty: response_header.is_empty
			three_digit_response: is_three_digit_response (a_code)
		local
			s: STRING
		do
			response_code := a_code
			response_header.append_string (once_http_version)
			response_header.append_string (a_code.out)
			s := reason_phrase (a_code)
			if not s.is_empty then
				response_header.append_character (' ')
				response_header.append_string (s)
			end
			add_new_line
		ensure
			response_code_added: not response_header.is_empty
			response_code_set: response_code = a_code
		end


feature {EPX_HTTP_SERVER, EPX_HTTP_SERVLET} -- Client output helpers

	ie_error_treshold: INTEGER is 512

	reach_ie_error_treshold (xml: EPX_XML_WRITER) is
			-- Horror, horror, overcome IE ErrorTresholds...
			-- You need this if the body of a response is less than
			-- 128..512 bytes and you have a response code >= 400 and you
			-- want to support IE.
		require
			header_send: is_header_send
		local
			a_body: STRING
			s: STRING
		do
			if response_code >= 400 then
				a_body := xml.unfinished_xml
				if a_body /= Void and then not a_body.is_empty then
					if a_body.count < ie_error_treshold then
						create s.make_filled ('X', ie_error_treshold - a_body.count)
						xml.add_comment (s)
					end
				end
			end
		end

	send_body (a_body: STRING) is
			-- Assume `a_body' is the entire body.
			-- If there is an error sending `s' to the client, the
			-- connection will be closed.
		require
			header_send: is_header_send
		do
			if has_client_disconnected then
				close
			else
				send_string (a_body)
				create last_response_send_time.make_from_now
			end
			is_body_send := True
		ensure
			body_send: is_body_send
			last_response_send_time_not_void: last_response_send_time /= Void
		end

	send_expect_continue is
			-- Immediately send a 100 Continue response to the client.
			-- If there is an error sending `s' to the client, the
			-- connection will be closed.
		require
			response_header_empty: response_header.is_empty
		do
			write_response_code (100)
			send_string (response_header)
			response_header.wipe_out
		ensure
			response_header_empty: response_header.is_empty
		end

	send_header is
			-- Send `response_header' to client.
			-- If there is an error sending `s' to the client, the
			-- connection will be closed.
		require
			header_not_send: not is_header_send
			header_ends_with_body_separator: response_header_ends_with_body_separator
		do
			send_string (response_header)
			create last_response_send_time.make_from_now
			is_header_send := True
		ensure
			header_send: is_header_send
			last_response_send_time_not_void: last_response_send_time /= Void
		end

	send_string (s: STRING) is
			-- Write `s' to `client'.
			-- Using this routine has the advantage that output to client
			-- can be written to `stderr', if you desire to do so.
			-- If there is an error sending `s' to the client, the
			-- connection will be closed.
		do
			if s /= Void and then not s.is_empty then
				debug ("httpd")
					if s.count <= 2048 then
						stderr.put_string (s)
					else
						stderr.put_string (s.substring (1, 2048))
						stderr.put_string ("...%N")
					end
				end
				client.put_string (s)
				if client.errno.is_not_ok then
					client.close
				end
			end
		end

	add_field (a_field_name, a_content: STRING) is
			-- Add a MIME field to `report_header'.
		require
			header_not_ended: not response_header_ends_with_body_separator
			a_field_name_not_empty: a_field_name /= Void and then not a_field_name.is_empty
		do
			response_header.append_string (a_field_name)
			response_header.append_string (once_colon)
			if a_content /= Void and then not a_content.is_empty then
				response_header.append_string (a_content)
			end
			add_new_line
		end

	add_new_line is
			-- Add a new line to `response_header'.
		require
			header_not_ended: not response_header_ends_with_body_separator
		do
			response_header.append_character ('%R')
			response_header.append_character ('%N')
		end


feature {NONE} -- Conversion of MIME body to form fields

	mime_body_to_form_fields is
			-- Convert a multipart/form-data body to key/value pairs.
			-- If a body is not of the proper format, it is not returned.
		require
			request_body_set: request_body /= Void
		local
			equality_tester: UC_STRING_EQUALITY_TESTER
		do
			if request_body.is_multipart then
				request_form_fields := url_encoder.mime_encoded_to_field_name_value_pair (Void, request_body)
			else
				create request_form_fields.make_default
				create equality_tester
				request_form_fields.set_key_equality_tester (equality_tester)
			end
		ensure
			request_form_fields_not_void: request_form_fields /= Void
			not_too_many_request_form_fields: request_form_fields.count <= request_body.parts_count
		end

	query_to_form_fields (a_uri: UT_URI)	is
			-- Translate the query part of a URL to `request_form_fields'.
		require
			uri_not_void: a_uri /= Void
		local
			equality_tester: UC_STRING_EQUALITY_TESTER
		do
			if a_uri.has_query then
				request_form_fields := url_encoder.url_encoded_to_field_name_value_pair (a_uri.query)
			else
				create request_form_fields.make_default
				create equality_tester
				request_form_fields.set_key_equality_tester (equality_tester)
			end
		ensure
			request_form_fields_not_void: request_form_fields /= Void
		end

	urlencoded_to_form_fields is
			-- Convert a form-urlencoded body to key/value pairs.
		require
			request_body_set: request_body /= Void
			not_multipart: not request_body.is_multipart
		do
			request_form_fields := url_encoder.url_encoded_to_field_name_value_pair (request_body.as_string)
		ensure
			request_form_fields_not_void: request_form_fields /= Void
		end


feature {NONE} -- Implementation

	remap_http_method (a_method: STRING): STRING is
			-- Returns the HTTP method to use if `a_method' is POST and one
			-- of the variables starts with "http-method:". The string
			-- after "http-method:" is used as the method the user
			-- actually wanted to sent. Useful for browsers that can send
			-- only GET/POST.
		require
			method_not_empty: a_method /= Void and then not a_method.is_empty
			request_form_fields_not_void: request_form_fields /= Void
		local
			value: EPX_KEY_VALUE
			p: INTEGER
		do
			if STRING_.same_string (a_method, http_method_POST) then
				from
					request_form_fields.start
				until
					Result /= Void or else
					request_form_fields.after
				loop
					value := request_form_fields.item_for_iteration
					p := value.key.substring_index (once_http_method, 1)
					if p = 1 then
						Result := value.key.substring (p + once_http_method.count, value.key.count)
					end
					request_form_fields.forth
				end
			end
			if Result = Void then
				Result := a_method
			end
		ensure
			remapped_method_not_empty: Result /= Void and then not Result.is_empty
		end

	select_readable: EPX_SELECT is
			-- Test if `client' socket becomes readable
		once
			create Result.make
		ensure
			select_readable_not_void: Result /= Void
		end

	select_timeout: EPX_TIME_VALUE is
			-- Immediate timeout for `select_readable'
		do
			create Result.make
		ensure
			select_timeout_not_void: Result /= Void
			immediate_timeout: Result.microseconds = 0 and Result.seconds = 0
		end

	url_encoder: expanded EPX_URL_ENCODING
			-- Decoding of encoded passed values


feature {NONE} -- Debugging

	dump_request is
			-- Debug helper, dumps raw client request to stdout.
		do
			from
				client.read_character
			until
				client.end_of_input
			loop
				fd_stdout.write_character (client.last_character)
				client.read_character
			end
		end

	dump_request_header is
			-- Dump some header fields from the request.
		do
			stderr.put_string (field_name_user_agent)
			stderr.put_string (": ")
			if user_agent /= Void then
				stderr.put_string (user_agent.value)
			else
				stderr.put_string ("<not set>")
			end
			stderr.put_character ('%N')
			if request_fields.has (field_name_connection) then
				stderr.put_string (field_name_connection)
				stderr.put_string (": ")
				stderr.put_string (request_fields.item (field_name_connection).value)
				stderr.put_character ('%N')
			end
			if request_fields.has (field_name_authorization) then
				stderr.put_string (field_name_authorization)
				stderr.put_string (": ")
				stderr.put_string (request_fields.item (field_name_authorization).value)
				stderr.put_character ('%N')
			end
			if request_fields.has (field_name_if_modified_since) then
				stderr.put_string (field_name_if_modified_since)
				stderr.put_string (": ")
				stderr.put_string (request_fields.item (field_name_if_modified_since).value)
				stderr.put_character ('%N')
			end
			if request_fields.has (field_name_if_none_match) then
				stderr.put_string (field_name_if_none_match)
				stderr.put_string (": ")
				stderr.put_string (request_fields.item (field_name_if_none_match).value)
				stderr.put_character ('%N')
			end
			stderr.put_character ('%N')
		end


feature {NONE} -- Once STRINGs, Eiffel's worst feature

	once_http_1_0: STRING is "HTTP/1.0"
	once_http_1_1: STRING is "HTTP/1.1"
	once_100_continue: STRING is "100-continue"
	once_close: STRING is "close"
	once_colon: STRING is ": "
	once_http_version: STRING is "HTTP/1.1 "
	once_keep_alive: STRING is "keep-alive"
	once_mime_version: STRING is "1.0"
	once_none: STRING is "none"
	once_opera_7: STRING is "Opera/7."
	once_http_method: STRING is "http-method:"


invariant

	client_not_void: client /= Void
	response_header_not_void: response_header /= Void
	--client_http_version_known: client_http_version /= Void and then not client_http_version.is_empty
	body_send_implies_header_send: is_body_send implies is_header_send

end
