indexing

	description: "Class that covers the Windows winsock2.h header."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	WAPI_WINSOCK2


inherit

	ANY

	WINDOWS_CONSTANTS
		export
			{NONE} all;
			{ANY}
				AF_INET,
				AF_INET6,
				INET_ADDRSTRLEN,
				INET6_ADDRSTRLEN,
				INVALID_SOCKET
		end


feature -- Error functions

	posix_wsagetlasterror: INTEGER is
			-- The last error status for the last operation that failed.
		external "C"
		end


feature -- Initialization

	winsock_data: STDC_BUFFER
			-- Pointer to memory block containing a WSADATA struct.

	winsock_initialized: BOOLEAN is
			-- True if `initialize_winsock' has been called.
		do
			Result := my_winsock_initialized.item
		end

	assert_winsock_initialized is
			-- If winsock not initialized, initialize it with version
			-- 2.0.
		do
			if not winsock_initialized then
				initialize_winsock (2, 0)
			end
		ensure
			initialized: winsock_initialized
		end

	initialize_winsock (a_major_version, a_minor_version: INTEGER) is
		require
			uninitialized: not winsock_initialized
			major_version_valid: a_major_version >= 1 and a_major_version <= 255
			minor_version_valid: a_minor_version >= 0 and a_minor_version <= 255
		local
			r: INTEGER
			version: INTEGER
		do
			create winsock_data.allocate_and_clear (posix_wsadata_size)
			version := a_major_version + (a_minor_version * 256)
			r := posix_wsastartup (version, winsock_data.ptr)
			my_winsock_initialized.set_item (r = 0)
		ensure
			initialized: winsock_initialized
			winsock_data_not_void: winsock_data /= Void
		end

	cleanup_winsock is
		require
			initialized: winsock_initialized
		local
			r: INTEGER
		do
			r := posix_wsacleanup
			if r = 0 then
				my_winsock_initialized.set_item (False)
			end
		ensure
			uninitialized: not winsock_initialized
		end

	posix_wsastartup (a_version_requested: INTEGER; a_wsadata: POINTER): INTEGER is
			-- Initialize use of WS2_32.DLL by a process.
			-- Returns 0 on success.
		external "C"
		end

	posix_wsacleanup: INTEGER is
			-- Terminate use of WS2_32.DLL.
			-- Returns 0 on success.
		external "C"
		end


feature {NONE} -- Implementation

	my_winsock_initialized: BOOLEAN_REF is
			-- Global variable to check if winsock is already initialized
			-- or not.
		once
			create Result
		ensure
			my_winsock_initialized_not_void: Result /= Void
		end


feature -- C binding for members of WSAData

	posix_wsadata_size: INTEGER is
		external "C"
		ensure
			valid_size: Result > 0
		end

	posix_wsadata_wversion (a_wsadata: POINTER): INTEGER is
			-- Version of the Windows Sockets specification that the
			-- ws2_32.dll expects the caller to use.
		require
			have_struct_pointer: a_wsadata /= default_pointer
		external "C"
		end

	posix_wsadata_whighversion (a_wsadata: POINTER): INTEGER is
			-- Highest version of the Windows Sockets specification that
			-- this .dll can support (also encoded as above). Normally
			-- this is the same as `posix_wsadata_wversion'.
		require
			have_struct_pointer: a_wsadata /= default_pointer
		external "C"
		end

	posix_wsadata_szdescription (a_wsadata: POINTER): POINTER is
		require
			have_struct_pointer: a_wsadata /= default_pointer
		external "C"
		end

	posix_wsadata_szsystemstatus (a_wsadata: POINTER): POINTER is
		require
			have_struct_pointer: a_wsadata /= default_pointer
		external "C"
		end


