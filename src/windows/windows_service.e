indexing

	description: "Windows implementation of a service name."

	author: "Berend de Boer"
	date: "$Date: 2006/04/14 $"
	revision: "$Revision: #2 $"


class

	WINDOWS_SERVICE


inherit

	WINDOWS_BASE

	EPX_SERVICE
		undefine
			raise_posix_error
		end


creation

	make_from_name,
	make_from_port

end
