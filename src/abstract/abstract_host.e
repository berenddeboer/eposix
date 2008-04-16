indexing

	description: "Class that describes a host on the network including the local machine. Contains the common functionality between Unix and Windows"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


deferred class

	ABSTRACT_HOST


inherit

	ABSTRACT_NET_BASE

	EPX_POINTER_HELPER
		export
			{NONE} all
		end


feature -- Initialization

	make_from_name (a_name: STRING) is
			-- Initialize host from `name'. If `name' is numerical, the
			-- behaviour is not specified.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			name := a_name
			find_by_name
		end

	make_from_address (an_address: ABSTRACT_IP_ADDRESS) is
			-- Initialize host from ip address `an_address'.
			-- An attempt is made to resolve the host name using this address.
			-- Status is always found, even when reverse lookup failed.
		require
			valid_address: an_address /= Void
		do
			create addresses.make (0, 0)
			addresses.put (an_address, addresses.lower)
			find_by_address
			if not found then
				create aliases.make (0, -1)
				create addresses.make (0, 0)
				addresses.put (an_address, addresses.lower)
				address_family := an_address.address_family
				address_length := an_address.address_length
				my_not_found_reason := 0
			end
		ensure
			always_found: found
		end

	make_from_ip4_any is
			-- IP address that refers to all local interfaces.
		local
			any_ip_address: EPX_IP4_ADDRESS
		do
			create any_ip_address.make_from_any
			make_from_unresolved_address (any_ip_address)
			name := "localhost"
			canonical_name := name
		ensure
			always_found: found
			one_address: addresses.count = 1
		end

	make_from_ip4_loopback is
			-- IP address that refers to the loopback device.
			-- No attempt at resolving is done.
		local
			local_ip_address: EPX_IP4_ADDRESS
		do
			create local_ip_address.make_from_loopback
			make_from_unresolved_address (local_ip_address)
			name := "localhost"
			canonical_name := name
		ensure
			always_found: found
			one_address: addresses.count = 1
			loopback_address: addresses.item (addresses.lower).is_loopback_address
		end


feature {NONE} -- Initialization

	make_from_unresolved_address  (an_address: ABSTRACT_IP_ADDRESS) is
			-- Initialize host from ip address `an_address'.
			-- No attempt is made to resolve the ip address.
			-- `name'
		require
			valid_address: an_address /= Void
		do
			create addresses.make (0, 0)
			addresses.put (an_address, addresses.lower)
			create aliases.make (0, -1)
			address_family := an_address.address_family
			address_length := an_address.address_length
			my_not_found_reason := 0
		ensure
			found: found
			not_found_reason_reset: my_not_found_reason = 0
			one_address: addresses.count = 1
			address_set: addresses.item (addresses.lower) = an_address
			family_set: address_family = an_address.address_family
			length_set: address_length = an_address.address_length
		end


feature -- Command

	find_by_address is
			-- Attempt to lookup up the host by first ip address in
			-- `addresses'. Sets `found' if host could be found.
			-- If found, sets `canonical_name', `aliases',
			-- `address_family', `address_length' and `addresses'.
		require
			have_address: addresses /= Void and then not addresses.is_empty
		local
			address: ABSTRACT_IP_ADDRESS
			p: POINTER
		do
			address := addresses.item (addresses.lower)
			p := abstract_gethostbyaddr (address.ptr, address.address_length, address.address_family)
			set_from_hostent (p)
		end

	find_by_name is
			-- Attempt to lookup up the host given in `name'. Sets
			-- `found' if host could be found.
			-- If found, sets `canonical_name', `aliases',
			-- `address_family', `address_length' and `addresses'.
		require
			name_not_empty: name /= Void and then not name.is_empty
		local
			p: POINTER
		do
			p := abstract_gethostbyname (sh.string_to_pointer (name))
			sh.unfreeze_all
			set_from_hostent (p)
		end


