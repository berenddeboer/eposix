note

	description: "Test HTTP client by connecting to an HTTP server."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #9 $"

	notes: "Need VE 4.0 with patched STRING, or a higher version."


deferred class

	TEST_HTTP_CLIENT


inherit

	TS_TEST_CASE

	EPX_MIME_FIELD_NAMES
		export
			{NONE} all
		end

	EPX_HTTP_REPLY_CODE
		export
			{NONE} all
		end


feature

	test_get
		local
			client: EPX_HTTP_10_CLIENT
			content_length: EPX_MIME_FIELD_CONTENT_LENGTH
		do
			--create client.make ("localhost")
			create client.make ("www.freebsd.org")
			--create client.make_from_port ("swiki.gsug.org", 8080)
			client.get ("/index.html")
			client.read_response
			--assert_equal ("Version version", "HTTP/1.0", client.server_version)
			assert_integers_equal ("Response code", reply_code_ok, client.response_code)
			assert_equal ("Response phrase", "OK", client.response_phrase)
			client.fields.search (field_name_content_length)
			assert ("Has Content-Length", client.fields.found)
			content_length ?= client.fields.found_item
			assert ("Content-Length positive", content_length.length > 0)
			assert_not_equal ("Body available", Void, client.body)
			assert ("last_uri set",  not client.last_uri.is_empty)
			debug ("test")
				print ("URI: ")
				print (client.body.stream.name)
				print ("%N%N")
				print (client.body.as_string)
			end

			-- a second time
			client.get ("/gifs/freebsd_1.gif")
			client.read_response
		end

	test_non_existing
		local
			client: EPX_HTTP_10_CLIENT
		do
			create client.make ("www.freebsd.org")
			client.get ("/nonexisting.html")
			client.read_response
			--assert_equal ("Version version", "HTTP/1.0", client.server_version)
			assert_integers_equal ("Response code", 404, client.response_code)
			assert_equal ("Response phrase", "Not Found", client.response_phrase)
		end

	test_head
			-- test HEAD command.
		local
			client: EPX_HTTP_10_CLIENT
			content_length: EPX_MIME_FIELD_CONTENT_LENGTH
		do
			create client.make ("www.freebsd.org")
			client.head ("/index.html")
-- 			from
-- 				client.http.read_line
-- 			until
-- 				client.http.end_of_input
-- 			loop
-- 				print (client.http.last_string)
-- 				print ("%N")
-- 				client.http.read_line
-- 			end
			client.read_response
			--assert_equal ("Version version", "HTTP/1.0", client.server_version)
			assert_integers_equal ("Response code", reply_code_ok, client.response_code)
			assert_equal ("Response phrase", "OK", client.response_phrase)
			assert ("Has Last-Modified", client.fields.has (field_name_last_modified))
			client.fields.search (field_name_content_length)
			assert ("Has Content-Length", client.fields.found)
			content_length ?= client.fields.found_item
			assert ("Content-Length positive", content_length.length > 0)
		end

	test_options
			-- test OPTIONS command.
		local
			client: EPX_HTTP_11_CLIENT
		do
			create client.make ("www.apache.org")
			client.options ("/index.html")
			client.read_response
			--assert_equal ("Version version", "HTTP/1.1", client.server_version)
			--assert_equal ("Version version", "HTTP/1.0", client.server_version)
			assert_integers_equal ("Response code", reply_code_ok, client.response_code)
			assert_equal ("Response phrase", "OK", client.response_phrase)
			assert ("Has Allow", client.fields.has (field_name_allow))
		end

	test_transfer_encoding_chunked
			-- Test if chunked response is handled correctly.
		local
			client: EPX_HTTP_11_CLIENT
		do
			create client.make ("jigsaw.w3.org")
			client.get ("/HTTP/ChunkedScript")
			client.read_response
			assert_integers_equal ("Response code", reply_code_ok, client.response_code)
			assert_equal ("Response phrase", "OK", client.response_phrase)
-- 			client.read_raw_response
-- 			print (client.raw_response)
		end

	test_transfer_encoding_chunked2
		local
			client: EPX_HTTP_11_CLIENT
		do
			create client.make ("www.fgeorges.org")
			client.get ("/tmp/test-suite-gen.xsl")
			client.read_raw_response
			client.get ("/tmp/gexslt-exception.xts")
			client.read_raw_response
		end

	test_basic_authentication
		local
			client: EPX_HTTP_10_CLIENT
			s: STRING
		do
			create client.make ("call_center")
			client.get ("/my/")
			client.read_response_with_redirect
			assert_integers_equal ("Response code", reply_code_unauthorized, client.response_code)
			debug ("test-http")
				create s.make_empty
				client.response.header.append_fields_to_string (s)
				print (s)
			end
			assert ("Have WWW-Authenticate header", client.response.header.fields.has (field_name_www_authenticate))
			assert ("Authentication required", client.is_authentication_required)
			assert ("Authentication type required", not client.authentication_scheme.is_empty)
			client.set_user_name_and_password ("berend", "berend")
			client.get ("/my/")
			client.read_response
			debug ("test-http")
				print (client.response_code.out + " " + client.response_phrase + "%N")
				create s.make_empty
				client.response.header.append_fields_to_string (s)
				print (s)
			end
			assert ("Validated", client.is_response_ok)
		end

	test_digest_authentication
		local
			client: EPX_HTTP_11_CLIENT
			s: STRING
		do
			create client.make ("www.berenddeboer.net")
			client.get ("/rest/site/.login")
			client.read_response
			assert_integers_equal ("Response code", reply_code_unauthorized, client.response_code)
			debug ("test-http")
				print (client.response_code.out + " " + client.response_phrase + "%N")
				create s.make_empty
				client.response.header.append_fields_to_string (s)
				print (s)
			end
			assert ("Have WWW-Authenticate header", client.response.header.fields.has (field_name_www_authenticate))
			assert ("Authentication required", client.is_authentication_required)
			assert ("Authentication type required", not client.authentication_scheme.is_empty)
			client.set_user_name_and_password ("myname", "test")
			client.get ("/rest/site/.login")
			-- Expect:
			--   WWW-Authenticate: Digest realm="My Site" nonce="BOon8SqoBAA=02ea03afec907914d304788e559e1e6c9279801d" algorithm="MD5" qop="auth"
			client.read_response
			-- And send:
			--   Authorization: Digest username="myname", realm="My Site", nonce="BOon8SqoBAA=02ea03afec907914d304788e559e1e6c9279801d", uri="/rest/site/.login", response="1754c90b74d609fe5e32604f3a0ca62b"
			debug ("test-http")
				print (client.response_code.out + " " + client.response_phrase + "%N")
				create s.make_empty
				client.response.header.append_fields_to_string (s)
				print (s)
			end
			assert_integers_equal ("Validated", 302, client.response_code)
		end

end
