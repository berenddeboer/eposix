indexing

	description: "Socket address created from a resolved SUS_HOST and SUS_SERVICE. Depending on the addres_family, makes a sockaddr_in or sockaddr_in6 available in `socket_address'."

	author: "Berend de Boer"
	date: "$Date: 2003/03/20 $"
	revision: "$Revision: #4 $"


class

	SUS_SOCKET_ADDRESS


obsolete

		"Use EPX_HOST_PORT instead."

inherit

	EPX_HOST_PORT


creation

	make


end
