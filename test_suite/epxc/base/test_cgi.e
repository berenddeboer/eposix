indexing

	description: "Test cgi class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	TEST_CGI


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		redefine
			initialize
		end

	EPX_CGI
		rename
			execute as do_execute
		end


feature -- Initialization

	initialize is
			-- Initialize current test case.
			-- (This routine is called by the creation routine
			-- and can be redefined in descendant classes.)
		do
			make_xhtml_writer
		end


feature -- Test

	test_execute is
		do
			make_no_rescue
		end


feature -- Execution

	do_execute is
		do
			content_text_html

			doctype
			b_html

			b_head
			title ("e-POSIX CGI example.")
			e_head

			b_body

			b_p
			puts ("This is ")
			a ("http://www.pobox.com/~berend", "a link")
			puts (".")
			e_p

			b_p
			puts ("auth type: ")
			puts (auth_type)
			e_p

			b_p
			puts ("gateway interface: ")
			puts (gateway_interface)
			e_p

			b_p
			puts ("query_string: ")
			puts (query_string)
			e_p

			b_p
			puts ("path_info: ")
			puts (path_info)
			e_p

			b_p
			puts ("path_translated: ")
			puts (path_translated)
			e_p

			b_p
			puts ("remote address: ")
			puts (remote_address)
			e_p

			b_p
			puts ("remote host: ")
			puts (remote_host)
			e_p

			b_p
			puts ("remote user: ")
			puts (remote_user)
			e_p

			b_p
			puts ("remote ident: ")
			puts (remote_ident)
			e_p

			b_p
			puts ("request method: ")
			puts (request_method)
			e_p

			b_p
			puts ("script name: ")
			puts (script_name)
			e_p

			b_p
			puts ("server name: ")
			puts (server_name)
			e_p

			b_p
			puts ("server port: ")
			puts (server_port.out)
			e_p

			b_p
			puts ("server protocol: ")
			puts (server_protocol)
			e_p

			b_p
			puts ("server software: ")
			puts (server_software)
			e_p

			b_p
			puts ("http accept: ")
			puts (http_accept)
			e_p

			b_p
			puts ("http referer: ")
			puts (http_referer)
			e_p

			b_p
			puts ("http user agent: ")
			puts (http_user_agent)
			e_p

			p ("Test with &, a < and a >.")

			b_p
			b_a ("test?abc=12345&test=this&another=that")
			assert_strings_equal ("attribute properly encoded.", "test?abc=12345&amp;test=this&amp;another=that", get_attribute ("href"))
			puts ("test")
			e_a
			e_p

			e_body
			e_html
		end


end
