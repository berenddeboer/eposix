indexing

	description: "AF_UNIX (AF_LOCAL) SOCK_STREAM/SOCK_DGRAM sockets, server side."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	SUS_UNIX_SERVER_SOCKET


inherit

	SUS_UNIX_SOCKET


create

	listen_by_path


feature {NONE} -- Socket specific open functions

	listen_by_path (a_path_name: STRING; a_socket_type: INTEGER) is
			-- Listen on socket for address specified in `sa'.
			-- It uses a backlog of `backlog_default' maximum pending
			-- connections.
		require
			closed: not is_open
			path_name_valid: is_valid_path_name (a_path_name)
			path_name_not_exists: not file_system.is_existing (a_path_name)
			supported_socket_type: a_socket_type = SOCK_STREAM or else a_socket_type = SOCK_DGRAM
		local
			r: INTEGER
			a_fd: INTEGER
			socket_address: SUS_SOCKET_ADDRESS_UN
		do
			-- is_existing test creates `path' so is_open is True...
			fd := unassigned_value
			do_make
			create client_socket_address.allocate_and_clear (posix_sockaddr_un_size)
			a_fd := new_socket (AF_UNIX, a_socket_type)
			if a_fd /= -1 then
				create socket_address.make (a_path_name)
				r := posix_bind (a_fd, socket_address.ptr, socket_address.length)
				if r /= -1 then
					r := posix_listen (a_fd, backlog_default)
					if r /= -1 then
						capacity := 1
						set_handle (a_fd, True)
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
				is_owner implies
					security.files.open_files = old security.files.open_files + 1
		end


feature -- Accept

	accept: SUS_UNIX_SOCKET is
			-- Return the next completed connection from the front of the
			-- completed connection queue. If there are no completed
			-- connections, the process is put to sleep.
		require
			open: is_open
		local
			client_fd: INTEGER
		do
			address_length := client_socket_address.capacity
			client_fd := posix_accept (fd, client_socket_address.ptr, $address_length)
			if client_fd = unassigned_value then
				if errno.is_not_ok and then errno.value /= EAGAIN then
					raise_posix_error
				end
			else
				create Result.attach_to_socket (client_fd, True)
				-- no `last_client_address' for now
			end
		ensure
			socket_to_client_returned: raise_exception_on_error and then is_blocking_io implies Result /= Void
		end

	last_client_address: SUS_SOCKET_ADDRESS_IN_BASE
			-- Address of last client accepted by `accept'.


feature {NONE} -- Implementation

	backlog_default: INTEGER is 1024
			-- While there is no good definition of backlog, it indicates
			-- the maximum length the queue of pending connections may
			-- grow to; whatever that may mean.

	client_socket_address: STDC_BUFFER
			-- Memory area where details of accepted connection are stored


invariant

	client_socket_address_not_void: client_socket_address /= Void

end
