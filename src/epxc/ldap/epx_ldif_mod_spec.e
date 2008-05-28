indexing

	description:

		"Modification specification for changetype: modify"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_LDIF_MOD_SPEC


create

	make


feature {NONE} -- Initialisation

	make (a_mod_spec: INTEGER; an_attribute_description: EPX_LDIF_ATTRIBUTE_DESCRIPTION; an_attributes: DS_LINKABLE [EPX_LDIF_ATTRIBUTE]) is
		require
			valid_mod_spec: is_valid_mod_spec (a_mod_spec)
			attribute_description_not_void: an_attribute_description /= Void
		do
			mod_spec := a_mod_spec
			attribute_description := an_attribute_description
			attributes := an_attributes
		end


feature -- Access

	attribute_description: EPX_LDIF_ATTRIBUTE_DESCRIPTION

	attributes: DS_LINKABLE [EPX_LDIF_ATTRIBUTE]
			-- An attribute can have multiple values, constrained by the
			-- schema in use

	mod_spec: INTEGER
			-- Add, delete or replace


feature -- Status

	is_valid_mod_spec (a_mod_spec: INTEGER): BOOLEAN is
			-- Is `a_mod_spec' an add, delete or replace mod spec?
		do
			Result :=
				a_mod_spec >= MOD_SPEC_ADD and then
				a_mod_spec <= MOD_SPEC_REPLACE
		end


feature -- Modification spec

	MOD_SPEC_ADD: INTEGER is 1
	MOD_SPEC_DELETE: INTEGER is 2
	MOD_SPEC_REPLACE: INTEGER is 3


invariant

	attribute_description_not_void: attribute_description /= Void
	valid_mod_spec: is_valid_mod_spec (mod_spec)

end
