indexing

	description: "Abstract level IPv6 address."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


deferred class

	ABSTRACT_IP6_ADDRESS


inherit

	ABSTRACT_IP_ADDRESS
		redefine
			is_equal
		end

	CAPI_STRING
		export
			{NONE} all
		undefine
			is_equal,
			out
		end


feature -- Initialization

	make_from_pointer (a_ptr: POINTER) is
			-- Initialize ip address from 32-bit integer.
		do
			if buf = Void then
				create buf.allocate_and_clear (abstract_api.posix_in6_addr_size)
			end
			set_address (a_ptr)
		end


feature -- Comparison

	is_equal (other: like Current): BOOLEAN is
			-- Is `other' IP4 address equal to this IP address?
		do
			Result := posix_memcmp (ptr, other.ptr, address_length) = 0
		end


feature -- Output

	out: STRING is
			-- Friendly out
		do
			Result := sh.pointer_to_string (abstract_api.posix_inet_ntop (address_family, buf.ptr, dest.ptr, dest.capacity))
			Result := sh.pointer_to_string (dest.ptr)
		end


feature -- Status

	is_loopback_address: BOOLEAN is
			-- Does this IP address refer to the loopback address?
		do
			-- @@BdB: Ehh, does this actually work??
			Result := out.is_equal (once_in6addr_loopback)
		end


feature -- General ip address features

	address_length: INTEGER is 16
			-- Length of an IPv6 address is 16.

	address_family: INTEGER is
			-- Is it an ip4 or ip6 address.
		do
			Result := AF_INET6
		end

	scope_id: INTEGER is
		deferred
		end


feature {NONE} -- Implementation

	dest: STDC_BUFFER is
		once
			create Result.allocate (INET6_ADDRSTRLEN)
		ensure
			dest_not_void: dest /= Void
			dest_capacity_large_enough: dest.capacity >= INET6_ADDRSTRLEN
		end

	set_address (a_ptr: POINTER) is
			-- Set IPv6 address to address pointed to by `a_ptr'.
		require
			a_ptr_not_nil: a_ptr /= default_pointer
		do
			abstract_api.posix_set_in6_addr_s6_addr (buf.ptr, a_ptr)
		end

	once_in6addr_loopback: STRING is "::1"
			-- Loopback address as string.


invariant

	buf_capacity_large_enough: buf.capacity >= abstract_api.posix_in6_addr_size

end
