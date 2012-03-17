note

	description:

		"Short description of the class"

	library: "epsix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2012, Berend de Boer"
	license: "MIT License (see LICENSE)"

class

	EPX_WGI_FASTCGI_CONNECTOR_OPTIONS


feature -- Access

	options_template: TUPLE [
		port: INTEGER
		bind: STRING
		terminate_signal: EPX_KILL_SIGNAL_HANDLER
	]

end
