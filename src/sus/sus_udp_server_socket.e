note

	description: "UDP sockets for a server."

	author: "Berend de Boer"


class

	SUS_UDP_SERVER_SOCKET


inherit

	SUS_UDP_SOCKET
		rename
			put_string as not_yet_applicable_put_string
		end

	SAPI_IN
		export
			{NONE} all
		end


create

	listen_by_address


feature -- Access

	sa: EPX_HOST_PORT
			-- To what address/port we have bound


feature {NONE} -- Socket specific open functions

	listen_by_address (a_sa: EPX_HOST_PORT)
			-- Accept datagrams on socket for address specified in `sa'.
		require
			closed: not is_open
			sa_not_void: a_sa /= Void
			supported_family: a_sa.socket_address.address_family = AF_INET or a_sa.socket_address.address_family = AF_INET6
			udp_protocol: a_sa.service.protocol_type = SOCK_DGRAM
		local
			a_fd: INTEGER
		do
			do_make
			a_fd := new_socket (a_sa)
			if a_fd /= -1 then
				sa := a_sa
				capacity := 1
				set_handle (a_fd, True)
				set_default_socket_options
				bind
				if not is_bound then
					protected_close_socket (a_fd)
					raise_posix_error
				end
			end
		ensure
			is_opened:
				raise_exception_on_error implies
					is_open and is_open_read and is_open_write
			bound:
				raise_exception_on_error implies is_bound
			open_files_increased_by_one:
				is_owner implies
					security.files.open_files = old security.files.open_files + 1
		end

	bind
		require
			open: is_open
		local
			r: INTEGER
		do
			r := posix_bind (socket, sa.socket_address.ptr, sa.socket_address.length)
			is_bound := r /= -1
			if is_bound then
				-- Optimize for streaming reads/writes.
				set_streaming (True)
				is_open_read := True
				is_open_write := True
			end
		ensure
			bound: raise_exception_on_error implies is_bound
			is_read_write:
				raise_exception_on_error implies
					is_open_read and is_open_write
		end


feature -- Socket options

	join_multicast_group (a_local_interface_address: detachable EPX_IP4_ADDRESS)
			-- Join the multicast group of our `socket' on an address
			-- belonging to a local interface.
			-- If `a_local_interface_address' is not set, the system will
			-- pick a suitable local interface.
			-- See RFC 3678.
		require
			multicast_supported: is_multicast_supported
		local
			imr: EPX_BUFFER
		do
			create imr.allocate_and_clear (posix_ip_mreq_size)
			posix_set_ip_mreq_imr_multiaddr (imr.ptr, sa.host.addresses[0].ptr)
			if a_local_interface_address /= Void then
				posix_set_ip_mreq_imr_interface (imr.ptr, a_local_interface_address.ptr)
			end
			safe_call (abstract_setsockopt (socket, IPPROTO_IP, IP_ADD_MEMBERSHIP, imr.ptr, imr.capacity))
		end


feature {NONE} -- Implementation

	set_default_socket_options
			-- Set default options for a newly created socket.
		require
			open: is_open
			unbound: not is_bound
		do
			-- Common option:
			-- set_reuse_address (true)
		end


invariant

	sa_not_void: is_bound implies sa /= Void

end
