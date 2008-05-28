indexing

	description: "Class that describes a host on the network."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	WINDOWS_HOST


inherit

	WINDOWS_BASE

	EPX_HOST
		undefine
			raise_posix_error
		end


create

	make_from_name,
	make_from_address

end
