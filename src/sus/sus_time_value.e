indexing

	description: "SUSv3 enhancements on the timeval structure."

	author: "Berend de Boer"
	date: "$Date: 2004/12/18 $"
	revision: "$Revision: #2 $"


class

	SUS_TIME_VALUE


inherit

	SUS_BASE

	EPX_TIME_VALUE

	SAPI_TIME
		export
			{NONE} all
		end


creation

	make,
	make_from_now


feature -- Initialization

	make_from_now is
			-- Set time to current time.
		do
			make
			safe_call (posix_gettimeofday (tp.ptr))
		end


end