feature -- Host functions

	posix_accept (a_socket: INTEGER; an_address: POINTER; an_address_length: POINTER): INTEGER is
			-- Accept a connection on a socket.
			-- The `an_address_length' argument is a value-result
			-- parameter: it should initially contain the size of the
			-- structure pointed to by `an_address'; on return it will
			-- contain the actual length (in bytes) of the address
			-- returned. When `an_address' is NULL nothing is filled in.
			-- The call returns `INVALID_SOCKET' on error.
		require
			initialized: winsock_initialized
			valid_socket: a_socket /= INVALID_SOCKET
			valid_address_and_length: (an_address /= default_pointer) = (an_address_length /= default_pointer)



		external "C"

		end

	posix_bind (a_socket: INTEGER; an_address: POINTER; an_address_len: INTEGER): INTEGER is
			-- Bind a socket.
		require
			initialized: winsock_initialized
			valid_socket: a_socket /= INVALID_SOCKET
			valid_address: an_address /= default_pointer
			valid_length: an_address_len > 0



		external "C"

		end

	posix_closesocket (a_socket: INTEGER): INTEGER is
			-- Close an existing socket.
		require
			valid_socket: a_socket /= INVALID_SOCKET



		external "C"

		end

	posix_connect (a_socket: INTEGER; an_address: POINTER; an_address_len: INTEGER): INTEGER is
			-- Connect a socket.
		require
			initialized: winsock_initialized
			valid_socket: a_socket /= INVALID_SOCKET
			valid_address: an_address /= default_pointer
			valid_length: an_address_len > 0



		external "C"

		end

	posix_gethostbyaddr (an_addr: POINTER; a_len, a_type: INTEGER): POINTER is
			-- Retrieve host information corresponding to address
			-- `an_addr'. If returned pointer is default_pointer, check
			-- `WSAGetLastError' for the error reason.
		require
			an_addr_not_nil: an_addr /= default_pointer
			a_len_positive: a_len > 0



		external "C"

		end

	posix_gethostbyname (a_hostname: POINTER): POINTER is
			-- Retrieve host information corresponding to `a_hostname'
			-- from a host database. If returned pointer is
			-- default_pointer, check `WSAGetLastError' for the error
			-- reason.
		require
			initialized: winsock_initialized
			valid_hostname: a_hostname /= default_pointer



		external "C"

		end

	posix_getpeername (a_socket: INTEGER; an_address: POINTER; an_address_length: POINTER): INTEGER is
			-- Retrieve the name of the peer to which a socket is connected.
		require
			initialized: winsock_initialized
			valid_socket: a_socket /= INVALID_SOCKET
			address_not_nil: an_address /= default_pointer
			address_length_not_nil: an_address_length /= default_pointer
		external "C"
		end

	posix_getservbyname (a_name, a_proto: POINTER): POINTER is
			-- Lookup service given its name and optional protocol.
		require
			initialized: winsock_initialized
			valid_name: a_name /= default_pointer



		external "C"

		end

	posix_getservbyport (a_port: INTEGER; a_proto: POINTER): POINTER is
			-- Lookup service given its port number and optional protocol.
		require
			initialized: winsock_initialized
			valid_port: a_port >= 0



		external "C"

		end

	posix_getsockname (a_socket: INTEGER; an_address: POINTER; an_address_length: POINTER): INTEGER is
			-- Retrieve the local name for a socket.
		require
			initialized: winsock_initialized
			valid_socket: a_socket /= INVALID_SOCKET
			address_not_nil: an_address /= default_pointer
			address_length_not_nil: an_address_length /= default_pointer
		external "C"
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

	posix_ioctlsocket (a_socket, a_cmd: INTEGER; a_argp: POINTER): INTEGER is
			-- Controls the I/O mode of a socket.
		require
			valid_socket: a_socket /= INVALID_SOCKET
			valid_argp: a_argp /= default_pointer
		external "C"
		end

	posix_listen (a_socket, a_backlog: INTEGER): INTEGER is
			-- Listen for socket connections and limit the queue of
			-- incoming connections. Returns 0 on success, -1 on error.
		require
			initialized: winsock_initialized
			valid_socket: a_socket /= INVALID_SOCKET



		external "C"

		end

	posix_recv (a_socket: INTEGER; buf: POINTER; nbyte: INTEGER; flags: INTEGER): INTEGER is
			-- Receives data from a connected or bound socket.
		require
			initialized: winsock_initialized
			valid_socket: a_socket /= INVALID_SOCKET
			valid_buf: buf /= default_pointer
			valid_bytes: nbyte >= 0



		external "C"

		end

	posix_select (a_maxfdp1: INTEGER; a_readset, a_writeset, an_exceptset: POINTER; a_timeout: POINTER): INTEGER is
			-- Wait for a number of descriptors to change status.
			-- `a_maxfdp`' is ignored.
			-- If `a_timeout' is 0, function returns immediately (polling).
			-- If `a_timeout' is `default_pointer' function can block
			-- indefinitely.
			-- Returns -1 on error or else the number of descriptors that
			-- are ready.
		require
			a_maxfdp1_not_negative: a_maxfdp1 >= 0
			maxfd_implies_descriptors: a_maxfdp1 >= 1 implies (a_readset /= default_pointer or else a_writeset /= default_pointer or else an_exceptset /= default_pointer)



		external "C"

		ensure
			-- Result = -1 implies errno.is_not_ok
		end

	posix_send (a_socket: INTEGER; buf: POINTER; nbyte: INTEGER; flags: INTEGER): INTEGER is
			-- Sends data on a connected socket.
		require
			initialized: winsock_initialized
			valid_socket: a_socket /= INVALID_SOCKET
			valid_buf: buf /= default_pointer
			valid_bytes: nbyte >= 0



		external "C"

		end

	posix_setsockopt (a_socket, a_level, an_option_name: INTEGER; an_option_value: POINTER; an_option_length: INTEGER): INTEGER is
			-- Set the socket options.
		require
			initialized: winsock_initialized
			valid_socket: a_socket /= INVALID_SOCKET
			option_value_not_nil: an_option_value /= default_pointer
			option_length_positive: an_option_length > 0
		external "C"
		end

	posix_shutdown (a_socket: INTEGER; a_how: INTEGER): INTEGER is
			-- Shut down part of a full-duplex connection. Returns
			-- `SOCKET_ERROR' on error.
		require
			initialized: winsock_initialized
			valid_socket: a_socket /= INVALID_SOCKET



		external "C"

		end

	posix_socket (a_family, a_type, a_protocol: INTEGER): INTEGER is
			-- Create an endpoint for communication. Returns
			-- `INVALID_SOCKET' when an error occurs.
		external "C"
		ensure
			-- Result = INVALID_SOCKET implies WSAGetLastError is set
		end


