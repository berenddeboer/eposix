indexing

	description: "Windows portable implementation of a server side TCP socket."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


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


feature {NONE} -- Socket options

	reuse_address (a_socket: INTEGER): BOOLEAN is
			-- Can socket reuse address in the TIME_WAIT state?
		do
			my_flag_length := 4
			safe_call (abstract_getsockopt (a_socket, SOL_SOCKET, SO_REUSEADDR, $my_flag, $my_flag_length))
			Result := my_flag /= 0
		end

	set_reuse_address (a_socket: INTEGER; enable: BOOLEAN) is
			-- Make it possible to bind to socket `a_scoket' even if it
			-- is in the TIME_WAIT state.
		do
			if enable then
				my_flag := 1
			else
				my_flag := 0
			end
			safe_call (abstract_setsockopt (a_socket, SOL_SOCKET, SO_REUSEADDR, $my_flag, 4))
		ensure then
			reuse_address_set: enable = reuse_address (a_socket)
		end


feature {NONE} -- Abstract API binding

	abstract_accept (a_socket: INTEGER; an_address: POINTER; an_address_length: POINTER): INTEGER is
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

	abstract_bind (a_socket: INTEGER; an_address: POINTER; an_address_len: INTEGER): INTEGER is
			-- Associate a local address with a socket.
		do
			Result := posix_bind (a_socket, an_address, an_address_len)
		end

	abstract_listen (a_socket, a_backlog: INTEGER): INTEGER is
			-- Listen for socket connections and limit the queue of
			-- incoming connections. Returns 0 on success, -1 on error.
		do
			Result := posix_listen (a_socket, a_backlog)
		end

end
