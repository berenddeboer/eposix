class EX_ECHO_TCP

inherit

	SUS_CONSTANTS

create

	make

feature

	make is
			-- Echo client and server, tcp style.
		local
			host: SUS_HOST
			service: SUS_SERVICE
			client_socket: SUS_TCP_CLIENT_SOCKET
			server_socket: SUS_TCP_SERVER_SOCKET
			sa: EPX_HOST_PORT
			client_fd: ABSTRACT_TCP_SOCKET
			correct: BOOLEAN
		do
			create host.make_from_name ("localhost")
			create service.make_from_port (port, "tcp")
			create sa.make (host, service)
			create server_socket.listen_by_address (sa)
			create client_socket.open_by_address (sa)
			client_fd := server_socket.accept
			client_socket.put_string (hello)
			client_fd.read_string (256)
			correct := client_fd.last_string.is_equal (hello)
			if not correct then
				print ("Oops.%N")
			end
			client_fd.put_string (berend)
			client_socket.read_string (256)
			correct := client_socket.last_string.is_equal (berend)
			if not correct then
				print ("Oops.%N")
			end

			client_socket.close
			client_fd.close
			server_socket.close
		end

feature {NONE} -- Implementation

	port: INTEGER is 9877
			-- Thanks to W. Richard Stevens

	hello: STRING is "Hello World.%N"
	berend: STRING is "hello berend%N"

end
