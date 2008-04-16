indexing

	description: "Class that covers Windows stat structure."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	WINDOWS_STATUS


inherit

	EPX_STATUS
		undefine
			raise_posix_error
		end

	WINDOWS_BASE


end
