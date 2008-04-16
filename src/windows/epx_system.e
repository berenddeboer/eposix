indexing

	description: "ABSTRACT_SYSTEM implementation for Windows."
	usage: "Just inherit from this class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

class

	EPX_SYSTEM


inherit

	ABSTRACT_SYSTEM
		undefine
			raise_posix_error
		end

	WINDOWS_BASE

	WAPI_LIMITS


feature -- Compile-time determined queries

	max_argument_size: INTEGER is
			-- The length of arguments for the exec() function
		do
			Result := arg_max
		end

	max_open_files: INTEGER is
			-- The maximum number of files that one process can have
			-- open at one time.
		do
			Result := open_max
		end

	max_open_streams: INTEGER is
			-- The maximum number of streams that one process can have
			-- open at one time.
		do
			Result := stream_max
		end

	max_time_zone_name: INTEGER is
			-- The maximum number of bytes in a timezone name.
		do
			Result := tzname_max
		end


feature -- uname queries

	system_name: STRING is
			-- Name of the implementation of the operating system.
		once
			if posix_osversioninfoa_dwplatformid (version_info.ptr) = VER_PLATFORM_WIN32_NT then
				Result := "NT"
			else
				Result := "Windows"
			end
		end

	node_name: STRING is
			-- Name of this node on the network.
		local
			computer_name: STDC_ENV_VAR
		once
			-- Trick, want gethostname here, but not much time now.
			create computer_name.make ("COMPUTERNAME")
			Result := computer_name.value
		end

	release: STRING is
			-- Current release level of this implementation.
		once
			Result :=
				posix_osversioninfoa_dwmajorversion (version_info.ptr).out +
				"." +
				posix_osversioninfoa_dwminorversion (version_info.ptr).out +
				"." +
				posix_osversioninfoa_dwbuildnumber (version_info.ptr).out
		end

	version: STRING is
			-- Current version level of this release.
		once
			Result :=
				sh.pointer_to_string (posix_osversioninfoa_szcsdversion (version_info.ptr))
		end

	machine: STRING is
			-- Name of the hardware type the system is running on.
		once
			-- cygwin can do it, see how.
			Result := "unknown"
		end


feature {NONE}

	version_info: STDC_BUFFER is
		once
			create Result.allocate (posix_osversioninfoa_size)
			posix_set_osversioninfoa_dwosversioninfosize (Result.ptr, posix_osversioninfoa_size)
			safe_win_call(posix_getversionex (Result.ptr))
		end

end
