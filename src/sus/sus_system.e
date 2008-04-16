indexing

	description: "Class that covers Single Unix Spec current system %
	%info related routines."

	usage: "Just inherit from this class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

class

	SUS_SYSTEM


inherit

	POSIX_SYSTEM

	SUS_BASE

	SAPI_UNISTD
		export
			{NONE} all
		end

	SAPI_TIME
		export
			{NONE} all
		end


feature -- Network related

	host_name: STRING is
			-- The standard host name for the current machine
		local
			buf: POSIX_BUFFER
		do
			create buf.allocate (255)
			safe_call (posix_gethostname (buf.ptr, 255))
			Result := sh.pointer_to_string (buf.ptr)
		end

feature -- Clocks

	have_realtime_clock: BOOLEAN is
			-- Does the current system have a real-time clock?
		do
			Result := posix_have_realtime_clock
		end

	real_time_clock_resolution: SUS_TIME is
			-- NEW object indicating the resolution of the real time clock;
			-- On POSIX compliant systems the resolution is 1,000,000,000
			-- nanoseconds.
		require
			have_realtime_clock: have_realtime_clock
		local
			tp: STDC_BUFFER
		do
			create tp.allocate_and_clear (posix_timespec_size)
			safe_call (posix_clock_getres (CLOCK_REALTIME, tp.ptr))
			create Result.make_from_nano_time (posix_timespec_tv_sec (tp.ptr), posix_timespec_tv_nsec (tp.ptr))
		ensure
			resolution_not_void: Result /= Void
		end

	real_time_clock: SUS_TIME is
			-- NEW object indicating the current system time down to a
			-- resolution of one nanosecond
		require
			have_realtime_clock: have_realtime_clock
		do
			create Result.make_from_now
		ensure
			time_not_void: Result /= Void
		end

end
