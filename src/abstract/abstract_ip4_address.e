indexing

	description: "IPv4 address at the ABSTRACT_XXXX level."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"


class

	ABSTRACT_IP4_ADDRESS


inherit

	ABSTRACT_IP_ADDRESS
		redefine
			is_equal
		end


feature -- Initialization

	make_from_any is
			-- Initialize using the any address (i.e. 0.0.0.0).
		do
			make_from_integer (INADDR_ANY)
		ensure
			any_address: value= INADDR_ANY
		end

	make_from_integer (a_value: INTEGER) is
			-- Initialize ip address from 32-bit integer.
		do
			if buf = Void then
				create buf.allocate_and_clear (abstract_api.posix_in_addr_size)
			end
			set_value (a_value)
		ensure
			value_set: a_value = value
		end

	make_from_loopback is
			-- Initialize using the loopback address (i.e. 127.0.0.1).
		do
			make_from_integer (INADDR_LOOPBACK)
		ensure
			loopback: is_loopback_address
		end

	make_from_components (a1, a2, a3, a4: INTEGER) is
			-- Make IP4 address given the four individual fields of an IP
			-- 4 address.
		require
			a1_is_byte: a1 >= 0 and a1 <= 255
			a2_is_byte: a2 >= 0 and a2 <= 255
			a3_is_byte: a3 >= 0 and a3 <= 255
			a4_is_byte: a4 >= 0 and a4 <= 255
		local
			a: INTEGER
		do
			-- Trickery to handle Eiffel's inability to address unsigned numbers.
			if a1 < 128 then
				a := a1 * 16777216
			else
				a := (a1 - 128) * 16777216
			end
			a := a + a2 * 65536 + a3 * 256 + a4
			-- Flip high bit
			if a1 >= 128 then
				a := -2147483647 + a - 1
			end
			make_from_integer (a)
		end

	make_from_pointer (a_ptr: POINTER) is
			-- Initialize ip address from 32-bit integer pointed to by `a_ptr'.
			-- We assume `a_ptr' points to a value in network byte order.
		local
			n: INTEGER
		do
			if buf = Void then
				create buf.allocate_and_clear (abstract_api.posix_in_addr_size)
			end
			n := posix_peek_int32_native (a_ptr, 0)
			set_value (abstract_api.posix_ntohl (n))
		end


feature -- Status

	is_loopback_address: BOOLEAN is
			-- Does this IP address refer to the loopback address?
		do
			Result := value = INADDR_LOOPBACK
		ensure then
			definition: Result = (value = INADDR_LOOPBACK)
		end


feature -- Access

	value: INTEGER is
			-- IPv4 address as 32-bit integer.
			-- Value is in host byte order.
		local
			n: INTEGER
		do
			n := abstract_api.posix_in_addr_s_addr (buf.ptr)
			Result := abstract_api.posix_ntohl (n)
		end


feature -- Change

	set_value (new_value: INTEGER) is
			-- Change IP address `value' to `new_value'.
		local
			n: INTEGER
		do
			n := abstract_api.posix_htonl (new_value)
			abstract_api.posix_set_in_addr_s_addr (buf.ptr, n)
		ensure
			value_set: value = new_value
		end


feature -- Comparison

	is_equal (other: like Current): BOOLEAN is
			-- Is `other' IP4 address equal to this IP address?
		do
			Result := value = other.value
		end


feature -- Output

	out: STRING is
			-- Friendly out
		do
			Result := sh.pointer_to_string (abstract_api.posix_inet_ntoa (buf.ptr))
		end


feature -- General ip address features

	address_length: INTEGER is 4
			-- Length of an IPv4 address is 4.

	address_family: INTEGER is
			-- Is it an ip4 or ip6 address.
		do
			Result := AF_INET
		end


feature {NONE} -- Implementation

	posix_peek_int32_native (p: POINTER; index: INTEGER): INTEGER is
			-- Read integer at position `index'.
		require
			valid_memory: p /= default_pointer
		external "C"
		end


invariant

	buf_capacity_large_enough: buf.capacity >= abstract_api.posix_in_addr_size

end
