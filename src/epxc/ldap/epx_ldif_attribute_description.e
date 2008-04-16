indexing

	description:

		"Attribute Description in an LDIF file"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2006/04/14 $"
	revision: "$Revision: #1 $"


class

	EPX_LDIF_ATTRIBUTE_DESCRIPTION


creation

	make


feature {NONE} -- Initialisation

	make (an_attribute_type: STRING; an_options: DS_LINKABLE [STRING]) is
		require
			attribute_type_not_empty: an_attribute_type /= Void and then not an_attribute_type.is_empty
		do
			attribute_type := an_attribute_type
			options := an_options
		end


feature -- Access

	attribute_type: STRING
			-- Attribute type, either an oid or a string

	options: DS_LINKABLE [STRING]
			-- Optional options


invariant

	attribute_type_not_empty: attribute_type /= Void and then not attribute_type.is_empty

end
