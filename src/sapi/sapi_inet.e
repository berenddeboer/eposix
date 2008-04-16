indexing

	description: "Class that covers the Single Unix Spec arpa/inet.h header."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	SAPI_INET


inherit

	ANY

	SUS_CONSTANTS
		export
			{NONE} all;
			{ANY}
				AF_INET,
				AF_INET6,
				INET_ADDRSTRLEN,
				INET6_ADDRSTRLEN
		end


feature -- Conversion functions

	posix_inet_ntoa (a_in: POINTER): POINTER is
			-- Converts the Internet host address specified by `a_in' to
			-- a string in the Internet standard dot notation.
			-- Returns `default_pointer' on error.
		require
			valid_in: a_in /= default_pointer
		external "C"
		end

	posix_inet_ntop (an_address_family: INTEGER; a_src, a_dst: POINTER; a_size: INTEGER): POINTER is
			-- Converts the network address structure `a_src' in the
			-- `an_address family` into a character string, which is
			-- copied to a character buffer `a_dst', which is `a_size'
			-- bytes long.
		require
			valid_src: a_src /= default_pointer
			valid_dst: a_dst /= default_pointer
			size_valid:
				(an_address_family = AF_INET implies a_size >= INET_ADDRSTRLEN) and
				(an_address_family = AF_INET6 implies a_size >= INET6_ADDRSTRLEN)
		external "C"
		end


end
