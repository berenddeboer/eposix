indexing

	description: "Unix portable implementation of host on the network."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	EPX_HOST


inherit

	ABSTRACT_HOST

	SAPI_NETDB
		export
			{NONE} all
		end


create

	make_from_name,
	make_from_address,
	make_from_ip4_any,
	make_from_ip4_loopback


feature {NONE} -- Abstract API

	abstract_gethostbyaddr (an_addr: POINTER; a_len, a_type: INTEGER): POINTER is
			-- Retrieve host information corresponding to address
			-- `an_addr' If returned pointer is default_pointer, check
			-- `abstract_h_errno' for the error reason.
		do
			Result := posix_gethostbyaddr (an_addr, a_len, a_type)
		end

	abstract_gethostbyname (a_hostname: POINTER): POINTER is
			-- Retrieve host information corresponding to `a_hostname'
			-- from a host database. If returned pointer is
			-- default_pointer, check `abstract_h_errno' for the error
			-- reason.
		do
			Result := posix_gethostbyname (a_hostname)
		end

	abstract_h_errno: INTEGER is
			-- Last error set by `abstract_gethostbyname'.
		do
			Result := posix_h_errno
		end

end
