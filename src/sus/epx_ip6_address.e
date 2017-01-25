note

	description: "SUSv3 implementation of a portable IPv6 address."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_IP6_ADDRESS


inherit

	ABSTRACT_IP6_ADDRESS

	SAPI_IN
		export
			{NONE} all
		undefine
			is_equal,
			out
		end

	SAPI_INET
		export
			{NONE} all
		undefine
			is_equal,
			out
		end


create

	make_from_pointer


feature -- General ip address features

	scope_id: INTEGER
		do
			Result := posix_sockaddr_in6_sin6_scope_id (buf.ptr)
		end


end
