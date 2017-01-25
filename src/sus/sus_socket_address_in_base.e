note

	description: "Base class for classes that describe sockaddr_in and sockaddr_in6. Basically this is a struct with an address family, an IP address, and a port."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


deferred class

	SUS_SOCKET_ADDRESS_IN_BASE


inherit

	SUS_BASE

	SAPI_IN
		export
			{NONE} all
		end

	EPX_POINTER_HELPER
		export
			{NONE} all
		end


feature {NONE} -- Initialization

	make (an_ip_address: SUS_IP_ADDRESS; a_port: INTEGER)
			-- Initialize sockaddr_in from `an_address'.
		require
			an_ip_address_not_void: an_ip_address /= Void
			valid_port: a_port >= 0 and a_port <= 65535
			family_supported: an_ip_address.address_family = supported_family
		do
			create buf.allocate_and_clear (length)
			set_address (an_ip_address)
			set_port (a_port)
		ensure
			address_set: address = an_ip_address
			address_family_set: address_family = an_ip_address.address_family
			port_set: port = a_port
		end

	make_from_pointer (an_address: POINTER; a_size: INTEGER)
			-- Initialize a socket address by passing it a memory
			-- location where the information is stored. The information
			-- in `an_address' is copied.
			-- `an_address' should contain a pointer to a struct with a
			-- family supported by this class.
		require
			a_size_equal_to_length: a_size = length
		do
			create buf.allocate (length)
			buf.memory_copy (an_address, 0, 0, a_size)
			if address_family = AF_INET then
				create {SUS_IP4_ADDRESS} address.make_from_pointer (sin_addr)
			elseif address_family = AF_INET6 then
				create {SUS_IP6_ADDRESS} address.make_from_pointer (sin_addr)
			else
				do_raise ("Unhandled address family " + address_family.out)
			end
		end


feature -- Access

	address: SUS_IP_ADDRESS
			-- IP address.

	address_family: INTEGER
			-- Family, probably AF_INET or AF_INET6.
		deferred
		end

	port: INTEGER
			-- 16-bit TCP or UDP port number.
		deferred
		ensure
			valid_port_number: port >= 0 and port <= 65535
		end

	supported_family: INTEGER
			-- Family supported by this struct.
			-- Should be hard coded to return the family supported by the struct.
		deferred
		end


feature {NONE} -- Access

	sin_addr: POINTER
			-- Pointer to sin_addr (or sin6_addr) field.
		deferred
		ensure
			sin_addr_not_nil: Result /= default_pointer
		end


feature -- Set

	set_address (an_ip_address: SUS_IP_ADDRESS)
			-- Set `address_family' and `address'.
		require
			an_ip_address_not_void: an_ip_address /= Void
			family_supported: an_ip_address.address_family = supported_family
		deferred
		ensure
			address_set: address = an_ip_address
			address_family_set: address_family = an_ip_address.address_family
		end

	set_port (a_port: INTEGER)
			-- Set `port'.
		require
			valid_port: a_port >= 0 and a_port <= 65535
		deferred
		ensure
			port_set: port = a_port
		end


feature -- Features the C API calls like

	length: INTEGER
			-- Size of my struct (sockaddr_in or sockaddr_in6).
		deferred
		ensure
			length_positive: length > 0
		end

	frozen ptr: POINTER
			-- Points to struct sockaddr_in or sockaddr_in6.
		do
			Result := buf.ptr
		ensure
			valid_result: Result /= default_pointer
		end


feature {NONE} -- Implementation

	buf: STDC_BUFFER
			-- Pointer to a struct sockaddr_in/sockaddr_in6 structure.


invariant

	valid_buf: buf /= Void and then buf.capacity >= length
	family_supported: supported_family = address_family
	family_in_sync: address.address_family = address_family

end
