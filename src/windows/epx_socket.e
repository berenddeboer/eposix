indexing

	description: "Windows portable implementation of a socket."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #9 $"


class

	EPX_SOCKET


inherit

	EPX_DESCRIPTOR
		rename
			attach_to_descriptor as attach_to_socket
		undefine
			raise_posix_error
		redefine
			abstract_close,
			abstract_EWOULDBLOCK,
			abstract_read,
			abstract_write,
			is_blocking_io,
			set_blocking_io,
			supports_nonblocking_io,
			unassigned_value
		end

	ABSTRACT_SOCKET
		undefine
			raise_posix_error
		redefine
			unassigned_value
		end

	WINDOWS_BASE

	WAPI_WINSOCK2
		export
			{NONE} all
		end


create

	attach_to_socket


feature -- non-blocking i/o

	is_blocking_io: BOOLEAN is
			-- Is blocking i/o enabled (default)?
			-- Not reliable with attached sockets.
		do
			Result := not is_nonblocking_io
		end

	set_blocking_io (enable: BOOLEAN) is
			-- Try to turn on/off blocking-mode. Does not work when mixed
			-- with WSAAsyncSelect or WSAEventSelect calls.
		local
			r: INTEGER
		do
			if enable then
				my_flag := 0
			else
				my_flag := 1
			end
			r := posix_ioctlsocket (fd, FIONBIO, $my_flag)
			if r = SOCKET_ERROR then
				errno.set_value (posix_wsagetlasterror)
			else
				is_nonblocking_io := not enable
			end
		end

	supports_nonblocking_io: BOOLEAN is True


feature {NONE} -- non-blocking i/o support

	is_nonblocking_io: BOOLEAN
			-- Has non-blocking i/o been enabled?


feature {NONE} -- Socket close

	protected_close_socket (a_socket: INTEGER) is
			-- Close `a_socket', but make sure `errno'.`value' is not
			-- reset by a successful close. An exception will be raised
			-- if closing the socket fails.
		do
			safe_wsa_call (abstract_close (a_socket))
		end


feature {NONE} -- Low level handle functions

	unassigned_value: INTEGER is 0
			-- The value that indicates that `handle' is unassigned.
			-- This value is equal to INVALID_SOCKET.


feature {NONE} -- error codes

	abstract_EWOULDBLOCK: INTEGER is
			-- The process would be delayed in the I/O operation
		do
			Result := WSAEWOULDBLOCK
		end


feature {NONE} -- Abstract API binding

	abstract_close (a_socket: INTEGER): INTEGER is
			-- Close a socket. Depending on the SO_LINGER and
			-- SO_DONTLINGER options it's graceful or not.
		do
			-- called in `dispose', can't check this:
			-- `assert_winsock_initialized'
			Result := posix_closesocket (a_socket)
			if Result = SOCKET_ERROR then
				-- Because I duplicated the socket into a handle we
				-- probably try to close a nonsocket here.
				-- So try CloseHandle here. Normally you shouldn't get
				-- this and calling closesocket is just fine, but obnoxious
				-- virus scanners (NOD32) try to improve Windows.
				if posix_wsagetlasterror = WSAENOTSOCK then
					if posix_closehandle (a_socket) then
						Result := 0
					else
						Result := SOCKET_ERROR
					end
				else
					-- risky when called in `dispose'
					-- assume we're lucky.
					-- ISE, please fix this shit.
					errno.set_value (posix_wsagetlasterror)
				end
			end
		end

	abstract_getsockopt (a_socket, a_level, an_option_name: INTEGER; an_option_value: POINTER; an_option_length: POINTER): INTEGER is
			-- Get a socket option.
		do
			assert_winsock_initialized
			Result := posix_getsockopt (a_socket, a_level, an_option_name, an_option_value, an_option_length)
			if Result = SOCKET_ERROR then
				errno.set_value (posix_wsagetlasterror)
			end
		end

	abstract_read (fildes: INTEGER; buf: POINTER; nbyte: INTEGER): INTEGER is
			-- Use `recv' instead of ReadFile. ReadFile does not seem
			-- to be supported safely up to NT4sp4, Win 9x also have
			-- problems with it. And you get a performance penalty.
		do
			Result := posix_recv (fildes, buf, nbyte, 0)
			if Result = SOCKET_ERROR then
				errno.set_value (posix_wsagetlasterror)
			end
		end

	abstract_setsockopt (a_socket, a_level, an_option_name: INTEGER; an_option_value: POINTER; an_option_length: INTEGER): INTEGER is
			-- Set the socket options.
		do
			assert_winsock_initialized
			Result := posix_setsockopt (a_socket, a_level, an_option_name, an_option_value, an_option_length)
			if Result = SOCKET_ERROR then
				errno.set_value (posix_wsagetlasterror)
			end
		end

	abstract_socket (a_family, a_type, a_protocol: INTEGER): INTEGER is
			-- Create an endpoint for communication.
		local
			old_handle: INTEGER
		do
			assert_winsock_initialized
			Result := posix_socket (a_family, a_type, a_protocol)
			if Result = unassigned_value then
				errno.set_value (posix_wsagetlasterror)
			else
				-- Windows sockets are inherited by default. Return a
				-- socket that is not inheritable. We can't use
				-- `SetHandleInformation', because that's only available
				-- on NT.
				-- On Windows 2003 Server, when a child process was
				-- executed, and I created an inherited socket afterward,
				-- it didn't listen to 127.0.0.1 when IPADDR_ANY was
				-- specified, only to a network card.
				-- After this code, NOD32 thinks we no longer have a
				-- socket. You have to disable your programs from scanning
				-- within NOD32 until they have fixed it. It doesn't hurt
				-- to send in a complaint...
				old_handle := Result
				safe_win_call (posix_duplicatehandle (
					posix_getcurrentprocess, old_handle,
					posix_getcurrentprocess, $my_flag,
					DUPLICATE_SAME_ACCESS,
					False, 0))
				Result := my_flag
				safe_win_call (posix_closehandle (old_handle))
			end
		end

	abstract_write (fildes: INTEGER; buf: POINTER; nbyte: INTEGER): INTEGER is
			-- Use `send' instead of WriteFile. WriteFile does not seem
			-- to be supported safely up to NT4sp4, Win 9x also have
			-- problems with it. And you get a performance penalty.
		do
			Result := posix_send (fildes, buf, nbyte, 0)
			if Result = SOCKET_ERROR then
				errno.set_value (posix_wsagetlasterror)
			end
		end


end
