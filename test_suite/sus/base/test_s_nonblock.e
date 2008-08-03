indexing

	description:

		"Test eposix non-blocking socket i/o"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	TEST_S_NONBLOCK


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	EPX_CURRENT_PROCESS


feature

	test_read_line is
			-- Test non-blocking `read_line'.
		local
			host: SUS_HOST
			service: SUS_SERVICE
			echo_socket: SUS_TCP_CLIENT_SOCKET
			sa: EPX_HOST_PORT
		do
			create host.make_from_name ("localhost")
			create service.make_from_name ("echo", "tcp")

			create sa.make (host, service)

			create echo_socket.open_by_address (sa)
			echo_socket.set_blocking_io (False)
			assert ("non-blocking i/o enabled", not echo_socket.is_blocking_io)

			-- Attempt to read with nothing there
			echo_socket.read_line
			assert ("Nothing read", echo_socket.last_string.is_empty)

			echo_socket.write_string (hello_lf)
			-- Non-blocking so, wait a while
			sleep (2)
			echo_socket.read_line
			assert_equal ("Read what written.", hello, echo_socket.last_string)
		end


feature {NONE} -- Implementation

	hello_lf: STRING is "Hello World.%N"
	hello: STRING is "Hello World."


end
