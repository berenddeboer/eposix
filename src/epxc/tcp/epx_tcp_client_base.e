note

	description:

		"Base class for Internet TCP protocols that connect to a server with a user name and password."

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer"
	license: "MIT License"


deferred class

	EPX_TCP_CLIENT_BASE


inherit

	STDC_BASE

	EPX_SERVICE_STRINGS
		export
			{NONE} all
		end


feature {NONE} -- Initialisation

	make (a_server_name, a_user_name, a_password: STRING)
			-- Initialize.
		require
			valid_server_name: a_server_name /= Void and then not a_server_name.is_empty
		do
			make_with_port (a_server_name, 0, a_user_name, a_password)
		end

	make_with_port (a_server_name: STRING; a_port: INTEGER; a_user_name, a_password: detachable STRING)
			-- Initialize with a given port. If `a_port' is null the
			-- `default_port' is taken.
		require
			valid_server_name: a_server_name /= Void and then not a_server_name.is_empty
			valid_port: a_port >= 0 and then a_port <= 65535
		do
			server_name := a_server_name
			if a_port = 0 then
				create service.make_from_name_with_default (default_port_name, once_tcp, default_port)
			else
				create service.make_from_port (a_port, once_tcp)
			end
			if attached a_user_name as u then
				user_name := u
			else
				user_name := ""
			end
			if attached a_password as p then
				password := p
			else
				password := ""
			end
		end


feature -- Open and close

	open
			-- Open connection to `server_name'. Check `is_open' if successful.
			-- Check `last_reply_code' for details.
		require
			closed: not is_open
		local
			my_host: like host
		do
			create my_host.make_from_name (server_name)
			host := my_host
			if my_host.found then
				if is_secure_connection then
					open_ssl
				else
					open_tcp
				end
			end
		end

	close
			-- Close connection to server.
		require
			open: is_open
		do
			if attached socket as a_socket then
				a_socket.close
			end
			socket := Void
		ensure
			closed: not is_open
			not_authenticated: not is_authenticated
		end


feature {NONE} -- Open

	open_ssl
			-- Open secure connection to `server_name'.
		require
			closed: not is_open
			resolved: is_resolved
		local
			openssl: EPX_OPENSSL
		do
			create openssl.make_ssl3_client (server_name, service.port)
			-- inherit error handling
			openssl.inherit_error_handling (Current)
			openssl.execute
			openssl.wait_for (False)
			if not openssl.is_terminated then
				socket := openssl
			end
		end

	open_tcp
			-- Open connection to `server_name'.
		require
			closed: not is_open
			resolved: is_resolved
		local
			host_port: EPX_HOST_PORT
			tcp: EPX_TCP_CLIENT_SOCKET
		do
			if attached host as h then
				create host_port.make (h, service)
				create tcp.make
				tcp.inherit_error_handling (Current)
				tcp.open_by_address (host_port)
				if tcp.is_open then
					socket := tcp
					authenticate
				end
			end
		end


feature -- Access

	default_port: INTEGER
			-- Default port for this protocol.
		deferred
		ensure
			valid_port: Result >= 1 and then Result <= 65535
		end

	default_port_name: STRING
			-- Default port name for this protocol.
		deferred
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	password: STRING
			-- Optional password

	server_name: STRING
			-- Name of server that is being accessed

	user_name: STRING
			-- Optional user name


feature -- Status

	end_of_input: BOOLEAN
			-- Has the end of input been reached? This indicates that the
			-- server has closed the connection.
		require
			open: is_open
		do
			Result := attached socket as a_socket and then a_socket.end_of_input
		end

	is_authenticated: BOOLEAN
			-- Has the user been authenticated?
			-- This is an optional feature for certain implementation.
		deferred
		ensure
			must_be_open: Result implies is_open
			only_when_open: not is_open implies not Result
		end

	is_open: BOOLEAN
			-- Is client connected to server?
		do
			Result := socket /= Void
		ensure
			definition: Result implies socket /= Void
		end

	is_resolved: BOOLEAN
			-- Could host be found?
			-- Set by `open'.
		do
			Result := attached host as h and then h.found
		ensure
			definition: Result implies (attached host as h and then h.found)
		end

	is_secure_connection: BOOLEAN
			-- Is SSL used to communicate with the server?


feature -- Change

	set_user_name_and_password (a_user_name, a_password: STRING)
			-- Set both `user_name' and `password'.
		do
			user_name := a_user_name
			password := a_password
		end


feature -- Commands

	authenticate
		-- Authenticate client with user `user_name' and password
		-- `password'.
		require
			not_authenticated: not is_authenticated
		deferred
		end


feature {NONE} -- Implementation

	host: detachable EPX_HOST

	service: EPX_SERVICE

-- 	socket: ABSTRACT_TCP_CLIENT_SOCKET
	socket: detachable EPX_TEXT_IO_STREAM
			-- Connection to server;
			-- Because of use of `sslcient', tunneling through ssl, this
			-- cannot be a ABSTRACT_TCP_CLIENT_SOCKET, which it would be
			-- if ssl was natively supported.

	tcp_socket: detachable ABSTRACT_TCP_CLIENT_SOCKET
			-- `socket' cast to ABSTRACT_TCP_CLIENT_SOCKET
		require
			socket_not_void: socket /= Void
		do
			if attached {ABSTRACT_TCP_CLIENT_SOCKET} socket as s then
				Result := s
			end
		ensure
			not_void_when_not_using_ssl: not is_secure_connection and then errno.is_ok implies Result /= Void
		end


invariant

	service_not_void: attached service
	socket_void_or_connected: not attached socket as a_socket or else a_socket.is_open
	connected_is_readable: attached socket as a_socket implies a_socket.is_open_read
	open_implies_resolved: is_open implies is_resolved

	valid_server_name: attached server_name and then not server_name.is_empty

end
