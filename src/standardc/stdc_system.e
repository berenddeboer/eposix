indexing

	description: "Class that covers Standard C current system info related%
	%routines."

	usage: "Just inherit from this class."

	author: "Berend de Boer"
	date: "$Date: 2007/02/06 $"
	revision: "$Revision: #4 $"

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


feature -- compile time determined queries

	clocks_per_second: INTEGER is
			-- number per second of the value returned by the `clock' function
		external "C"
		alias "const_clocks_per_sec"
		end


feature -- endianess

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
