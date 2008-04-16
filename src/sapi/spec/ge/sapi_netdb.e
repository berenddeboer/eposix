indexing

	description: "Class that covers the Single Unix Spec netdb.h header."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	SAPI_NETDB


feature -- Host functions

	posix_gethostbyaddr (an_addr: POINTER; a_len, a_type: INTEGER): POINTER is
			-- Retrieve host information corresponding to address
			-- `an_addr'.
		require
			an_addr_not_nil: an_addr /= default_pointer
			a_len_positive: a_len > 0

		external "C blocking"



		ensure
			-- Result = default_pointer implies h_errno set.
		end

	posix_gethostbyname (a_hostname: POINTER): POINTER is
			-- Retrieve host information corresponding to `a_hostname'
			-- from a host database.
		require
			valid_hostname: a_hostname /= default_pointer

		external "C blocking"



		ensure
			-- Result = default_pointer implies h_errno.is_not_ok
		end

	posix_getservbyname (a_name, a_proto: POINTER): POINTER is
			-- Lookup service given its name and optional protocol.
		require
			valid_name: a_name /= default_pointer

		external "C blocking"



		ensure
			-- Result = default_pointer implies h_errno.is_not_ok
		end

	posix_getservbyport (a_port: INTEGER; a_proto: POINTER): POINTER is
			-- Lookup service given its port number and optional protocol.
		require
			valid_port: a_port >= 0

		external "C blocking"



		ensure
			-- Result = default_pointer implies h_errno.is_not_ok
		end


feature -- C binding for members of hostent

	posix_hostent_size: INTEGER is
		external "C"
		ensure
			valid_result: Result > 0
		end

	posix_hostent_h_name (a_hostent: POINTER): POINTER is
		require
			valid_hostent: a_hostent /= default_pointer
		external "C"
		end

	posix_hostent_h_aliases (a_hostent: POINTER): POINTER is
		require
			valid_hostent: a_hostent /= default_pointer
		external "C"
		end

	posix_hostent_h_addrtype (a_hostent: POINTER): INTEGER is
		require
			valid_hostent: a_hostent /= default_pointer
		external "C"
		end

	posix_hostent_h_length (a_hostent: POINTER): INTEGER is
		require
			valid_hostent: a_hostent /= default_pointer
		external "C"
		end

	posix_hostent_h_addr_list (a_hostent: POINTER): POINTER is
		require
			valid_hostent: a_hostent /= default_pointer
		external "C"
		end


feature -- C binding for members of servent

	posix_servent_size: INTEGER is
		external "C"
		ensure
			valid_result: Result > 0
		end

	posix_servent_s_name (a_servent: POINTER): POINTER is
			-- Official service name.
		require
			valid_servent: a_servent /= default_pointer
		external "C"
		end

	posix_servent_s_aliases (a_servent: POINTER): POINTER is
			-- Alias list.
		require
			valid_servent: a_servent /= default_pointer
		external "C"
		end

	posix_servent_s_port (a_servent: POINTER): INTEGER is
			-- Port number.
		require
			valid_servent: a_servent /= default_pointer
		external "C"
		end

	posix_servent_s_proto (a_servent: POINTER): POINTER is
			-- Protocol to use.
		require
			valid_servent: a_servent /= default_pointer
		external "C"
		end


feature -- h_errno

	posix_h_errno: INTEGER is
			-- Last error set by `posix_gethostbyname'.
		external "C"
		end

end
