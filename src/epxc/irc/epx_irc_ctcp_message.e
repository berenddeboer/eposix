indexing

	description:

		"CTCP extended message"

	library: "eposix"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/03/03 $"
	revision: "$Revision: #1 $"


class

	EPX_IRC_CTCP_MESSAGE


inherit

	ANY

	EPX_IRC_CTCP_ENCODING
		export
			{NONE} all
		end


creation

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
