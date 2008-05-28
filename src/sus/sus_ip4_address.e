indexing

	description: "SUSv3 IPv4 address."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


class

	SUS_IP4_ADDRESS


inherit

	SUS_IP_ADDRESS
		undefine
			is_equal,
			out
		end

	EPX_IP4_ADDRESS


create

	make_from_integer,
	make_from_pointer


end
