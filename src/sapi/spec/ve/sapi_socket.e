indexing

	description: "Class that covers the Single Unix Spec sys/socket.h header."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	SAPI_SOCKET


feature {NONE} -- Functions

	posix_accept (a_socket: INTEGER; an_address: POINTER; an_address_length: POINTER): INTEGER is
			-- Accept a connection on a socket.
			-- The `an_address_length' argument is a value-result
			-- parameter: it should initially contain the size of the
			-- structure pointed to by `an_address'; on return it will
			-- contain the actual length (in bytes) of the address
			-- returned. When `an_address' is NULL nothing is filled in.
			-- The call returns -1 on error. If it succeeds, it returns
			-- a non-negative integer that is a descriptor for the
			-- accepted socket.
		require
			valid_socket: a_socket >= 0
			valid_address_and_length: (an_address /= default_pointer) = (an_address_length /= default_pointer)



		external "C"

		ensure
			-- Result = -1 implies errno is set
		end

	posix_bind (a_socket: INTEGER; an_address: POINTER; an_address_len: INTEGER): INTEGER is
			-- Bind a socket.
		require
			valid_socket: a_socket >= 0
			valid_address: an_address /= default_pointer
			valid_length: an_address_len > 0



		external "C"

		ensure
			-- Result = -1 implies errno is set
		end

	posix_connect (a_socket: INTEGER; an_address: POINTER; an_address_len: INTEGER): INTEGER is
			-- Connect a socket.
		require
			valid_socket: a_socket >= 0
			valid_address: an_address /= default_pointer
			valid_length: an_address_len > 0



		external "C"

		ensure
			-- Result = -1 implies errno is set
		end

	posix_getpeername (a_socket: INTEGER; an_address: POINTER; an_address_length: POINTER): INTEGER is
			-- Get name of connected peer.
		require
			valid_socket: a_socket >= 0
			address_not_nil: an_address /= default_pointer
			address_length_not_nil: an_address_length /= default_pointer
		external "C"
		ensure
			-- Result = -1 implies errno is set
		end

	posix_getsockname (a_socket: INTEGER; an_address: POINTER; an_address_length: POINTER): INTEGER is
			-- Get socket name.
		require
			valid_socket: a_socket >= 0
			address_not_nil: an_address /= default_pointer
			address_length_not_nil: an_address_length /= default_pointer
		external "C"
		ensure
			-- Result = -1 implies errno is set
		end

	posix_getsockopt (a_socket, a_level, an_option_name: INTEGER; an_option_value: POINTER; an_option_length: POINTER): INTEGER is
			-- Get a socket option.
		require
			valid_socket: a_socket >= 0
			option_value_not_nil: an_option_value /= default_pointer
			option_length_not_nil: an_option_length /= default_pointer
		external "C"
		ensure
			-- Result = -1 implies errno is set
		end

	posix_listen (a_socket, a_backlog: INTEGER): INTEGER is
			-- Listen for socket connections and limit the queue of
			-- incoming connections. Returns 0 on success, -1 on error.



		external "C"

		ensure
			-- Result = -1 implies errno is set
		end

	posix_recv (a_socket: INTEGER; buf: POINTER; nbyte: INTEGER; flags: INTEGER): INTEGER is
			-- Receives data from a connected or bound socket.
		require
			valid_socket: a_socket >= 0
			valid_buf: buf /= default_pointer
			valid_bytes: nbyte >= 0



		external "C"

		end

	posix_send (a_socket: INTEGER; buf: POINTER; nbyte: INTEGER; flags: INTEGER): INTEGER is
			-- Sends data on a connected socket.
		require
			valid_socket: a_socket >= 0
			valid_buf: buf /= default_pointer
			valid_bytes: nbyte >= 0



		external "C"

		end

	posix_setsockopt (a_socket, a_level, an_option_name: INTEGER; an_option_value: POINTER; an_option_length: INTEGER): INTEGER is
			-- Set the socket options.
		require
			valid_socket: a_socket >= 0
			option_value_not_nil: an_option_value /= default_pointer
			option_length_positive: an_option_length > 0
		external "C"
		ensure
			-- Result = -1 implies errno is set
		end

	posix_shutdown (a_socket: INTEGER; a_how: INTEGER): INTEGER is
			-- Shut down part of a full-duplex connection.
		require
			valid_socket: a_socket >= 0



		external "C"

		ensure
			-- Result = -1 implies errno is set
		end

	posix_socket (a_family, a_type, a_protocol: INTEGER): INTEGER is
			-- Create an endpoint for communication.
		external "C"
		ensure
			-- Result = -1 implies errno is set
		end


feature -- C binding for members of sockaddr

	posix_sockaddr_size: INTEGER is
		external "C"
		end

	posix_sockaddr_sa_family (a_sockaddr: POINTER): INTEGER is
			-- address family: AF_xxx value
		external "C"
		end

	posix_sockaddr_sa_data (a_sockaddr: POINTER): POINTER is
			-- ptr to protocol-specific address buffer
		external "C"
		end

	posix_set_sockaddr_sa_family (a_sockaddr: POINTER; sa_family: INTEGER) is
		external "C"
		end


end
