note

	description: "Class that describes service names, i.e. an entry %
	%in /etc/services."

	author: "Berend de Boer"


deferred class

	ABSTRACT_SERVICE


inherit

	ABSTRACT_NET_BASE


feature -- Initialization

	make_from_name (a_name: STRING; a_protocol: detachable STRING)
			-- Retrieve service information with `a_name' and optional
			-- `a_protocol' from services database.
			-- If service not found, an exception is raised.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		local
			p: POINTER
		do
			p := abstract_getservbyname (
				sh.string_to_pointer (a_name),
				sh.string_to_pointer (a_protocol))
			sh.unfreeze_all
			if p = default_pointer then
				-- service with this name does not exist
				raise_posix_error
				create aliases.make_empty
				name := a_name
				create protocol.make_empty
			else
				set_members_from_struct (p, 0, a_protocol)
			end
		end

	make_from_name_with_default (a_name, a_protocol: STRING; a_default_port: INTEGER)
			-- Retrieve service information with `a_name' and optional
			-- `a_protocol' from services database.
			-- If service not found, `a_default_port' is used for `port'.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		local
			p: POINTER
		do
			p := abstract_getservbyname (
				sh.string_to_pointer (a_name),
				sh.string_to_pointer (a_protocol))
			sh.unfreeze_all
			if p = default_pointer then
				port := a_default_port
				name := a_name
				protocol := a_protocol
				guess_protocol_type
				create aliases.make_empty
				create protocol.make_empty
			else
				set_members_from_struct (p, 0, a_protocol)
			end
		end

	make_from_ephemeral_port (a_protocol: STRING)
			-- Initialize service, but let kernel choose a port at bind time.
			-- Provide a `a_protocol' if necessary.
		do
			port := 0
			create name.make_empty
			protocol := a_protocol
			guess_protocol_type
			create aliases.make_empty
		end

	make_from_port (a_port: INTEGER; a_protocol: detachable STRING)
			-- Initialize service from given a_port.
			-- Make sure to provide a `a_protocol' if necessary!
		require
			valid_port: a_port >= 0 and a_port <= 65535
		local
			nport: INTEGER
			p: POINTER
		do
			nport := abstract_api.posix_htons (a_port)
			p := abstract_getservbyport (nport, sh.string_to_pointer (a_protocol))
			sh.unfreeze_all
			set_members_from_struct (p, a_port, a_protocol)
		end


feature -- Access

	port: INTEGER
			-- port number if not zero

	name: STRING
			-- official service name

	aliases: ARRAY [STRING]
			-- alias list

	protocol: STRING
			-- protocol to use (udp/tcp)

	protocol_type: INTEGER
			-- SOCK_STREAM or SOCK_DGRAM


feature -- Status

	is_tcp: BOOLEAN
			-- Is `protocol_type' the tcp protocl?
		do
			Result := protocol_type = SOCK_STREAM
		ensure
			definition: protocol_type = SOCK_STREAM
		end

	is_udp: BOOLEAN
			-- Is `protocol_type' the datagram protocl?
		do
			Result := protocol_type = SOCK_DGRAM
		ensure
			definition: protocol_type = SOCK_DGRAM
		end


feature {NONE} -- Implementation

	guess_protocol_type
			-- Guess value for `protocol_type' based on `protocol'.
		do
			if protocol /= Void then
				protocol.to_lower
				if protocol.is_equal (once_tcp) then
					protocol_type := SOCK_STREAM
				elseif protocol.is_equal (once_udp) then
					protocol_type := SOCK_DGRAM
				else
					-- guess?, raise error?
					protocol_type := SOCK_STREAM
				end
			else
				-- just give it a value, or perhaps invent a NULL value
				-- for `protocol_type', perhaps better.
				protocol_type := SOCK_STREAM
			end
		end

	set_members_from_struct (p: POINTER; a_port: INTEGER; a_protocol: detachable STRING)
			-- Initialize attributes of object from struct in `p'. If p =
			-- default_pointer we assume service does not exist in
			-- /etc/services and give some dummy values.
		require
			valid_port: a_port >= 0 and a_port <= 65535
		do
			if p = default_pointer then
				-- not found, guess?
				port := a_port
				name := "unknown"
				if attached a_protocol then
					protocol := a_protocol
				else
					create protocol.make_empty
				end
				create aliases.make_empty
			else
				port := abstract_api.posix_ntohs (abstract_api.posix_servent_s_port (p))
				name := sh.pointer_to_string (abstract_api.posix_servent_s_name (p))
				protocol := sh.pointer_to_string (abstract_api.posix_servent_s_proto (p))
				aliases := ah.pointer_to_string_array (abstract_api.posix_servent_s_aliases (p))
			end
			guess_protocol_type
		end


feature {NONE} -- Abstract API

	abstract_getservbyname (a_name, a_proto: POINTER): POINTER
			-- Lookup service given its name and optional protocol.
		require
			valid_name: a_name /= default_pointer
		deferred
		end

	abstract_getservbyport (a_port: INTEGER; a_proto: POINTER): POINTER
			-- Lookup service given its port number and optional protocol.
		require
			valid_port: a_port >= 0
		deferred
		end


feature {NONE} -- Once strings

	once_tcp: STRING = "tcp"
	once_udp: STRING = "udp"


invariant

	name_void_or_not_empty: name = Void or else not name.is_empty
	valid_port: port >= 0 and port <= 65535
	valid_protocol:
		protocol.is_empty or else
		protocol ~ once_tcp or else protocol ~ once_udp
	valid_protocol_type:
		protocol_type = SOCK_STREAM or else
		protocol_type = SOCK_DGRAM
	valid_aliases: attached aliases

end
