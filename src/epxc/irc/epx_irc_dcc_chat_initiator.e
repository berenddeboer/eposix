note

	description:

		"Initiator of a DCC chat session"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "MIT License"


class

	EPX_IRC_DCC_CHAT_INITIATOR


inherit

	EPX_IRC_DCC_CHAT


create

	make_initiate


feature {NONE} -- Initialisation

	make_initiate (a_nick_name: STRING; an_ip4_address: EPX_IP4_ADDRESS)
			-- Begin to offer a DCC chat connection to `a_nick_name' at
			-- address `an_ip_address'. The port is automatically
			-- choosen, see `local_address'.`port'.
			-- Making our intentions known to the client is a separate
			-- issue (see EPX_IRC_CLIENT.`dcc_chat')
		require
			valid_nick_name: is_valid_nick_name (a_nick_name)
			ip_address_not_void: attached an_ip4_address
		local
			host: EPX_HOST
			service: EPX_SERVICE
			my_hp: like hp
		do
			nick_name := a_nick_name
			create host.make_from_address (an_ip4_address)
			create service.make_from_ephemeral_port ("tcp")
			create my_hp.make (host, service)
			hp := my_hp
			create server_socket.listen_by_address (my_hp)
			server_socket.set_blocking_io (False)
			if attached {ABSTRACT_IP4_ADDRESS} server_socket.local_address.address as address then
				local_ip4_address := address
			else
				-- Silence void-safe compiler, we should not get here
				local_ip4_address := an_ip4_address
			end
			local_port := server_socket.local_address.port
		end


feature -- Access

	local_ip4_address: ABSTRACT_IP4_ADDRESS
			-- Server side IP4 address

	local_port: INTEGER
			-- Port where server is listening


feature -- Status

	is_accepted: BOOLEAN
			-- Has client accepted the DCC chat offer?
			-- If the client has accepted the socket, the socket is put
			-- into non-blocking mode, but this can be changed later if
			-- so required.
		do
			Result := socket /= Void
			if not Result then
				socket := server_socket.accept
				Result := socket /= Void
				if Result then
					socket.set_blocking_io (False)
					-- Don't need to accept any more connections.
					server_socket.close
					server_socket := Void
					create last_receive.make_from_now
				end
			end
		ensure
			definition: Result = (socket /= Void)
		end


feature {NONE} -- Implementation

	server_socket: detachable EPX_TCP_SERVER_SOCKET
			-- Socket which accepts the client connection


invariant

	server_socket_available: (socket = Void) = (server_socket /= Void)
	local_ip4_address_not_void: local_ip4_address /= Void
	valid_local_port: local_port >= 1 and then local_port <= 65535


end
