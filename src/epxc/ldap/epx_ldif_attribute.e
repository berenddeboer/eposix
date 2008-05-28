indexing

	description:

		"Single attribute in LDIF file"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_LDIF_ATTRIBUTE


create

	make


feature {NONE} -- Initialisation

	make (a_name: STRING; an_options: DS_LINKABLE [STRING]; a_value: STRING) is
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			name := a_name
			options := an_options
			create values.make
			values.put_last (a_value)
		end


feature -- Access

	name: STRING
			-- Attribute type, either an oid or a string

	options: DS_LINKABLE [STRING]
			-- Optional options

	values: DS_LINKED_LIST [STRING]
			-- An attribute can have multiple values, constrained by the
			-- schema in use


feature -- Change

	add_value (a_value: STRING) is
		do
			values.put_last (a_value)
		end


invariant

	name_not_empty: name /= Void and then not name.is_empty
	values_not_void: values /= Void

end
