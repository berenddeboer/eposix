indexing

	description:

		"As STDC_TIME, but resolution is one nano second on SUSv3 compliant systems"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	SUS_TIME


inherit

	SUS_BASE
		redefine
			is_equal
		end

	STDC_TIME
		redefine
			infix "<",
			infix "-",
			is_equal,
			make_from_now,
			make_from_unix_time
		end

	SAPI_TIME
		export
			{NONE} all
		redefine
			is_equal
		end


create

	make_date,
	make_date_time,
	make_from_now,
	make_from_nano_time,
	make_from_unix_time,
	make_time,
	make_utc_date,
	make_utc_date_time,
	make_utc_time


feature -- Initialisation

	make_from_now is
			-- Make `value' equal to current unix time and `nano_value'
			-- equal to the nanoseconds elapsed since `value'.
			-- Afterwards call `to_local' or `to_utc' to turn individual
			-- fields in local time or in utc time.
		local
			tp: STDC_BUFFER
		do
			create tp.allocate_and_clear (posix_timespec_size)
			safe_call (posix_clock_gettime (CLOCK_REALTIME, tp.ptr))
			make_from_nano_time (posix_timespec_tv_sec (tp.ptr), posix_timespec_tv_nsec (tp.ptr))
		end

	make_from_nano_time (a_seconds, a_nano_seconds: INTEGER) is
		do
			make_from_unix_time (a_seconds)
			nano_value := a_nano_seconds
		end

	make_from_unix_time (a_value: INTEGER) is
		do
			precursor (a_value)
			nano_value := 0
		end


feature -- Access

	nano_value: INTEGER
			-- Nano seconds elapsed since `value'


feature -- Date calculations

	is_equal (other: like Current): BOOLEAN is
		do
			Result := other.value = value and then other.nano_value = nano_value
		end

	infix "-" (other: like Current): like Current is
			-- Creates a new time which is the difference between
			-- `Current' and `Other'
		local
			diff: DOUBLE
			seconds: INTEGER
			nano_seconds: INTEGER
		do
			diff := posix_difftime (value, other.value)
			seconds := diff.truncated_to_integer
			nano_seconds := nano_value - other.nano_value
			if nano_seconds < 0 then
				seconds := seconds - 1
				nano_seconds := 1_000_000_000 - nano_seconds
			end
			create Result.make_from_nano_time (seconds, nano_seconds)
		end

	infix "<" (other: like Current): BOOLEAN is
			-- Is current object less than `other'?
		local
			diff: DOUBLE
		do
			diff := posix_difftime (value, other.value)
			if diff = 0 then
				Result := nano_value < other.nano_value
			else
				Result := diff < 0
			end
		end


end
