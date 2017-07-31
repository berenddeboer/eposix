note

	description:

		"External URI resolver for the http protocol"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2007, Berend de Boer"
	license: "MIT License"

class

	EPX_HTTPS_URI_RESOLVER

inherit

	EPX_HTTP_URI_RESOLVER
		redefine
			default_port,
			scheme
		end

create

	make

feature -- Operation(s)

	default_port: INTEGER = 443

	scheme: STRING = "https"


end
