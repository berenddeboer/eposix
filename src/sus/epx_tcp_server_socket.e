note

	description: "Windows portable implementation of a server side TCP socket."

	author: "Berend de Boer"


class

	EPX_TCP_SERVER_SOCKET


inherit

	EPX_TCP_SOCKET

	ABSTRACT_TCP_SERVER_SOCKET
		undefine
			new_socket,
			plain_new_socket
		end


create

	make,
	listen_by_address


feature {NONE} -- Abstract API binding

	abstract_accept (a_socket: INTEGER; an_address: POINTER; an_address_length: POINTER): INTEGER
			-- Accept a connection on a socket.
			-- The `an_address_length' argument is a value-result
			-- parameter: it should initially contain the size of the
			-- structure pointed to by `an_address'; on return it will
			-- contain the actual length (in bytes) of the address
			-- returned. When `an_address' is NULL nothing is filled in.
			-- The call returns `unassigned_value' on error.
		do
			Result := posix_accept (a_socket, an_address, an_address_length)
		end

	abstract_bind (a_socket: INTEGER; an_address: POINTER; an_address_len: INTEGER): INTEGER
			-- Associate a local address with a socket.
		do
			Result := posix_bind (a_socket, an_address, an_address_len)
		end

	abstract_listen (a_socket, a_backlog: INTEGER): INTEGER
			-- Listen for socket connections and limit the queue of
			-- incoming connections. Returns 0 on success, -1 on error.
		do
			Result := posix_listen (a_socket, a_backlog)
		end

end
