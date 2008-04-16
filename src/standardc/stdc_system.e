indexing

	description: "Class that covers Standard C current system info related%
	%routines."

	usage: "Just inherit from this class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"

class

	STDC_SYSTEM

inherit

	STDC_BASE

	CAPI_STDLIB


feature -- run-time determined queries

	is_shell_available: BOOLEAN is
			-- Return True if command interpreter is available
		do
			Result := posix_system (default_pointer) /= 0
		end

	is_windows: BOOLEAN is
			-- Are we running on the Windows platform?
			-- Note that this is false when using cygwin as for all
			-- intends and purposes cygwin is unix to a program that
			-- compiled with it.
		external "C"
		end


feature -- Compile time determined queries

	clocks_per_second: INTEGER is
			-- Number per second of the value returned by the `clock' function
		external "C"
		alias "const_clocks_per_sec"
		end


feature -- Time zone

	time_zone_seconds: INTEGER is
			-- Number of seconds to add to UTC to arrive at the time for
			-- the current time zone
		local
			t1, t2: STDC_TIME
		once
			create t1.make_from_now
			t1.to_local
			create t2.make_utc_date_time (t1.year, t1.month, t1.day, t1.hour, t1.minute, t1.second)
			Result := t2.value - t1.value
		end


feature -- Endianess

	is_big_endian: BOOLEAN is
			-- True if this is a big endian architecture
		once
			Result := posix_first_byte (258) = 1 -- 0x0102 == 0x01
		end

	is_little_endian: BOOLEAN is
			-- True if this is a little endian architecture
		once
			Result := not is_big_endian
		end


feature {NONE} -- C bindings

	posix_first_byte (i: INTEGER): INTEGER is
		external "C"
		end


end