feature -- Conversion functions

	posix_inet_ntoa (a_in: POINTER): POINTER is
			-- Converts the Internet host address specified by `a_in' to
			-- a string in the Internet standard dot notation.
			-- Returns `default_pointer' on error.
		require
			valid_in: a_in /= default_pointer
		external "C"
		end

	posix_inet_ntop (an_address_family: INTEGER; a_src, a_dst: POINTER; a_size: INTEGER): POINTER is
			-- Converts the network address structure `a_src' in the
			-- `an_address family` into a character string, which is
			-- copied to a character buffer `a_dst', which is `a_size'
			-- bytes long.
		require
			valid_src: a_src /= default_pointer
			valid_dst: a_dst /= default_pointer
			size_valid:
				(an_address_family = AF_INET implies a_size >= INET_ADDRSTRLEN) and
				(an_address_family = AF_INET6 implies a_size >= INET6_ADDRSTRLEN)
		external "C"
		end


feature -- Host to network conversions

	posix_ntohl (a_value: INTEGER): INTEGER is
			-- Convert 32-bit integer from network byte order to host
			-- byte order.
		external "C"
		end

	posix_htonl (a_value: INTEGER): INTEGER is
			-- Convert 32-bit integer from host byte order to network
			-- byte order.
		external "C"
		end

	posix_htons (host16bitvalue: INTEGER): INTEGER is
			-- Convert 16-bit integer to network byte order.
		require
			valid_value: host16bitvalue >= 0 and host16bitvalue <= 65535
		external "C"
		end

	posix_ntohs (host16bitvalue: INTEGER): INTEGER is
			-- Convert 16-bit integer to host byte order.
		external "C"
		ensure
			valid_value: host16bitvalue >= 0 and host16bitvalue <= 65535
		end


