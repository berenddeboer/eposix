indexing

	description:

		"ETag field"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2007, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_MIME_FIELD_ETAG


inherit

	EPX_MIME_STRUCTURED_FIELD


create

	make


feature -- Initialization

	make (an_entity_tag: STRING) is
		require
			an_entity_tag_not_empty: an_entity_tag /= Void and then not an_entity_tag.is_empty
		do
			value := an_entity_tag
		end

	
feature -- Access

	name: STRING is "ETag"

	value: STRING	

end
