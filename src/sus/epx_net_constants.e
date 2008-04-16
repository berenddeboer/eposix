indexing

	description: "SUSv3 specific network constants portable at the ABSTRACT_XXXX layer."

	author: "Berend de Boer"
	date: "$Date: 2004/12/18 $"
	revision: "$Revision: #2 $"


class

	EPX_NET_CONSTANTS


inherit

	ANY

	SUS_CONSTANTS
		export
			{NONE} all;
			{ANY}
				AF_INET,
				AF_INET6,
				AF_UNSPEC,
				INET_ADDRSTRLEN,
				INET6_ADDRSTRLEN,
				SOL_SOCKET,
				SO_REUSEADDR,
				IPPROTO_TCP
		end

end
