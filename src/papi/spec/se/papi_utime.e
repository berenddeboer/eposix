indexing

	description: "Class that covers POSIX utime.h."

	author: "Berend de Boer"
	date: "$Date: 2007/05/18 $"
	revision: "$Revision: #1 $"

class

	PAPI_UTIME


feature {NONE}

	posix_utime (path: POINTER; actime, modtime: INTEGER): INTEGER is
			-- Sets file access and modification times
			-- If actime = -1, sets to current time



		external "C"

		end


end -- class PAPI_UTIME
