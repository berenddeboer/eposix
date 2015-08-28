note

	description:

		"Short description of the class"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2015, Berend de Boer"
	license: "MIT License (see LICENSE)"


class

	EPX_FASTCGI_EXECUTION


inherit

	WSF_ROUTED_SKELETON_EXECUTION
		undefine
			requires_proxy
		redefine
			initialize
		end

	WSF_ROUTED_URI_TEMPLATE_HELPER

	WSF_HANDLER_HELPER

	WSF_NO_PROXY_POLICY


create

	make


feature {NONE} -- Initialization

	initialize
		do
			Precursor
			initialize_router
		end

	setup_router
		do
			-- TODO
		end


end
