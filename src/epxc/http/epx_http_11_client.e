indexing

	description: "Class that implements whatever an HTTP 1.1 client can do."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	EPX_HTTP_11_CLIENT


inherit

	EPX_HTTP_10_CLIENT
		redefine
			client_version
		end


create

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


feature -- Change

	set_reuse_connection is
			-- Reuse HTTP connection more than 1 request.
		do
			reuse_connection := True
		ensure
			reusing: reuse_connection
		end


end
