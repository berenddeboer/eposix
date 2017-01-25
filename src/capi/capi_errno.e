note

	description: "Class that covers Standard C errno.h."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

class

	CAPI_ERRNO


feature -- Standard C api calls

	posix_clear_errno
			-- reset `errno'
		external "C"
		end

	posix_errno: INTEGER
			-- POSIX errno
		external "C"
		end

	posix_set_errno (new_value: INTEGER)
			-- set `errno' to `new_value'
		external "C"
		end

end
