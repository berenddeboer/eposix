indexing

	description: "Test HTTP client by connecting to an HTTP server."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #8 $"


deferred class

	TEST_HTTP_SERVER

inherit

	TS_TEST_CASE


feature

	test_basics is
		do
			-- Create webserver
			create server.make (port, ".")
			server.listen_locally
			-- Shouldn't block on this one
			-- BeOS does, because it does not have nonblocking sockets??
			-- It has them, but non-standard way of calling.q
			server.process_next_request

			-- Connect client
			create client.make_with_port ("localhost", port)
			client.set_accept ("application/xhtml+xml")

			-- Send request
			client.get ("/index.html")

			-- Parse it
			server.process_next_request

			-- Dump output

			client.read_response
			if not client.is_response_ok then
				if client.body /= Void then
					print ("=====  response error =====%N")
					print (client.body.as_string)
					print ("=====  response error =====%N")
				end
			end
			assert_integers_equal ("File found.", 200, client.response_code)

			client.head ("/index.html")
			server.process_next_request
			client.read_response
			assert_integers_equal ("Head returned.", 200, client.response_code)
			assert ("No body returned.", client.body.as_string.is_empty)

			server.shutdown
		end

	test_builtin_resources is
			-- Test resources with a fixed path.
		local
			my_servlet: MY_HTTP_SERVLET
			post_data: EPX_MIME_PART
			field: EPX_MIME_FIELD
			body: EPX_MIME_BODY_MULTIPART
			input_part: EPX_MIME_PART
			input_text: EPX_MIME_BODY_TEXT
		do
			create server.make_virtual (port)
			server.listen_locally
			create my_servlet.make
			server.register_fixed_resource ("/list/customers", my_servlet)
			create client.make_with_port ("localhost", port)

			client.get ("/list/customers")
			server.process_next_request
			client.read_response
			assert_integers_equal ("Customers found.", 200, client.response_code)

			client.get ("/index.html")
			server.process_next_request
			client.read_response
			assert_integers_equal ("Really virtual.", 404, client.response_code)

			client.delete ("/list/customers", Void)
			server.process_next_request
			client.read_response
			assert_integers_equal ("Delete not implemented.", 405, client.response_code)

			create post_data.make_empty
			create {EPX_MIME_FIELD_CONTENT_TYPE} field.make ("application", "x-www-form-urlencoded")
			post_data.header.add_field (field)
			post_data.create_multipart_body
			body ?= post_data.body
			input_part := body.new_part
			create {EPX_MIME_FIELD_CONTENT_DISPOSITION} field.make_name ("form-data", "input1")
			input_part.header.add_field (field)
			input_part.create_singlepart_body
			input_text ?= input_part.body
			input_text.append_string ("hello world %R%Nnext line")
			input_part := body.new_part
			create {EPX_MIME_FIELD_CONTENT_DISPOSITION} field.make_name ("form-data", "input2")
			input_part.header.add_field (field)
			input_part.create_singlepart_body
			input_text ?= input_part.body
			input_text.append_string ("12345")
			client.post ("/list/customers/customer", post_data)
			server.process_next_request
			client.read_response
			assert_integers_equal ("Resource unknown.", 403, client.response_code)
			assert_integers_equal ("Got two fields.", 2, server.connection.request_form_fields.count)

			create post_data.make_empty
			create {EPX_MIME_FIELD_CONTENT_TYPE} field.make_multipart ("form-data", "_=_AaB03x_=_")
			post_data.header.add_field (field)
			post_data.create_multipart_body
			body ?= post_data.body
			input_part := body.new_part
			create {EPX_MIME_FIELD_CONTENT_DISPOSITION} field.make_name ("form-data", "input1")
			input_part.header.add_field (field)
			input_part.create_singlepart_body
			input_text ?= input_part.body
			input_text.append_string ("hello world")
			client.post ("/list/customers", post_data)
			server.process_next_request
			client.read_response
			assert_integers_equal ("Got something.", 200, client.response_code)
			assert_integers_equal ("Got one field.", 1, server.connection.request_form_fields.count)
			if client.body /= Void then
				print ("=====  servlet POST response =====%N")
				print (client.body.as_string)
				print ("=====  servlet POST response =====%N")
			end

			server.shutdown
		end

	test_dynamic_resources is
		local
			my_servlet: MY_HTTP_SERVLET
		do
			create server.make_virtual (port)
			server.listen_globally
			create my_servlet.make
			server.register_dynamic_resource ("/list/customers/(name)", my_servlet)
			create client.make_with_port ("localhost", port)

			client.get ("/list/customers/peter")
			server.process_next_request
			client.read_response
			assert_integers_equal ("Customer peter found.", 200, client.response_code)
			-- parts are listed twice
			assert_integers_equal ("Got one field.", 2, my_servlet.last_request_form_fields.count)

			client.get ("/list/customers/peter/a")
			server.process_next_request
			client.read_response
			assert_integers_equal ("Peter has no resource a.", 404, client.response_code)

			client.get ("/a/list/customers/peter")
			server.process_next_request
			client.read_response
			assert_integers_equal ("Only found under absolute name .", 404, client.response_code)
			client.get ("/list/customers/john")
			server.process_next_request
			client.read_response
			assert_integers_equal ("Customer john found.", 200, client.response_code)

			client.get ("/list/customers/john/")
			server.process_next_request
			client.read_response
			assert_integers_equal ("john has no subdirectory.", 404, client.response_code)

			server.register_dynamic_resource ("/list/customers/(name)/(kid)", my_servlet)

			client.get ("/list/customers/peter")
			server.process_next_request
			client.read_response
			assert_integers_equal ("Customer peter still found.", 200, client.response_code)

			client.get ("/list/customers/peter/john")
			server.process_next_request
			client.read_response
			assert_integers_equal ("Customer peter has kid john.", 200, client.response_code)
			assert_integers_equal ("Got two fields.", 4, my_servlet.last_request_form_fields.count)

			server.shutdown
		end

	test_robustness is
			-- Test robustness of server against wrong URLs.
		do
			create server.make (port, ".")
			server.listen_locally
			create client.make_with_port ("localhost", port)

			-- Send request for not existing resource
			do_test_url ("/test.html", "File not found.", 404)

			-- URLs with ..
			do_test_url ("/../test.html", "Does not exist.", 404)
			do_test_url ("../test.html", "Path not absolute.", 400)
			do_test_url ("/../index.html", "Seen as /index.html", 200)
			do_test_url ("../index.html", "Path not absolute.", 400)
			-- It does not matter to advance and backup to directories
			do_test_url ("/TESTGEN/../index.html", "Advance to and backup from existing directory is ok.", 200)
			do_test_url ("/notexisting/../index.html", "Advance to and backup from non-existing directory is ok.", 200)
			-- Test if we can get out of the box to detect what directory
			-- we're running in.
			do_test_url ("/../http_server/index.html", "Cannot detect what is the root directory.", 404)
			do_test_url ("../http_server/index.html", "Path not absolute.", 400)

			server.shutdown
		end


feature {NONE} -- Test helpers

	do_test_url (a_path: STRING; test_msg: STRING; expected_response: INTEGER) is
		require
			server_not_void: server /= Void
			client_not_void: client /= Void
			three_digit_response: expected_response >= 100 and expected_response <= 999
		do
			client.get (a_path)
			server.process_next_request
			client.read_response
			assert_integers_equal (test_msg + ": " + a_path, expected_response, client.response_code)
		end


feature {NONE} -- Implementation

	server: EPX_HTTP_SERVER
	client: EPX_HTTP_11_CLIENT

	port: INTEGER is 9877
			-- Thanks to W. Richard Stevens

end
