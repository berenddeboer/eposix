note

	description:

		"WSF_REQUEST but with eposix MIME handling"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2012, Berend de Boer"
	license: "MIT License (see LICENSE)"


class

	EPX_WSF_REQUEST


inherit

	WSF_REQUEST
		redefine
			init_mime_handlers
		end


create {WSF_SERVICE}

	make_from_wgi


feature {NONE} -- Implementation: MIME handler

	init_mime_handlers
		do
			register_mime_handler (create {EPX_WSF_MULTIPART_FORM_DATA_HANDLER})
			register_mime_handler (create {WSF_APPLICATION_X_WWW_FORM_URLENCODED_HANDLER})
		end

end