feature -- C binding for members of in_addr

	posix_in_addr_size: INTEGER is
		external "C"
		ensure
			size_positive: Result > 0
		end

	posix_in_addr_s_addr (a_in_addr: POINTER): INTEGER is
		external "C"
		end

	posix_set_in_addr_s_addr (a_in_addr: POINTER; s_addr: INTEGER) is
		external "C"
		end


feature -- C binding for members of in6_addr

	posix_in6_addr_size: INTEGER is
		external "C"
		ensure
			size_positive: Result > 0
		end

	posix_in6_addr_s6_addr (a_in6_addr: POINTER): POINTER is
		external "C"
		end

	posix_set_in6_addr_s6_addr (a_in6_addr: POINTER; s6_addr: POINTER) is
		external "C"
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


feature -- C binding for members of sockaddr_in

	posix_sockaddr_in_size: INTEGER is
		external "C"
		end

	posix_sockaddr_in_sin_family (a_sockaddr_in: POINTER): INTEGER is
			-- AF_INET.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_sockaddr_in_sin_port (a_sockaddr_in: POINTER): INTEGER is
			-- Port number.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_sockaddr_in_sin_addr (a_sockaddr_in: POINTER): POINTER is
			-- Internet address.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_set_sockaddr_in_sin_family (a_sockaddr_in: POINTER; sin_family: INTEGER) is
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_set_sockaddr_in_sin_port (a_sockaddr_in: POINTER; sin_port: INTEGER) is
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
			valid_port: sin_port >= 0 and sin_port <= 65535
		external "C"
		end

	posix_set_sockaddr_in_sin_addr (a_sockaddr_in: POINTER; sin_addr: POINTER) is
			-- Set sin_addr by moving bytes from `sin_addr'.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
			valid_sin_addr: sin_addr /= default_pointer
		external "C"
		end


feature -- C binding for members of sockaddr_in6

	posix_sockaddr_in6_size: INTEGER is
		external "C"
		end

	posix_sockaddr_in6_sin6_family (a_sockaddr_in: POINTER): INTEGER is
			-- AF_INET6.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_sockaddr_in6_sin6_port (a_sockaddr_in: POINTER): INTEGER is
			-- Port number.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_sockaddr_in6_sin6_addr (a_sockaddr_in: POINTER): POINTER is
			-- Internet address.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_sockaddr_in6_sin6_scope_id (a_sockaddr_in: POINTER): INTEGER is
			-- The sin6_scope_id field is a 32-bit integer that
			-- identifies a set of interfaces as appropriate for the
			-- scope of the address carried in the sin6_addr field.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_set_sockaddr_in6_sin6_family (a_sockaddr_in: POINTER; sin_family: INTEGER) is
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_set_sockaddr_in6_sin6_port (a_sockaddr_in: POINTER; sin_port: INTEGER) is
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
			valid_port: sin_port >= 0 and sin_port <= 65535
		external "C"
		end

	posix_set_sockaddr_in6_sin6_addr (a_sockaddr_in: POINTER; sin_addr: POINTER) is
			-- Set sin_addr by moving bytes from `sin_addr'.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
			valid_sin_addr: sin_addr /= default_pointer
		external "C"
		end


