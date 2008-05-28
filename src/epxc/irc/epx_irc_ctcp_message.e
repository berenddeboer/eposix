indexing

	description:

		"CTCP extended message"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_IRC_CTCP_MESSAGE


inherit

	ANY

	EPX_IRC_CTCP_ENCODING
		export
			{NONE} all
		end


create

	make


feature {NONE} -- Initialisation

	make (a_tag: STRING) is
		require
			tag_valid: is_valid_ctcp_tag (a_tag)
		do
			tag := a_tag
			create {DS_LINKED_LIST [STRING]} parameters.make
		end


feature -- Access

	parameters: DS_LIST [STRING]
			-- Optional parameters

	tag: STRING
			-- CTCP tag


invariant

	parameters_not_void: parameters /= Void
	tag_valid: is_valid_ctcp_tag (tag)

end
