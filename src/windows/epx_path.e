indexing

	description:

		"As STDC_PATH"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2012, Berend de Boer"
	license: "MIT License (see LICENSE)"


class

	EPX_PATH


inherit

	STDC_PATH


create

	copy, -- needed for SE, might not work for other compilers
	make,
	make_from_string,
	make_expand

end
