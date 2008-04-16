indexing

	description: "Class that covers Windows <limits.h>."

	author: "Berend de Boer"
	date: "$Date: 2003/01/09 $"
	revision: "$Revision: #1 $"

class

	WAPI_LIMITS


feature {NONE} -- C binding for constants

	ARG_MAX: INTEGER is
		external "C"
		alias "const_arg_max"
		end

	OPEN_MAX: INTEGER is
		external "C"
		alias "const_open_max"
		end

	STREAM_MAX: INTEGER is
		external "C"
		alias "const_stream_max"
		end

	TZNAME_MAX: INTEGER is
		external "C"
		alias "const_tzname_max"
		end

end
