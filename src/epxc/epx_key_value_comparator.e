note

	description:

		"Use to sort EPX_KEY_VALUE when used in a DS_SORTABLE"

	library: "eposxix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2012, Berend de Boer"
	license: "MIT License (see LICENSE)"


class

	EPX_KEY_VALUE_COMPARATOR


inherit

	KL_PART_COMPARATOR [EPX_KEY_VALUE]


feature -- Status report

	less_than (u, v: EPX_KEY_VALUE): BOOLEAN
			-- Is `u' considered less than `v'?
		do
			Result := u.key < v.key
		end


end
