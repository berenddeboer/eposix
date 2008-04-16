indexing

	description: "Windows network specific constants portable at the ABSTRACT_XXXX layer."

	author: "Berend de Boer"
	date: "$Date: 2003/05/08 $"
	revision: "$Revision: #2 $"


class

	EPX_NET_CONSTANTS


inherit

	WINDOWS_CONSTANTS
		export
			{NONE} all;
			{ANY}
				AF_INET,
				AF_INET6,
				AF_UNSPEC,
				INADDR_ANY,
				INADDR_LOOPBACK,
				INADDR_BROADCAST,
				INET_ADDRSTRLEN,
				INET6_ADDRSTRLEN,
				SOL_SOCKET,
				SO_REUSEADDR
		end


end
