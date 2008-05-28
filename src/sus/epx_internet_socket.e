indexing

	description: "SUSv3 portable implementation of a socket."

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
			plain_new_socket
		redefine
			new_socket
		end


create

	attach_to_socket


feature {NONE} -- Socket creation

	new_socket (sa: EPX_HOST_PORT): INTEGER is
			-- Return file descriptor for new socket. If error occurs, it
			-- raises an exception when exceptions are enabled. If
			-- exceptions are not enabled, it returns -1.
		do
			Result := precursor (sa)
		ensure then
			valid_socket: raise_exception_on_error implies Result >= 0
			valid_socket_or_error: not raise_exception_on_error implies Result >= -1
		end


feature {NONE} -- Abstract API binding

	abstract_getpeername (a_socket: INTEGER; a_address: POINTER; a_address_length: POINTER): INTEGER is
			-- Retrieve the name of the peer to which a socket is connected.
		do
			Result := posix_getpeername (a_socket, a_address, a_address_length)
		end

	abstract_getsockname (a_socket: INTEGER; a_address: POINTER; a_address_length: POINTER): INTEGER is
			-- Retrieve the local name for a socket.
		do
			Result := posix_getsockname (a_socket, a_address, a_address_length)
		end


end
