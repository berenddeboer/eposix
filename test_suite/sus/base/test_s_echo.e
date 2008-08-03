indexing

	description: "Test SUS tcp sockets by using the echo service."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


deferred class

	TEST_S_ECHO


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	POSIX_CURRENT_PROCESS


feature -- Tests

	test_tcp is
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
			echo_socket.write_string (hello)
			echo_socket.read_string (256)
			assert_equal ("Read what written.", hello, echo_socket.last_string)
			echo_socket.write_string (berend1)
			echo_socket.read_string (256)
			assert_equal ("Read what written.", berend1, echo_socket.last_string)

			-- when we write something without %N we block in read_string
			-- this shouldn't be the case for non_blocking i/o
			echo_socket.set_blocking_io (False)
			echo_socket.write_string (berend2)
			sleep (2) -- wait until got reply
			echo_socket.read_string (256)
			assert_equal ("Read what written.", berend2, echo_socket.last_string)
			echo_socket.close
		end

	test_udp is
		local
			host: SUS_HOST
			service: SUS_SERVICE
			echo_socket: SUS_UDP_CLIENT_SOCKET
			sa: EPX_HOST_PORT
		do
			create host.make_from_name ("localhost")
			create service.make_from_name ("echo", "udp")

			create sa.make (host, service)

			create echo_socket.open_by_address (sa)
			echo_socket.write_string (hello)
			echo_socket.read_string (256)
			assert_equal ("Read what written.", hello, echo_socket.last_string)
			echo_socket.write_string (berend1)
			echo_socket.read_string (256)
			assert_equal ("Read what written.", berend1, echo_socket.last_string)

			-- when we write something without %N we block in read_string
			-- this shouldn't be the case for non_blocking i/o
			echo_socket.set_blocking_io (False)
			echo_socket.write_string (berend2)
			sleep (2) -- wait until got reply
			echo_socket.read_string (256)
			assert_equal ("Read what written.", berend2, echo_socket.last_string)
			echo_socket.close
		end


feature {NONE} -- Implementation

	hello: STRING is "Hello World.%N"
	berend1: STRING is "hello berend%N"
	berend2: STRING is "hello berend"


end
