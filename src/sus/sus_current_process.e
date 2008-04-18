indexing

	description:

		"Single Unix Specification access to current process"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

class

	SUS_CURRENT_PROCESS

inherit

	SUS_BASE

	POSIX_CURRENT_PROCESS

	SAPI_TIME
		export
			{NONE} all
		end

feature -- Sleeping

	nanosleep (a_nanoseconds: SUS_TIME) is
			-- Sleep for `a_nanoseconds' nanoseconds or until a signal is
			-- delivered, and its action is to invoke a signal-catching
			-- function or to terminate the process.
			-- The suspension time may be longer than requested because
			-- the argument value is rounded up to an integer multiple of
			-- the sleep resolution or because of the scheduling of other
			-- activity by the system.
		require
			nanoseconds_not_void: a_nanoseconds /= Void
		local
			rmtp: STDC_BUFFER
			r: INTEGER
		do
			posix_set_timespec_tv_sec (rqtp.ptr, a_nanoseconds.value)
			posix_set_timespec_tv_nsec (rqtp.ptr, a_nanoseconds.nano_value)
			create rmtp.allocate_and_clear (posix_timespec_size)
			r := posix_nanosleep (rqtp.ptr, rmtp.ptr)
			if r = -1 then
				-- Assume interrupted, and no error
				create unslept_nanoseconds.make_from_nano_time (posix_timespec_tv_sec (rmtp.ptr), posix_timespec_tv_nsec (rmtp.ptr))
			end
		ensure
			unslept_less_than_nanoseconds:
				unslept_nanoseconds /= Void implies
					unslept_nanoseconds <= a_nanoseconds
		end

	unslept_nanoseconds: SUS_TIME
			-- The number of nanoseconds still to sleep, before being
			-- interrupted; it is set by `nanosleep'. If it is Void, no
			-- interrupt occurred and process slept for the allotted
			-- time.


feature {NONE} -- Implementation

	rqtp: STDC_BUFFER is
			-- Scratch buffer for `nanosleep'
		once
			create Result.allocate_and_clear (posix_timespec_size)
		ensure
			rqtp_not_void: Result /= Void
			rqtp_has_enough_capacity: Result.capacity = posix_timespec_size
		end

end
