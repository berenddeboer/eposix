note

	description: "SUSv3 portable implementation of a service name."

	author: "Berend de Boer"


class

	EPX_SERVICE


inherit

	ABSTRACT_SERVICE

	SAPI_NETDB
		export
			{NONE} all
		end


create

	make_from_name,
	make_from_name_with_default,
	make_from_ephemeral_port,
	make_from_port


feature {NONE} -- Abstract API

	abstract_getservbyname (a_name, a_proto: POINTER): POINTER
			-- Lookup service given its name and optional protocol.
		do
			Result := posix_getservbyname (a_name, a_proto)
		end

	abstract_getservbyport (a_port: INTEGER; a_proto: POINTER): POINTER
			-- Lookup service given its port number and optional protocol.
		do
			Result := posix_getservbyport (a_port, a_proto)
		end

end
