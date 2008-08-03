indexing

	description: "Test SUS tcp/udp/unix sockets by being an echo server and client."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	TEST_S_ECHO_SERVER


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	SUS_FILE_SYSTEM
		export
			{NONE} all
		end

	SUS_CONSTANTS
		export
			{NONE} all
		end


feature

	test_tcp is
			-- Echo client and server, tcp style.
		local
			host: SUS_HOST
			service: SUS_SERVICE
			client_socket: SUS_TCP_CLIENT_SOCKET
			server_socket: SUS_TCP_SERVER_SOCKET
			sa: EPX_HOST_PORT
			client_fd: ABSTRACT_TCP_SOCKET
		do
			create host.make_from_name ("localhost")
			create service.make_from_port (port, "tcp")
			create sa.make (host, service)
			create server_socket.listen_by_address (sa)
			create client_socket.open_by_address (sa)
			assert_equal ("Client address set.", host.addresses.item (host.addresses.lower).out, client_socket.local_address.address.out)
			client_fd := server_socket.accept
			-- Get a random port back, check if that's ok.
			-- assert_equal ("Got my port.", port, server_socket.last_client_address.port)
			assert_equal ("Client address set.", host.addresses.item (host.addresses.lower).out, client_fd.local_address.address.out)
			debug
				print ("Address returned: ")
				print (server_socket.last_client_address.address.out)
				print ("%N")
				print ("Local address on returned socket: ")
				print (client_fd.local_address.address.out)
				print ("%N")
				print ("Remote address on returned socket: ")
				print (client_fd.remote_address.address.out)
				print ("%N")
			end
			client_socket.write_string (hello)
			client_fd.read_string (256)
			assert_equal ("Read what written by client.", hello, client_fd.last_string)
			client_fd.write_string (berend1)
			client_socket.read_string (256)
			assert_equal ("Read what written by server.", berend1, client_socket.last_string)

			client_socket.close
			client_fd.close
			server_socket.close
		end


	test_udp is
			-- Echo client and server, upd style.
		local
			host: SUS_HOST
			service: SUS_SERVICE
			client_socket: SUS_UDP_CLIENT_SOCKET
			server_socket: SUS_UDP_SERVER_SOCKET
			sa: EPX_HOST_PORT
		do
			create host.make_from_name ("localhost")
			create service.make_from_port (port, "udp")
			create sa.make (host, service)
			create server_socket.listen_by_address (sa)
			create client_socket.open_by_address (sa)
			assert_equal ("Client address set.", host.addresses.item (host.addresses.lower).out, client_socket.local_address.address.out)

			client_socket.write_string (hello)
			server_socket.read_string (256)
			assert_equal ("Read what written by client.", hello, server_socket.last_string)
			-- @@BdB: Write will fail, because socket is not connected.
			-- Probably need special write like sendto/sendmsg or so
			-- This points out the need to have is_readable and
			-- is_writable booleans in ABSTRACT_DESCRIPTOR or so, so we
			-- can actually check the precondition.
			-- Also, does an UDP_SERVER/UDP_CLIENT make sense? You either
			-- have a connected or unconnected UDP socket.
			-- server_socket.write_string (berend1)
			-- client_socket.read_string (256)
			-- assert_equal ("Read what written by server.", berend1, client_socket.last_string)

			client_socket.close
			server_socket.close
		end

	test_unix is
			-- Echo client and server, unix style.
		local
			client_socket: SUS_UNIX_CLIENT_SOCKET
			server_socket: SUS_UNIX_SERVER_SOCKET
			client_fd: SUS_UNIX_SOCKET
		do
			if is_existing ("/tmp/eposix") then
				unlink ("/tmp/eposix")
			end
			create server_socket.listen_by_path ("/tmp/eposix", SOCK_STREAM)
			create client_socket.open_by_path ("/tmp/eposix", SOCK_STREAM)
			client_fd := server_socket.accept
			client_socket.write_string (hello)
			client_fd.read_string (256)
			assert_equal ("Read what written by client.", hello, client_fd.last_string)
			client_fd.write_string (berend1)
			client_socket.read_string (256)
			assert_equal ("Read what written by server.", berend1, client_socket.last_string)

			client_socket.close
			client_fd.close
			server_socket.close
			unlink ("/tmp/eposix")
		end


feature {NONE} -- Implementation

	port: INTEGER is 9877
			-- Thanks to W. Richard Stevens

	hello: STRING is "Hello World.%N"
	berend1: STRING is "hello berend%N"

end
