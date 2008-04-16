indexing

	description: "Class that describes a host on the network."

	author: "Berend de Boer"
	date: "$Date: 2006/04/14 $"
	revision: "$Revision: #2 $"


class

	WINDOWS_HOST


inherit

	WINDOWS_BASE

	EPX_HOST
		undefine
			raise_posix_error
		end


creation

	make_from_name,
	make_from_address

end
