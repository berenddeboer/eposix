note

	description: "Class that covers the Single Unix Spec netinet/in.h header."

	author: "Berend de Boer"


class

	SAPI_IN


feature -- Host to network conversions

	posix_ntohl (a_value: INTEGER): INTEGER
			-- Convert 32-bit integer from network byte order to host
			-- byte order.
		external "C"
		end

	posix_htonl (a_value: INTEGER): INTEGER
			-- Convert 32-bit integer from host byte order to network
			-- byte order.
		external "C"
		end

	posix_htons (host16bitvalue: INTEGER): INTEGER
			-- Convert 16-bit integer to network byte order.
		require
			valid_value: host16bitvalue >= 0 and host16bitvalue <= 65535
		external "C"
		end

	posix_ntohs (host16bitvalue: INTEGER): INTEGER
			-- Convert 16-bit integer to host byte order.
		require
			valid_value: host16bitvalue >= 0 and host16bitvalue <= 65535
		external "C"
		end


feature -- C binding for members of in_addr

	posix_in_addr_size: INTEGER
		external "C"
		ensure
			size_positive: Result > 0
		end

	posix_in_addr_s_addr (a_in_addr: POINTER): INTEGER
		external "C"
		end

	posix_set_in_addr_s_addr (a_in_addr: POINTER; s_addr: INTEGER)
		external "C"
		end


feature -- C binding for members of in6_addr

	posix_in6_addr_size: INTEGER
		external "C"
		ensure
			size_positive: Result > 0
		end

	posix_in6_addr_s6_addr (a_in6_addr: POINTER): POINTER
		external "C"
		end

	posix_set_in6_addr_s6_addr (a_in6_addr: POINTER; s6_addr: POINTER)
		external "C"
		end


feature -- C binding for members of sockaddr_in

	posix_sockaddr_in_size: INTEGER
		external "C"
		end

	posix_sockaddr_in_sin_family (a_sockaddr_in: POINTER): INTEGER
			-- AF_INET
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_sockaddr_in_sin_port (a_sockaddr_in: POINTER): INTEGER
			-- Port number.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_sockaddr_in_sin_addr (a_sockaddr_in: POINTER): POINTER
			-- Internet address.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_set_sockaddr_in_sin_family (a_sockaddr_in: POINTER; sin_family: INTEGER)
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_set_sockaddr_in_sin_port (a_sockaddr_in: POINTER; sin_port: INTEGER)
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
			valid_port: sin_port >= 0 and sin_port <= 65535
		external "C"
		end

	posix_set_sockaddr_in_sin_addr (a_sockaddr_in: POINTER; sin_addr: POINTER)
			-- Set sin_addr by moving bytes from `sin_addr'.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
			valid_sin_addr: sin_addr /= default_pointer
		external "C"
		end


feature -- C binding for members of sockaddr_in6

	posix_sockaddr_in6_size: INTEGER
		external "C"
		end

	posix_sockaddr_in6_sin6_family (a_sockaddr_in: POINTER): INTEGER
			-- AF_INET
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_sockaddr_in6_sin6_port (a_sockaddr_in: POINTER): INTEGER
			-- Port number.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_sockaddr_in6_sin6_addr (a_sockaddr_in: POINTER): POINTER
			-- Internet address.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_sockaddr_in6_sin6_scope_id (a_sockaddr_in: POINTER): INTEGER
			-- The sin6_scope_id field is a 32-bit integer that
			-- identifies a set of interfaces as appropriate for the
			-- scope of the address carried in the sin6_addr field.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_set_sockaddr_in6_sin6_family (a_sockaddr_in: POINTER; sin_family: INTEGER)
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_set_sockaddr_in6_sin6_port (a_sockaddr_in: POINTER; sin_port: INTEGER)
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
			valid_port: sin_port >= 0 and sin_port <= 65535
		external "C"
		end

	posix_set_sockaddr_in6_sin6_addr (a_sockaddr_in: POINTER; sin_addr: POINTER)
			-- Set sin_addr by moving bytes from `sin_addr'.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
			valid_sin_addr: sin_addr /= default_pointer
		external "C"
		end

feature -- C binding for members of ip_mreq

	posix_ip_mreq_size: INTEGER
			-- Size will be 0 if multicast is not supported.
		external "C"
		end

	posix_ip_mreq_imr_multiaddr (a_ip_mreq: POINTER): POINTER
			-- IP address of group
		require
			have_struct_pointer: a_ip_mreq /= default_pointer
		external "C"
		end

	posix_ip_mreq_imr_interface (a_ip_mreq: POINTER): POINTER
			-- IP address of interface
		require
			have_struct_pointer: a_ip_mreq /= default_pointer
		external "C"
		end

	posix_set_ip_mreq_imr_multiaddr (a_ip_mreq: POINTER; imr_multiaddr: POINTER)
		require
			have_struct_pointer: a_ip_mreq /= default_pointer
		external "C"
		end

	posix_set_ip_mreq_imr_interface (a_ip_mreq: POINTER; imr_interface: POINTER)
		require
			have_struct_pointer: a_ip_mreq /= default_pointer
		external "C"
		end

end
