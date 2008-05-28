class EX_ECHO_UNIX

inherit

	SUS_FILE_SYSTEM

	SUS_CONSTANTS

create

	make

feature

	make is
			-- Echo client and server, unix style.
		local
			client_socket: SUS_UNIX_CLIENT_SOCKET
			server_socket: SUS_UNIX_SERVER_SOCKET
			client_fd: SUS_UNIX_SOCKET
			correct: BOOLEAN
		do
			if is_existing ("/tmp/eposix") then
				unlink ("/tmp/eposix")
			end
			create server_socket.listen_by_path ("/tmp/eposix", SOCK_STREAM)
			create client_socket.open_by_path ("/tmp/eposix", SOCK_STREAM)
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
			unlink ("/tmp/eposix")
		end

feature {NONE} -- Implementation

	hello: STRING is "Hello World.%N"
	berend: STRING is "hello berend%N"

end
