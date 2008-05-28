indexing

	description: "SUSv3 IPv6 address."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	SUS_IP6_ADDRESS


inherit

	SUS_IP_ADDRESS
		undefine
			is_equal,
			out
		end

	EPX_IP6_ADDRESS


create

	make_from_pointer


end
