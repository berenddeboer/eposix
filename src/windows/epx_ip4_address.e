indexing

	description: "Windows implementation of a portable IPv4 address."

	author: "Berend de Boer"
	date: "$Date: 2004/12/18 $"
	revision: "$Revision: #4 $"


class

	EPX_IP4_ADDRESS


inherit

	ABSTRACT_IP4_ADDRESS


creation

	make_from_any,
	make_from_integer,
	make_from_components,
	make_from_loopback,
	make_from_pointer

end
