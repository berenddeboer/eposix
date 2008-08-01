indexing

	description: "Class that covers Standard C time.h."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	CAPI_TIME


feature -- Standard C binding

	posix_asctime (a_tm: POINTER): POINTER is
			-- Converts a time structure to a string.
		require
			tm_not_nil: a_tm /= default_pointer
		external "C"
		end

	posix_clock: INTEGER is
			-- An approximation of processor time used by the program
		external "C"
		end

	posix_difftime (time_end, time_start: INTEGER): DOUBLE is
			-- Computes the difference between two times in seconds.
		external "C"
		end

	posix_gmtime (time: INTEGER): POINTER is
			-- Breaks down a timer value into a time structure in
			-- Coordinated Universal Time (UTC).
		require
			time_not_negative: time >= 0
		external "C"
		end

	posix_localtime (time: INTEGER): POINTER is
			-- Converts the calendar time into a broken-time
			-- representation, expressed relative to the user's specified
			-- time zone.
			-- The function sets the external variables tzname with
			-- information about the current time zone, timezone with the
			-- difference between Coordinated Universal Time (UTC) and
			-- local standard time in seconds, and daylight to a non-zero
			-- value if standard US daylight savings time rules apply.
		require
			time_not_negative: time >= 0
		external "C"
		end

	posix_mktime (a_tm: POINTER): INTEGER is
			-- Converts time formats.
		external "C"
		end

	posix_strftime (s: POINTER; maxsize: INTEGER; a_format: POINTER a_tm: POINTER): INTEGER is
			-- Converts a time structure to a string.
		external "C"
		end

	posix_time: INTEGER is
			-- The current calendar time in seconds since the epoch
		external "C"
		end


feature -- struct tm

	posix_tm_size: INTEGER is
			-- Size of a tm struct
		external "C"
		end

	posix_tm_hour (a_tm: POINTER): INTEGER is
			-- Hours after midnight
		external "C"
		end

	posix_tm_mday (a_tm: POINTER): INTEGER is
			-- Day of the month
		external "C"
		end

	posix_tm_min (a_tm: POINTER): INTEGER is
			-- Minutes after the hour
		external "C"
		end

	posix_tm_mon (a_tm: POINTER): INTEGER is
			-- Months since January
		external "C"
		end

	posix_tm_sec (a_tm: POINTER): INTEGER is
			-- Seconds after the minute
		external "C"
		end

	posix_tm_wday (a_tm: POINTER): INTEGER is
			-- Days since Sunday
		external "C"
		end

	posix_tm_yday (a_tm: POINTER): INTEGER is
			-- Days since January 1st
		external "C"
		end

	posix_tm_year (a_tm: POINTER): INTEGER is
			-- Years since 1900
		external "C"
		end

	posix_tm_isdst (a_tm: POINTER): INTEGER is
			-- Positive: Daylight savings.
			-- Zero: Standard time.
			-- Negative: Unknown.
		external "C"
		end

	posix_set_tm_date (a_tm: POINTER; a_year, a_mon, a_mday: INTEGER) is
			-- Sets date part of tm struct.
		external "C"
		end

	posix_set_tm_isdst (a_tm: POINTER; a_isdst: INTEGER) is
			-- Set daylight saving time in effect or not.
		external "C"
		end

	posix_set_tm_time (a_tm: POINTER; a_hour, a_min, a_sec: INTEGER) is
			-- Sets time part of tm struct.
		external "C"
		end


end
