note

	description: "Platform independent base class for TCP/SOCK_STREAM sockets, server side."

	author: "Berend de Boer"


deferred class

	ABSTRACT_TCP_SERVER_SOCKET


inherit

	ABSTRACT_TCP_SOCKET
		export
			{ANY} SOCK_STREAM, AF_INET, AF_INET6
		end


feature -- Socket specific open functions

	listen_by_address (hp: EPX_HOST_PORT)
			-- Listen on socket for address specified in `hp'.
			-- It uses a backlog of `backlog_default' maximum pending
			-- connections.
		require
			hp_not_void: hp /= Void
			supported_family: hp.socket_address.address_family = AF_INET or hp.socket_address.address_family = AF_INET6
			tcp_protocol: hp.service.protocol_type = SOCK_STREAM
		local
			r: INTEGER
			a_fd: INTEGER
			l_client_socket_address: like client_socket_address
		do
			do_make
			create l_client_socket_address.allocate_and_clear (hp.socket_address.length)
			client_socket_address := l_client_socket_address
			-- BeOS doesn't set family. It doesn't reset it either, so
			-- set it to AF_INET here. Any sensible implementation will
			-- override the value.
			abstract_api.posix_set_sockaddr_sa_family (l_client_socket_address.ptr, AF_INET)
			a_fd := new_socket (hp)
			if a_fd /= -1 then
				capacity := 1
				set_handle (a_fd, True)
				if SO_REUSEADDR /= 0 then
					set_reuse_address (True)
				end
				r := abstract_bind (a_fd, hp.socket_address.ptr, hp.socket_address.length)
				if r /= -1 then
					r := abstract_listen (a_fd, backlog_default)
					if r /= -1 then
						-- Optimize for streaming reads/writes.
						set_streaming (True)
						is_open_read := True
						is_open_write := True
					else
						protected_close_socket (a_fd)
						raise_posix_error
					end
				else
					protected_close_socket (a_fd)
					raise_posix_error
				end
			end
		ensure
			is_opened:
				raise_exception_on_error implies
					is_open and is_open_read and is_open_write
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end


feature -- Accept

	accept: detachable ABSTRACT_TCP_SOCKET
			-- Return the next completed connection from the front of the
			-- completed connection queue. If there are no completed
			-- connections, the process is put to sleep.
			-- If the socket is non-blocking, Void will be returned and
			-- the process is not put to sleep.
			-- If the current process is interrupted (signalled), Void
			-- will be returned.
		require
			open: is_open
		local
			client_fd: INTEGER
		do
			if attached client_socket_address as l_client_socket_address then
				address_length := l_client_socket_address.capacity
				client_fd := abstract_accept (socket, l_client_socket_address.ptr, $address_length)
			end
			if client_fd = unassigned_value then
				if errno.is_not_ok and then errno.value /= EAGAIN and then errno.value /= EWOULDBLOCK and then errno.value /= EINTR  then
					raise_posix_error
				end
			else
				create {EPX_TCP_SOCKET} Result.attach_to_socket (client_fd, True)
				if attached client_socket_address as a then
					last_client_address := new_socket_address_in_from_pointer (a, address_length)
				end
			end
		ensure
			last_client_address_set: Result /= Void implies last_client_address /= Void
		end

	last_client_address: detachable ABSTRACT_SOCKET_ADDRESS_IN_BASE
			-- Address of last client accepted by `accept'.


feature {NONE} -- Implementation

	backlog_default: INTEGER
			-- While there is no good definition of backlog, it indicates
			-- the maximum length the queue of pending connections may
			-- grow to. Whatever that may mean.
		do
			Result := SOMAXCONN
		end

	client_socket_address: detachable STDC_BUFFER
			-- Memory area where details of accepted connection are stored.


feature {NONE} -- Abstract API binding

	abstract_accept (a_socket: INTEGER; an_address: POINTER; an_address_length: POINTER): INTEGER
			-- Accept a connection on a socket.
			-- The `an_address_length' argument is a value-result
			-- parameter: it should initially contain the size of the
			-- structure pointed to by `an_address'; on return it will
			-- contain the actual length (in bytes) of the address
			-- returned. When `an_address' is NULL nothing is filled in.
			-- The call returns `unassigned_value' on error.
		require
			valid_socket: a_socket /= unassigned_value
			valid_address_and_length: (an_address /= default_pointer) = (an_address_length /= default_pointer)
		deferred
		ensure
			-- Result = unassigned_value implies errno.value is set
		end

	abstract_bind (a_socket: INTEGER; an_address: POINTER; an_address_len: INTEGER): INTEGER
			-- Associate a local address with a socket.
		require
			valid_socket: a_socket /= unassigned_value
			valid_address: an_address /= default_pointer
			valid_length: an_address_len > 0
		deferred
		ensure
			-- Result = -1 implies errno.value is set
		end

	abstract_listen (a_socket, a_backlog: INTEGER): INTEGER
			-- Listen for socket connections and limit the queue of
			-- incoming connections. Returns 0 on success, -1 on error.
		require
			valid_socket: a_socket /= unassigned_value
		deferred
		ensure
			-- Result = -1 implies errno.value is set
		end


feature {NONE} -- Socket options

	set_reuse_address (enable: BOOLEAN)
			-- Make it possible to bind to socket `a_scoket' even if it
			-- is in the TIME_WAIT state.
			-- This option should not call set SO_REUSEADDR on Windows,
			-- as Windows does something completely different. On Windows
			-- SO_REUSEADDR will hijack the port and give indeterminate
			-- results. That's probably a common option on Windows... See
			-- http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winsock/winsock/using_so_reuseaddr_and_so_exclusiveaddruse.asp
		require
			SO_REUSEADDR_available: SO_REUSEADDR /= 0
			open: is_open
		deferred
		end


invariant

	client_socket_address_not_void: is_open implies client_socket_address /= Void

end
