indexing

	description: "Combination of a resolved EPX_HOST and EPX_SERVICE. Depending on the addres_family, makes a sockaddr_in or sockaddr_in6 available in `socket_address'."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_HOST_PORT


inherit

	ABSTRACT_NET_BASE


create

	make


feature {NONE} -- Initialization

	make (a_host: EPX_HOST; a_service: EPX_SERVICE) is
			-- Initialize socket for resolved host, using its first ip
			-- address.
		require
			valid_host: a_host /= Void and then a_host.found
			valid_service: a_service /= Void
		do
			host := a_host
			service := a_service
			set_address (host.addresses.lower)
		ensure
			host_set: host = a_host
			service_set: service = a_service
		end


feature -- Access

	host: EPX_HOST
			-- Resolved host name.

	service: EPX_SERVICE
			-- Port and protocol (udp/tcp) type.

	socket_address: ABSTRACT_SOCKET_ADDRESS_IN_BASE
			-- The socket address struct to be used by `connect'.


feature -- Fill socket structure, so `ptr' returns something valid

	set_address (item: INTEGER) is
			-- Use the ip address at `item' of `host' as the socket
			-- address.
		require
			existing_ip_address_item:
				item >= host.addresses.lower and
				item <= host.addresses.upper
		local
			ip_address: ABSTRACT_IP_ADDRESS
		do
			ip_address := host.addresses.item (item)
			if ip_address.address_family = AF_INET then
				create {EPX_SOCKET_ADDRESS_IN} socket_address.make (ip_address, service.port)
			elseif ip_address.address_family = AF_INET6 then
				create {EPX_SOCKET_ADDRESS_IN6} socket_address.make (ip_address, service.port)
			else
				do_raise ("Cannot create proper sockaddr_in struct. Unsupported family " + ip_address.address_family.out)
			end
		end


invariant

	host_resolved: host /= Void and then host.found
	has_service: service /= Void
	socket_address_not_void: socket_address /= Void
	address_type_matches: host.address_family = socket_address.address_family
	port_matches: service.port = socket_address.port

end
