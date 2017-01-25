note

	description: "Class that covers the Single Unix Spec sys/time.h header."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	SAPI_TIME


feature -- Time functions

	posix_clock_getres (a_clock_id: INTEGER; a_res: POINTER): INTEGER
			-- Resolution of clock `a_clock_id'; clock resolutions are
			-- implementation-defined and cannot be set by a process.
		external "C"
		end

	posix_clock_gettime (a_clock_id: INTEGER; a_tp: POINTER): INTEGER
			-- Current value `a_tp' for the specified clock `a_clock_id'.
		require
			a_tp_not_nil: a_tp /= default_pointer
		external "C"
		end

	posix_clock_settime (a_clock_id: INTEGER; a_tp: POINTER): INTEGER
			-- Set the specified clock `a_clock_id' to the value
			-- specified by `a_tp'. Time values that are between two
			-- consecutive non-negative integer multiples of the
			-- resolution of the specified clock shall be truncated down
			-- to the smaller multiple of the resolution.
		require
			a_tp_not_nil: a_tp /= default_pointer
		external "C"
		end

	posix_gettimeofday (a_timeval: POINTER): INTEGER
			-- obtains the current time, expressed as seconds and
			-- microseconds since 00:00 Coordinated Universal Time (UTC),
			-- January 1, 1970, and stores it in `a_timeval'.
		require
			have_timeval: a_timeval /= default_pointer
		external "C"
		end

	posix_nanosleep (a_rqtp, a_rmtp: POINTER): INTEGER
			-- The nanosleep() function shall cause the current thread to
			-- be suspended from execution until either the time interval
			-- specified by the rqtp argument has elapsed or a signal is
			-- delivered to the calling thread, and its action is to
			-- invoke a signal-catching function or to terminate the
			-- process. The suspension time may be longer than requested
			-- because the argument value is rounded up to an integer
			-- multiple of the sleep resolution or because of the
			-- scheduling of other activity by the system. But, except
			-- for the case of being interrupted by a signal, the
			-- suspension time shall not be less than the time specified
			-- by rqtp, as measured by the system clock CLOCK_REALTIME.
		require
			nanoseconds_not_nil: a_rqtp /= default_pointer
		external "C"
		end


feature -- Helpers

	posix_have_realtime_clock: BOOLEAN
			-- Does this system define the REALTIME_CLOCK?
			-- It is used to check if the functions `posix_clock_getres'
			-- and `posix_clock_gettime' and such work.
		external "C"
		end


feature -- C binding for members of timeval

	posix_timeval_size: INTEGER
		external "C"
		ensure
			valid_size: Result > 0
		end

	posix_timeval_tv_sec (a_timeval: POINTER): INTEGER
			-- seconds
		require
			have_struct_pointer: a_timeval /= default_pointer
		external "C"
		end

	posix_timeval_tv_usec (a_timeval: POINTER): INTEGER
			-- microseconds
		require
			have_struct_pointer: a_timeval /= default_pointer
		external "C"
		end

	posix_set_timeval_tv_sec (a_timeval: POINTER; tv_sec: INTEGER)
		require
			have_struct_pointer: a_timeval /= default_pointer
		external "C"
		end

	posix_set_timeval_tv_usec (a_timeval: POINTER; tv_usec: INTEGER)
		require
			have_struct_pointer: a_timeval /= default_pointer
		external "C"
		end


feature -- C binding for members of timespec

	posix_timespec_size: INTEGER
		external "C"
		ensure
			valid_size: Result > 0
		end

	posix_timespec_tv_sec (a_timespec: POINTER): INTEGER
		require
			have_struct_pointer: a_timespec /= default_pointer
		external "C"
		end

	posix_timespec_tv_nsec (a_timespec: POINTER): INTEGER
		require
			have_struct_pointer: a_timespec /= default_pointer
		external "C"
		end

	posix_set_timespec_tv_sec (a_timespec: POINTER; tv_sec: INTEGER)
		require
			have_struct_pointer: a_timespec /= default_pointer
		external "C"
		end

	posix_set_timespec_tv_nsec (a_timespec: POINTER; tv_nsec: INTEGER)
		require
			have_struct_pointer: a_timespec /= default_pointer
		external "C"
		end

end
