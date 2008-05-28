indexing

	description: "AF_UNIX (AF_LOCAL) SOCK_STREAM/SOCK_DGRAM sockets, client side."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	SUS_UNIX_CLIENT_SOCKET


inherit

	SUS_UNIX_SOCKET


create

	open_by_path


feature {NONE} -- Socket specific open functions

	open_by_path (a_path_name: STRING; a_socket_type: INTEGER) is
			-- Open socket to local name `a_path_name'.
		require
			closed: not is_open
			path_name_valid: is_valid_path_name (a_path_name)
			path_name_exists: file_system.is_existing (a_path_name)
			supported_socket_type: a_socket_type = SOCK_STREAM or else a_socket_type = SOCK_DGRAM
		local
			r: INTEGER
			a_fd: INTEGER
			socket_address: SUS_SOCKET_ADDRESS_UN
		do
			-- is_existing test creates `path' so is_open is True...
			fd := unassigned_value
			do_make
			a_fd := new_socket (AF_UNIX, a_socket_type)
			if a_fd /= -1 then
				create socket_address.make (a_path_name)
				r := posix_connect (a_fd, socket_address.ptr, socket_address.length)
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
			end
		ensure
			is_opened:
				raise_exception_on_error implies
					is_open and is_open_read and is_open_write
			open_files_increased_by_one:
				is_owner implies
					security.files.open_files = old security.files.open_files + 1
		end

end
