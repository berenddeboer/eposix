note

	description: "SUSv3 specific network constants portable at the ABSTRACT_XXXX layer."

	author: "Berend de Boer"


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
				IPPROTO_IP,
				IPPROTO_TCP,
				IPTOS_LOWDELAY
		end

end
