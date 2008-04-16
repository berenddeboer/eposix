indexing

	description:

		"Last-Modified field"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2007, Berend de Boer"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_MIME_FIELD_LAST_MODIFIED


inherit

	EPX_MIME_FIELD_A_DATE


creation

	make


feature -- Access

	name: STRING is "Last-Modified"


end
