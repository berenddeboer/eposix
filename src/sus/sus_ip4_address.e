indexing

	description: "SUSv3 IPv4 address."

	author: "Berend de Boer"
	date: "$Date: 2004/12/18 $"
	revision: "$Revision: #4 $"


class

	SUS_IP4_ADDRESS


inherit

	SUS_IP_ADDRESS
		undefine
			is_equal,
			out
		end

	EPX_IP4_ADDRESS


creation

	make_from_integer,
	make_from_pointer


end