feature -- C binding for members of hostent

	posix_hostent_size: INTEGER is
		external "C"
		ensure
			valid_result: Result > 0
		end

	posix_hostent_h_name (a_hostent: POINTER): POINTER is
		require
			valid_hostent: a_hostent /= default_pointer
		external "C"
		end

	posix_hostent_h_aliases (a_hostent: POINTER): POINTER is
		require
			valid_hostent: a_hostent /= default_pointer
		external "C"
		end

	posix_hostent_h_addrtype (a_hostent: POINTER): INTEGER is
		require
			valid_hostent: a_hostent /= default_pointer
		external "C"
		end

	posix_hostent_h_length (a_hostent: POINTER): INTEGER is
		require
			valid_hostent: a_hostent /= default_pointer
		external "C"
		end

	posix_hostent_h_addr_list (a_hostent: POINTER): POINTER is
		require
			valid_hostent: a_hostent /= default_pointer
		external "C"
		end


feature -- C binding for members of servent

	posix_servent_size: INTEGER is
		external "C"
		ensure
			valid_result: Result > 0
		end

	posix_servent_s_name (a_servent: POINTER): POINTER is
			-- Official service name.
		require
			valid_servent: a_servent /= default_pointer
		external "C"
		end

	posix_servent_s_aliases (a_servent: POINTER): POINTER is
			-- Alias list.
		require
			valid_servent: a_servent /= default_pointer
		external "C"
		end

	posix_servent_s_port (a_servent: POINTER): INTEGER is
			-- Port number.
		require
			valid_servent: a_servent /= default_pointer
		external "C"
		end

	posix_servent_s_proto (a_servent: POINTER): POINTER is
			-- Protocol to use.
		require
			valid_servent: a_servent /= default_pointer
		external "C"
		end


feature -- File descriptor set functions

	posix_fd_clr (a_fd: INTEGER; a_fdset: POINTER) is
			-- Clears the bit for the file descriptor `a_fd' in the file
			-- descriptor set `fdset'.
		require
			valid_descriptor: a_fd >= 0
			valid_descriptor_set: a_fdset /= default_pointer
		external "C"
		end

	posix_fd_isset (a_fd: INTEGER; a_fdset: POINTER): BOOLEAN is
			-- Returns a non-zero value if the bit for the file
			-- descriptor `a_fd' is set in the file descriptor set by
			-- `a_fdset', and 0 otherwise.
		require
			valid_descriptor: a_fd >= 0
			valid_descriptor_set: a_fdset /= default_pointer
		external "C"
		end

	posix_fd_set (a_fd: INTEGER; a_fdset: POINTER) is
			-- Sets the bit for the file descriptor `a_fd' in the file
			-- descriptor set `a_fdset'.
		require
			valid_descriptor: a_fd >= 0
			valid_descriptor_set: a_fdset /= default_pointer
		external "C"
		end

	posix_fd_zero (a_fdset: POINTER) is
			-- Initialize the file descriptor set `a_fdset' to have zero
			-- bits for all file descriptors.
		require
			valid_descriptor_set: a_fdset /= default_pointer
		external "C"
		end

	posix_fd_set_size: INTEGER is
			-- Size of a fd_set struct.
		external "C"
		end

	FD_SETSIZE: INTEGER is
			-- Maximum number of file descriptors in an fd_set structure
		external "C"
		alias "const_fd_setsize"
		end


feature {NONE} -- C binding for members of timeval

	posix_timeval_size: INTEGER is
		external "C"
		ensure
			valid_size: Result > 0
		end

	posix_timeval_tv_sec (a_timeval: POINTER): INTEGER is
			-- seconds
		require
			have_struct_pointer: a_timeval /= default_pointer
		external "C"
		end

	posix_timeval_tv_usec (a_timeval: POINTER): INTEGER is
			-- microseconds
		require
			have_struct_pointer: a_timeval /= default_pointer
		external "C"
		end

	posix_set_timeval_tv_sec (a_timeval: POINTER; tv_sec: INTEGER) is
		require
			have_struct_pointer: a_timeval /= default_pointer
		external "C"
		end

	posix_set_timeval_tv_usec (a_timeval: POINTER; tv_usec: INTEGER) is
		require
			have_struct_pointer: a_timeval /= default_pointer
		external "C"
		end


end
