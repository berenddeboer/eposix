note

	description:

		"Short description of the class"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "MIT License"

class

	EPX_IRC_DCC_CHAT_ACCEPTOR


inherit

	EPX_IRC_DCC_CHAT


create

	make


feature {NONE} -- Initialisation

	make (a_nick_name: STRING; an_ip4_address: EPX_IP4_ADDRESS; a_port: INTEGER)
			-- Prepare to `open' chat to `a_nick_name' at the given ip
			-- address and port.
		require
			valid_nick_name: is_valid_nick_name (a_nick_name)
			remote_ip_address_not_void: an_ip4_address /= Void
			remote_port_valid: a_port >= 1 and then a_port <= 65535
		do
			do_make (a_nick_name)
			remote_ip_address := an_ip4_address
			remote_port := a_port
		end


feature -- Access

	remote_ip_address: ABSTRACT_IP4_ADDRESS
			-- Address of server waiting to accept the chat request

	remote_port: INTEGER
			-- Port on which server is listening


feature -- Open

	open
			-- Accept chat request by connect to server.
			-- Check `is_open' if `open' was successful.
		local
			client: EPX_TCP_CLIENT_SOCKET
			retried: BOOLEAN
			exceptions: expanded EXCEPTIONS
			host: EPX_HOST
			service: EPX_SERVICE
			my_hp: like hp
		do
			if not retried then
				create host.make_from_address (remote_ip_address)
				create service.make_from_port (remote_port, "tcp")
				create my_hp.make (host, service)
				hp := my_hp
				create client.open_by_address (my_hp)
				if client.is_open then
					socket := client
					socket.set_blocking_io (False)
					create last_receive.make_from_now
				end
			end
		ensure
			non_blocking_socket: is_open implies not socket.is_blocking_io
		rescue
			if exceptions.is_developer_exception then
				if socket.is_open then
					socket.close
				end
				retried := True
				if attached client and then client.is_open then
					client.close
				end
				retry
			end
		end


invariant

	remote_ip_address_not_void: remote_ip_address /= Void
	remote_port_valid: remote_port >= 1 and then remote_port <= 65535

end
