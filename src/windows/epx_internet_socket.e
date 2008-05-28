indexing

	description: "Windows portable implementation of a socket."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_INTERNET_SOCKET


inherit

	EPX_SOCKET
		rename
			new_socket as plain_new_socket
		end

	ABSTRACT_INTERNET_SOCKET
		undefine
			raise_posix_error,
			unassigned_value
		end


create

	attach_to_socket


feature {NONE} -- Abstract API binding

	abstract_getpeername (a_socket: INTEGER; a_address: POINTER; a_address_length: POINTER): INTEGER is
			-- Retrieve the name of the peer to which a socket is connected.
		do
			assert_winsock_initialized
			Result := posix_getpeername (a_socket, a_address, a_address_length)
			if Result = SOCKET_ERROR then
				errno.set_value (posix_wsagetlasterror)
			end
		end

	abstract_getsockname (a_socket: INTEGER; a_address: POINTER; a_address_length: POINTER): INTEGER is
			-- Retrieve the local name for a socket.
		do
			assert_winsock_initialized
			Result := posix_getsockname (a_socket, a_address, a_address_length)
			if Result = SOCKET_ERROR then
				errno.set_value (posix_wsagetlasterror)
			end
		end

end
