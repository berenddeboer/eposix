note

	description: "Class that covers the timeval structure such that it is portable between Unix and Windows."

	author: "Berend de Boer"


class

	EPX_TIME_VALUE


inherit

	ABSTRACT_NET_BASE


create

	make


feature {NONE} -- Initialization

	make
			-- Initialize to zero.
		do
			create tp.allocate_and_clear (abstract_api.posix_timeval_size)
		end


feature -- Access

	handle: POINTER
			-- Raw pointer to the timeval structure
		do
			Result := tp.handle
		ensure
			handle_not_nil: Result /= default_pointer
		end

	microseconds: INTEGER
			-- Microseconds elapsed since `seconds'
		do
			Result := abstract_api.posix_timeval_tv_usec (tp.ptr)
		ensure
			in_range: Result >= 0 and Result <= 999999
		end

	seconds: INTEGER
			-- Seconds since 0:00, 1970 UTC
		do
			Result := abstract_api.posix_timeval_tv_sec (tp.ptr)
		ensure
			positive: Result >= 0
		end


feature -- Change

	set_microseconds (a_microseconds: INTEGER)
		require
			valid_microseconds: a_microseconds >= 0 and then a_microseconds <= 999999
		do
			abstract_api.posix_set_timeval_tv_usec (tp.ptr, a_microseconds)
		end

	set_seconds (a_seconds: INTEGER)
		require
			valid_seconds: seconds >= 0
		do
			abstract_api.posix_set_timeval_tv_sec (tp.ptr, a_seconds)
		end


feature {NONE} -- Implementation

	tp: STDC_BUFFER
			-- Pointer to the timevalue structure


invariant

	have_tp: tp /= Void and then tp.capacity = abstract_api.posix_timeval_size
	seconds_positive: seconds >= 0
	microseconds_valid: microseconds >= 0 and microseconds <= 999999

end
