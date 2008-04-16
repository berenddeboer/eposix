indexing

	description: "Class that covers Standard C errno.h."

	author: "Berend de Boer"
	date: "$Date: 2003/01/09 $"
	revision: "$Revision: #3 $"

class

	CAPI_ERRNO


feature -- Standard C api calls

	posix_clear_errno is
			-- reset `errno'
		external "C"
		end

	posix_errno: INTEGER is
			-- POSIX errno
		external "C"
		end

	posix_set_errno (new_value: INTEGER) is
			-- set `errno' to `new_value'
		external "C"
		end

end
