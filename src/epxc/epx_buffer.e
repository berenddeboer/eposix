indexing

	description: "Standard C linear piece of memory, starting with index 0. Memory is dynamically allocated. Size should be at least 1 byte%
	%large. 0 size memory is not supported."


	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2011, Berend de Boer"
	license: "MIT License (see LICENSE)"


class

	EPX_BUFFER

inherit

	STDC_BUFFER

create

	allocate,
	allocate_and_clear,
	make_from_pointer

end
