indexing

	description: "Field If-Modified-Since"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_MIME_FIELD_IF_MODIFIED_SINCE


inherit

	EPX_MIME_FIELD_A_DATE


create

	make


feature -- Access

	name: STRING is "If-Modified-Since"


end
