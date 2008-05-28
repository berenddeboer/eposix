indexing

	description: "Windows portable implementation of a server side TCP socket."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


class

	EPX_TCP_SERVER_SOCKET


inherit

	EPX_TCP_SOCKET

	ABSTRACT_TCP_SERVER_SOCKET
		undefine
			raise_posix_error,
			unassigned_value
		end


create

	listen_by_address


feature {NONE} -- Socket options

	set_reuse_address (a_socket: INTEGER; enable: BOOLEAN) is
			-- Make it possible to bind to socket `a_scoket' even if it
			-- is in the TIME_WAIT state.
		do
			-- Windows does not support this option.
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
			assert_winsock_initialized
			Result := posix_accept (a_socket, an_address, an_address_length)
			if Result = SOCKET_ERROR then
				errno.set_value (posix_wsagetlasterror)
				Result := unassigned_value
				if errno.value = WSAEWOULDBLOCK then
					errno.set_value (EAGAIN)
				end
			end
		end

	abstract_bind (a_socket: INTEGER; an_address: POINTER; an_address_len: INTEGER): INTEGER is
			-- Associate a local address with a socket.
		do
			assert_winsock_initialized
			Result := posix_bind (a_socket, an_address, an_address_len)
			if Result = SOCKET_ERROR then
				errno.set_value (posix_wsagetlasterror)
			end
		end

	posix_peek_int32_native (p: POINTER; index: INTEGER): INTEGER is
			-- Read integer at position `index'.
		require
			valid_memory: p /= default_pointer
		external "C"
		end

	abstract_listen (a_socket, a_backlog: INTEGER): INTEGER is
			-- Listen for socket connections and limit the queue of
			-- incoming connections. Returns 0 on success, -1 on error.
		do
			assert_winsock_initialized
			Result := posix_listen (a_socket, a_backlog)
			if Result = SOCKET_ERROR then
				errno.set_value (posix_wsagetlasterror)
			end
		end

end
