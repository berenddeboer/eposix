indexing

	description: "Test EPX layer tcp/udp sockets by being an echo server and client."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	TEST_EPX_ECHO_SERVER


inherit

	TS_TEST_CASE


feature

	test_tcp is
			-- Echo client and server, tcp style.
		local
			host: EPX_HOST
			service: EPX_SERVICE
			hp: EPX_HOST_PORT
			server_socket: EPX_TCP_SERVER_SOCKET
			client_socket: EPX_TCP_CLIENT_SOCKET
			client_fd: ABSTRACT_TCP_SOCKET
		do
			create service.make_from_port (port, "tcp")
			create host.make_from_name ("localhost")
			assert ("Host name resolved.", host.found)
			create hp.make (host, service)

			create server_socket.listen_by_address (hp)
			create client_socket.open_by_address (hp)
			assert_equal ("Client address set.", host.addresses.item (host.addresses.lower).out, client_socket.local_address.address.out)

			client_fd := server_socket.accept

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


feature {NONE} -- Implementation

	port: INTEGER is 9877
			-- Thanks to W. Richard Stevens

	hello: STRING is "Hello World.%N"
	berend1: STRING is "hello berend%N"

end
