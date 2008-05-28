indexing

	description:

		"External URI resolver for the http protocol"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2007, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

class

	EPX_HTTPS_URI_RESOLVER

inherit

	EPX_HTTP_URI_RESOLVER
		redefine
			default_port,
			scheme,
			new_client
		end

create

	make

feature -- Operation(s)

	default_port: INTEGER is 443

	scheme: STRING is "https"

feature {NONE} -- Implementation

	new_client (a_uri_to_use: UT_URI): EPX_HTTP_11_CLIENT is
		do
			if a_uri_to_use.port = 0 then
				create Result.make_secure (a_uri_to_use.host)
			else
				create Result.make_secure_with_port (a_uri_to_use.host, a_uri_to_use.port)
			end
		end

end
