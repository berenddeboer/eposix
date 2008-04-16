indexing

	description: "ABSTRACT_SYSTEM implementation for POSIX."
	usage: "Just inherit from this class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

class

	EPX_SYSTEM

inherit

	ABSTRACT_SYSTEM

	POSIX_BASE

	PAPI_UNISTD

	PAPI_UTSNAME


feature -- Sysconf queries, run-time determined

	max_argument_size: INTEGER is
			-- The length of arguments for the exec() function
		do
			Result := posix_sc_arg_max
		end

	max_open_files: INTEGER is
			-- The maximum number of files that one process can have
			-- open at one time.
		do
			Result := posix_sc_open_max
		end

	max_open_streams: INTEGER is
			-- The maximum number of streams that one process can have
			-- open at one time.
		do
			Result := posix_sc_stream_max
			-- -1 on QNX
			if Result = -1 then
				Result := STREAM_MAX
			end
		end

	max_time_zone_name: INTEGER is
			-- The maximum number of bytes in a timezone name.
		do
			Result := posix_sc_tzname_max
			if Result = -1 then
				-- On cygwin, we get -1, so we try to return something suitable
				Result := 3
			end
		end


feature -- uname queries

	system_name: STRING is
			-- Name of the implementation of the operating system.
		do
			Result := sh.pointer_to_string (posix_uname_sysname (system_info.ptr))
		end

	node_name: STRING is
			-- Name of this node on the network.
		do
			Result := sh.pointer_to_string (posix_uname_nodename (system_info.ptr))
		end

	release: STRING is
			-- Current release level of this implementation.
		do
			Result := sh.pointer_to_string (posix_uname_release (system_info.ptr))
		end

	version: STRING is
			-- Current version level of this release.
		do
			Result := sh.pointer_to_string (posix_uname_version (system_info.ptr))
		end

	machine: STRING is
			-- Name of the hardware type the system is running on.
		do
			Result := sh.pointer_to_string (posix_uname_machine (system_info.ptr))
		end


feature {NONE}

	system_info: STDC_BUFFER is
		once
			create Result.allocate (posix_utsname_size)
			if posix_uname (Result.ptr) = -1 then
				raise_posix_error
			end
		end

end
