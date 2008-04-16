indexing

	description: "Class that covers the Single Unix Spec netinet/in.h header."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


class

	SAPI_IN


feature -- Host to network conversions

	posix_ntohl (a_value: INTEGER): INTEGER is
			-- Convert 32-bit integer from network byte order to host
			-- byte order.
		external "C"
		end

	posix_htonl (a_value: INTEGER): INTEGER is
			-- Convert 32-bit integer from host byte order to network
			-- byte order.
		external "C"
		end

	posix_htons (host16bitvalue: INTEGER): INTEGER is
			-- Convert 16-bit integer to network byte order.
		require
			valid_value: host16bitvalue >= 0 and host16bitvalue <= 65535
		external "C"
		end

	posix_ntohs (host16bitvalue: INTEGER): INTEGER is
			-- Convert 16-bit integer to host byte order.
		require
			valid_value: host16bitvalue >= 0 and host16bitvalue <= 65535
		external "C"
		end


feature -- C binding for members of in_addr

	posix_in_addr_size: INTEGER is
		external "C"
		ensure
			size_positive: Result > 0
		end

	posix_in_addr_s_addr (a_in_addr: POINTER): INTEGER is
		external "C"
		end

	posix_set_in_addr_s_addr (a_in_addr: POINTER; s_addr: INTEGER) is
		external "C"
		end


feature -- C binding for members of in6_addr

	posix_in6_addr_size: INTEGER is
		external "C"
		ensure
			size_positive: Result > 0
		end

	posix_in6_addr_s6_addr (a_in6_addr: POINTER): POINTER is
		external "C"
		end

	posix_set_in6_addr_s6_addr (a_in6_addr: POINTER; s6_addr: POINTER) is
		external "C"
		end


feature -- C binding for members of sockaddr_in

	posix_sockaddr_in_size: INTEGER is
		external "C"
		end

	posix_sockaddr_in_sin_family (a_sockaddr_in: POINTER): INTEGER is
			-- AF_INET
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_sockaddr_in_sin_port (a_sockaddr_in: POINTER): INTEGER is
			-- Port number.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_sockaddr_in_sin_addr (a_sockaddr_in: POINTER): POINTER is
			-- Internet address.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_set_sockaddr_in_sin_family (a_sockaddr_in: POINTER; sin_family: INTEGER) is
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_set_sockaddr_in_sin_port (a_sockaddr_in: POINTER; sin_port: INTEGER) is
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
			valid_port: sin_port >= 0 and sin_port <= 65535
		external "C"
		end

	posix_set_sockaddr_in_sin_addr (a_sockaddr_in: POINTER; sin_addr: POINTER) is
			-- Set sin_addr by moving bytes from `sin_addr'.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
			valid_sin_addr: sin_addr /= default_pointer
		external "C"
		end


feature -- C binding for members of sockaddr_in6

	posix_sockaddr_in6_size: INTEGER is
		external "C"
		end

	posix_sockaddr_in6_sin6_family (a_sockaddr_in: POINTER): INTEGER is
			-- AF_INET
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_sockaddr_in6_sin6_port (a_sockaddr_in: POINTER): INTEGER is
			-- Port number.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_sockaddr_in6_sin6_addr (a_sockaddr_in: POINTER): POINTER is
			-- Internet address.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_sockaddr_in6_sin6_scope_id (a_sockaddr_in: POINTER): INTEGER is
			-- The sin6_scope_id field is a 32-bit integer that
			-- identifies a set of interfaces as appropriate for the
			-- scope of the address carried in the sin6_addr field.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_set_sockaddr_in6_sin6_family (a_sockaddr_in: POINTER; sin_family: INTEGER) is
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
		external "C"
		end

	posix_set_sockaddr_in6_sin6_port (a_sockaddr_in: POINTER; sin_port: INTEGER) is
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
			valid_port: sin_port >= 0 and sin_port <= 65535
		external "C"
		end

	posix_set_sockaddr_in6_sin6_addr (a_sockaddr_in: POINTER; sin_addr: POINTER) is
			-- Set sin_addr by moving bytes from `sin_addr'.
		require
			valid_sockaddr_in: a_sockaddr_in /= default_pointer
			valid_sin_addr: sin_addr /= default_pointer
		external "C"
		end


end
