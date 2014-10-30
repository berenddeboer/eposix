note

	description: "SUSv3 portable implementation of a socket."

	author: "Berend de Boer"


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


feature -- Access

	is_bound: BOOLEAN


feature {NONE} -- Socket options

	reuse_address: BOOLEAN
			-- Can `socket' reuse address in the TIME_WAIT state?
		require
			open: is_open
		do
			my_flag_length := 4
			safe_call (abstract_getsockopt (socket, SOL_SOCKET, SO_REUSEADDR, $my_flag, $my_flag_length))
			Result := my_flag /= 0
		end

	set_reuse_address (enable: BOOLEAN)
			-- Make it possible to bind to socket `socket' even if it
			-- is in the TIME_WAIT state.
		require
			open: is_open
			unbound: not is_bound
		do
			if enable then
				my_flag := 1
			else
				my_flag := 0
			end
			safe_call (abstract_setsockopt (socket, SOL_SOCKET, SO_REUSEADDR, $my_flag, 4))
		ensure then
			reuse_address_set: raise_exception_on_error implies enable = reuse_address
		end



feature {NONE} -- Implementation

	my_flag_length:  INTEGER
			-- Variable to receive returned length of option in `getsockopt'.


feature {NONE} -- Socket creation

	new_socket (sa: EPX_HOST_PORT): INTEGER
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

	abstract_getpeername (a_socket: INTEGER; a_address: POINTER; a_address_length: POINTER): INTEGER
			-- Retrieve the name of the peer to which a socket is connected.
		do
			Result := posix_getpeername (a_socket, a_address, a_address_length)
		end

	abstract_getsockname (a_socket: INTEGER; a_address: POINTER; a_address_length: POINTER): INTEGER
			-- Retrieve the local name for a socket.
		do
			Result := posix_getsockname (a_socket, a_address, a_address_length)
		end


end
