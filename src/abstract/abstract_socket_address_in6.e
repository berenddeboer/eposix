indexing

	description: "Class that describes struct sockaddr_in6."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	ABSTRACT_SOCKET_ADDRESS_IN6


inherit

	ABSTRACT_SOCKET_ADDRESS_IN_BASE


feature -- Access

	address_family: INTEGER is
			-- Family.
		do
			Result := abstract_api.posix_sockaddr_in6_sin6_family (buf.ptr)
		end

	port: INTEGER is
			-- 16-bit TCP or UDP port number.
		do
			Result := abstract_api.posix_ntohs (abstract_api.posix_sockaddr_in6_sin6_port (buf.ptr))
		end

	supported_family: INTEGER is
		do
			Result := AF_INET6
		end


feature -- Status

	is_ip_address_family: BOOLEAN is True
			-- Is `address_family' the IPv4 or IPv6 protocol?


feature {NONE} -- Access

	sin_addr: POINTER is
			-- Pointer to sin_addr (or sin6_addr) field.
		do
			Result := abstract_api.posix_sockaddr_in6_sin6_addr (buf.ptr)
		end


feature -- Set

	set_address (an_ip_address: ABSTRACT_IP_ADDRESS) is
			-- Set `address_family' and `address'.
		do
			abstract_api.posix_set_sockaddr_in6_sin6_family (buf.ptr, an_ip_address.address_family)
			abstract_api.posix_set_sockaddr_in6_sin6_addr (buf.ptr, an_ip_address.ptr)
			address := an_ip_address
		end

	set_port (a_port: INTEGER) is
			-- Set `port'.
		do
			abstract_api.posix_set_sockaddr_in6_sin6_port (buf.ptr, abstract_api.posix_htons (a_port))
		end


feature -- Features the C API calls like

	length: INTEGER is
			-- Size of struct sockaddr_in6.
		do
			Result := abstract_api.posix_sockaddr_in6_size
		end

end
