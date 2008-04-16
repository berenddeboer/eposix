indexing

	description: "SUSv3 IPv6 address."

	author: "Berend de Boer"
	date: "$Date: 2004/12/18 $"
	revision: "$Revision: #2 $"


class

	SUS_IP6_ADDRESS


inherit

	SUS_IP_ADDRESS
		undefine
			is_equal,
			out
		end

	EPX_IP6_ADDRESS


creation

	make_from_pointer


end
