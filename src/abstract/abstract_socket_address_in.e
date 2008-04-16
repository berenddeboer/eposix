indexing

	description: "Class that describes struct sockaddr_in."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	ABSTRACT_SOCKET_ADDRESS_IN


inherit

	ABSTRACT_SOCKET_ADDRESS_IN_BASE


feature -- Access

	address_family: INTEGER is
			-- Family, probably AF_INET.
		do
			Result := abstract_api.posix_sockaddr_in_sin_family (buf.ptr)
		end

	port: INTEGER is
			-- 16-bit TCP or UDP port number.
		do
			Result := abstract_api.posix_ntohs (abstract_api.posix_sockaddr_in_sin_port (buf.ptr))
		end

	supported_family: INTEGER is
		do
			Result := AF_INET
		end


feature -- Status

	is_ip_address_family: BOOLEAN is True
			-- Is `address_family' the IPv4 or IPv6 protocol?


feature {NONE} -- Access

	sin_addr: POINTER is
			-- Pointer to sin_addr field.
		do
			Result := abstract_api.posix_sockaddr_in_sin_addr (buf.ptr)
		end


feature -- Set

	set_address (an_ip_address: ABSTRACT_IP_ADDRESS) is
			-- Set `address_family' and `address'.
		do
			abstract_api.posix_set_sockaddr_in_sin_family (buf.ptr, an_ip_address.address_family)
			abstract_api.posix_set_sockaddr_in_sin_addr (buf.ptr, an_ip_address.ptr)
			address := an_ip_address
		end

	set_port (a_port: INTEGER) is
			-- Set `port'.
		do
			abstract_api.posix_set_sockaddr_in_sin_port (buf.ptr, abstract_api.posix_htons (a_port))
		end


feature -- Features the C API calls like

	length: INTEGER is
			-- Size of my struct sockaddr_in.
		once
			Result := abstract_api.posix_sockaddr_in_size
		end


end
