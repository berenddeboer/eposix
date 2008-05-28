indexing

	description: "UDP sockets for a client."

	notes: "Currently, nothing distinguishes it from a TCP socket."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


class

	SUS_UDP_CLIENT_SOCKET


inherit

	SUS_UDP_SOCKET


create

	open_by_address


feature {NONE} -- Socket specific open functions

	open_by_address (sa: EPX_HOST_PORT) is
			-- Open socket to server specified in `sa'.
		require
			closed: not is_open
			sa_not_void: sa /= Void
			supported_family: sa.socket_address.address_family = AF_INET or sa.socket_address.address_family = AF_INET6
			udp_protocol: sa.service.protocol_type = SOCK_DGRAM
		local
			r: INTEGER
			a_fd: INTEGER
		do
			do_make
			a_fd := new_socket (sa)
			if a_fd /= -1 then
				r := posix_connect (a_fd, sa.socket_address.ptr, sa.socket_address.length)
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
