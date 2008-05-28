indexing

	description: "SUSv3 implementation of a portable IPv4 address."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


class

	EPX_IP4_ADDRESS


inherit

	ABSTRACT_IP4_ADDRESS


create

	make_from_any,
	make_from_integer,
	make_from_components,
	make_from_loopback,
	make_from_pointer

end
