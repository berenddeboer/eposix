indexing

	description: "Class that implements whatever an HTTP 1.1 client can do."

	author: "Berend de Boer"
	date: "$Date: 2007/01/25 $"
	revision: "$Revision: #3 $"


class

	EPX_HTTP_11_CLIENT


inherit

	EPX_HTTP_10_CLIENT
		redefine
			client_version
		end


creation

	make,
	make_from_port,
	make_with_port,
	make_from_host,
	make_from_host_and_port,
	make_secure,
	make_secure_with_port


feature -- Client http version

	client_version: STRING is
		once
			Result := "HTTP/1.1"
		end


end