feature -- Status

	found: BOOLEAN is
			-- Does this class contain a resolved host?
			-- If False, `not_found_reason' contains the reason.
		do
			Result := addresses /= Void
		end


feature -- Access

	name: STRING
			-- Name as given to `make_from_name' or else equal to
			-- `canonical_name'

	not_found_reason: INTEGER is
			-- Reason why `found' is False;
			--  The interpretation of this value depends on the platform.
		require
			not_found: not found
		do
			Result := my_not_found_reason
		end

	canonical_name: STRING
			-- Official (canonical) name of host.

	aliases: ARRAY [STRING]
			-- Alias names.

	address_family: INTEGER
			-- Host address type: AF_INET or AF_INET6

	address_length: INTEGER
			-- Length of address: 4 or 16.

	addresses: ARRAY [ABSTRACT_IP_ADDRESS]
			-- Array with IPv4 or IPv6 addresses.


feature {NONE} -- Implementation

	my_not_found_reason: INTEGER
			-- Private variable containting code of not found.

	is_every_address_not_void: BOOLEAN is
			-- Is every address in `addresses' not Void?
		require
			found: found
		local
			i: INTEGER
		do
			from
				i := addresses.lower
				Result := True
			until
				not Result or else
				i > addresses.upper
			loop
				Result := addresses.item (i) /= Void
				i := i + 1
			end
		end

	set_from_hostent (p: POINTER) is
			-- Set fields assuming `p' is a pointer to a hostent struct.
		local
			pptr: POINTER
			aptr: POINTER
			ip_address: ABSTRACT_IP_ADDRESS
		do
			if p = default_pointer then
				canonical_name := Void
				aliases := Void
				addresses := Void
				my_not_found_reason := abstract_h_errno
			else
				canonical_name := sh.pointer_to_string (abstract_api.posix_hostent_h_name (p))
				if name = Void then
					name := canonical_name
				end
				aliases := ah.pointer_to_string_array (abstract_api.posix_hostent_h_aliases (p))
				address_family := abstract_api.posix_hostent_h_addrtype (p)
				address_length := abstract_api.posix_hostent_h_length (p)
				from
					create addresses.make (0, -1)
					pptr := abstract_api.posix_hostent_h_addr_list (p)
					aptr := posix_pointer_contents (pptr)
				until
					aptr = default_pointer
				loop
					if address_family = AF_INET then
						create {EPX_IP4_ADDRESS} ip_address.make_from_pointer (aptr)
					elseif address_family = AF_INET6 then
						create {EPX_IP6_ADDRESS} ip_address.make_from_pointer (aptr)
					else
						do_raise ("Unrecognized address family " + address_family.out)
					end
					addresses.force (ip_address, addresses.upper + 1)
					pptr := posix_pointer_advance (pptr)
					aptr := posix_pointer_contents (pptr)
				end
				my_not_found_reason := 0
			end
		ensure
			hostent_set: (p /= default_pointer) = found
		end


feature {NONE} -- Abstract API

	abstract_gethostbyaddr (an_addr: POINTER; a_len, a_type: INTEGER): POINTER is
			-- Retrieve host information corresponding to address
			-- `an_addr'. If returned pointer is default_pointer, check
			-- `abstract_h_errno' for the error reason.
		require
			an_addr_not_nil: an_addr /= default_pointer
			a_len_positive: a_len > 0
		deferred
		ensure
			-- Result = default_pointer implies h_errno set.
		end

	abstract_gethostbyname (a_hostname: POINTER): POINTER is
			-- Retrieve host information corresponding to `a_hostname'
			-- from a host database. If returned pointer is
			-- default_pointer, check `abstract_h_errno' for the error
			-- reason.
		require
			valid_hostname: a_hostname /= default_pointer
		deferred
		ensure
			-- Result = default_pointer implies h_errno set.
		end

	abstract_h_errno: INTEGER is
			-- Last error set by `abstract_gethostbyname'.
		deferred
		end


invariant

	name_void_or_not_empty: name = Void or else not name.is_empty
	has_canonical_name:
		found implies
			((name /= Void) = (canonical_name /= Void))
	has_at_least_one_ip_address: found = (addresses /= Void and then addresses.count > 0)
	only_non_void_addresses: found implies is_every_address_not_void
	has_aliases: found = (aliases /= Void)
	valid_length: found implies address_length > 0
	consistent: addresses /= Void and then addresses.count > 0 implies found
	my_not_found_reason_valid: found = (my_not_found_reason = 0)

end
