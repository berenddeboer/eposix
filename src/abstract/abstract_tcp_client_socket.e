indexing

	description: "Base class for TCP/SOCK_STREAM sockets, client side."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


deferred class

	ABSTRACT_TCP_CLIENT_SOCKET


inherit

	ABSTRACT_TCP_SOCKET


feature -- Socket specific open functions

	open_by_address (hp: EPX_HOST_PORT) is
			-- Open socket to server specified in `hp'.
		require
			closed: not is_open
			hp_not_void: hp /= Void
			supported_family: hp.socket_address.is_ip_address_family
			tcp_protocol: hp.service.is_tcp
		local
			r: INTEGER
			a_fd: INTEGER
		do
			make
			a_fd := new_socket (hp)
			if a_fd /= unassigned_value then
				r := abstract_connect (a_fd, hp.socket_address.ptr, hp.socket_address.length)
				if r /= -1 then
					capacity := 1
					set_handle (a_fd, True)
					-- Optimize for streaming reads/writes.
					set_streaming (True)
					is_open_read := True
					is_open_write := True
				else
					protected_close_socket (a_fd)
					fd := unassigned_value
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

	open_by_name_and_port (a_host_name: STRING; a_port: INTEGER) is
			-- Initialize given a server name and port.
			-- If `a_host_name' is an ip address, the result is unspecified.
			-- If `a_host_name' cannot be resolved, an exception is thrown.
		require
			closed: not is_open
			host_name_not_empty: a_host_name /= Void and then not a_host_name.is_empty
			valid_port: a_port >= 0 and a_port <= 65535
		local
			host: EPX_HOST
			service: EPX_SERVICE
			hp: EPX_HOST_PORT
		do
			create host.make_from_name (a_host_name)
			if not host.found then
				exceptions.raise ("Host " + a_host_name + " cannot be resolved")
			end
			create service.make_from_port (a_port, once_tcp)
			create hp.make (host, service)
			open_by_address (hp)
		ensure
			is_opened: raise_exception_on_error implies is_open
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end


feature {NONE} -- Abstract API binding

	abstract_connect (a_socket: INTEGER; an_address: POINTER; an_address_length: INTEGER): INTEGER is
			-- Connect a socket.
		require
			valid_socket: a_socket /= unassigned_value
			valid_address: an_address /= default_pointer
			valid_length: an_address_length > 0
		deferred
		end


feature {NONE} -- Once strings

	once_tcp: STRING is "tcp"


end
