indexing

	description: "Abstract base class for classes that use the IP sockets layer."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	ABSTRACT_NET_BASE


inherit

	STDC_BASE

	EPX_NET_CONSTANTS
		export
			{NONE} all
		end


feature {NONE} -- Abstract API

	abstract_api: EPX_NET_API is
			-- Access to API available at abstract level.
			-- Use client relation so only exported features are visible
			-- and we don't make a mistake in accessing something that is
			-- not portable.
		once
			create Result
		end

end
