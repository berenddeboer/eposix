indexing

	description: "Features IPv4 and IPv6 classes have in common."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	ABSTRACT_IP_ADDRESS


inherit

	ABSTRACT_NET_BASE
		undefine
			out
		end


feature -- Initialization

	make_from_pointer (a_ptr: POINTER) is
			-- Initialize ip address from pointer to an IPv4 or IPv6
			-- address.
		require
			a_ptr_not_nil: a_ptr /= default_pointer
		deferred
		end


feature -- Status

	is_loopback_address: BOOLEAN is
			-- Does this IP address refer to the loopback address?
		deferred
		end


feature -- General ip address features

	address_family: INTEGER is
			-- Is it an ip4 (AF_INET) or ip6 (AF_INET6) address.
		deferred
		ensure
			address_family_not_zero: address_family /= 0
		end

	address_length: INTEGER is
			-- Length in bytes of an IPv4 or IPv6 address.
		deferred
		ensure
			address_length_positive: Result > 0
		end

	ptr: POINTER is
			-- Pointer to an in_addr or in6_addr structure.
			-- (bytes are in network byte order for in_addr)
		do
			Result := buf.ptr
		ensure
			has_pointer: Result /= default_pointer
		end


feature {NONE} -- Implementation

	buf: STDC_BUFFER


invariant

	buf_not_void: buf /= Void

end
