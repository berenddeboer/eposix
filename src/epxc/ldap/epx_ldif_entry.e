indexing

	description:

		"A complete LDIF entry (changetype: add)"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_LDIF_ENTRY


create

	make_from_linkables


feature {NONE} -- Initialisation

	make_from_linkables (a_distinguished_name: STRING; a_controls: ANY; an_attributes: DS_LINKABLE [EPX_LDIF_ATTRIBUTE]) is
			-- Initialise by putting the values of multiple valued
			-- attributes into a single EPX_LDIF_ATTRIBUTE class.
		require
			distinguished_name_not_empty: a_distinguished_name /= Void and then not a_distinguished_name.is_empty
		local
			p: DS_LINKABLE [EPX_LDIF_ATTRIBUTE]
		do
			distinguished_name := a_distinguished_name
			create attributes.make (64)
			-- Loop through attributes and reduce same names to a
			-- multiple value attribute.
			from
				p := an_attributes
			invariant
				p = Void or else p.item.values.count = 1
			until
				p = Void
			loop
				attributes.search (p.item.name)
				if attributes.found then
					attributes.found_item.add_value (p.item.values.first)
				else
					attributes.force (p.item, p.item.name)
				end
				p := p.right
			end
		end


feature -- Access

	distinguished_name: STRING
			-- Entry's DN

	attributes: DS_HASH_TABLE [EPX_LDIF_ATTRIBUTE, STRING]


feature -- Change

	add_value (an_attribute_name, a_value: STRING) is
		require
			an_attribute_name_not_empty: an_attribute_name /= Void and then not an_attribute_name.is_empty
		local
			my_attribute: EPX_LDIF_ATTRIBUTE
		do
			attributes.search (an_attribute_name)
			if attributes.found then
				attributes.found_item.add_value (a_value)
			else
				create my_attribute.make (an_attribute_name, Void, a_value)
				attributes.force (my_attribute, my_attribute.name)
			end
		ensure
			has_attribute: attributes.has (an_attribute_name)
		end


invariant

	distinguished_name_not_empty: distinguished_name /= Void and then not distinguished_name.is_empty
	attributes_not_void: attributes /= Void

end
