indexing

	description: "Windows implementation of a service name."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	WINDOWS_SERVICE


inherit

	WINDOWS_BASE

	EPX_SERVICE
		undefine
			raise_posix_error
		end


create

	make_from_name,
	make_from_port

end
