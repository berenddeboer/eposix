indexing

	description: "Class that covers Windows stat structure."

	author: "Berend de Boer"
	date: "$Date: 2006/04/14 $"
	revision: "$Revision: #3 $"

deferred class

	WINDOWS_STATUS


inherit

	EPX_STATUS
		undefine
			raise_posix_error
		end

	WINDOWS_BASE


end
