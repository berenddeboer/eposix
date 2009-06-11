indexing

	description: "Class that covers portable Windows current process code."

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2007 - 2009, Berend de Boer"
	license: "MIT License"


class

	EPX_CURRENT_PROCESS


inherit

	ABSTRACT_CURRENT_PROCESS

	POSIX_PROCESS

	POSIX_BASE

	PAPI_PWD
		export
			{NONE} all
		end

	PAPI_UNISTD
		export
			{NONE} all
		end

	SAPI_SELECT
		export
			{NONE} all
		end


feature -- Access (doesn't make a lot of sense if you're not inheriting)

	effective_user_name: STRING is
			-- Name of the user currently associated with the current
			-- thread;
			-- Name will not be Void, but can be empty if no name found
			-- (you can screw up your /etc/passwd on Unix...)
		local
			passwd: POINTER
		do
			passwd := posix_getpwuid (posix_geteuid)
			if passwd /= default_pointer then
				Result := sh.pointer_to_string (posix_pw_name (passwd))
			else
				Result := ""
			end
		end

	raw_environment_variables: ARRAY [STRING] is
			-- The raw list of name=value pairs of environment
			-- variables passed to this process;
			-- A new list is created every time this feature is accessed.
		do
			Result := ah.pointer_to_string_array (posix_environ)
		end


feature -- The standard file descriptors of every process

	fd_stdin: POSIX_FILE_DESCRIPTOR is
		once
			create Result.attach_to_fd (STDIN_FILENO, False)
		end

	fd_stdout: POSIX_FILE_DESCRIPTOR is
		once
			create Result.attach_to_fd (STDOUT_FILENO, False)
		end

	fd_stderr: POSIX_FILE_DESCRIPTOR is
		once
			create Result.attach_to_fd (STDERR_FILENO, False)
		end


feature -- Sleeping

	millisleep (a_milliseconds: INTEGER) is
			-- Sleep for `a_milliseconds' milliseconds. Due to timer
			-- resolution issues, the minimum resolution might be in the
			-- order of 10ms or higher.
		local
			timeout: SUS_TIME_VALUE
			r: INTEGER
		do
			-- It is very unfortunate that I have to resort to Single
			-- Unix Specification functionality to provide
			-- `millisleep'. But as millisleep has been requested by
			-- users, there is a portable demand for it.
			-- Perhaps the EPX classes are not simply POSIX, but a mix of
			-- POSIX and SUSv3 and should therefore be in a separate directory.
			create timeout.make
			timeout.set_seconds (a_milliseconds // 1000)
			timeout.set_microseconds ((a_milliseconds \\ 1000) * 1000)
			r := posix_select (0, default_pointer, default_pointer, default_pointer, timeout.handle)
		end


feature {NONE} -- abstract API

	abstract_getpid: INTEGER is
		do
			Result := posix_getpid
		end

	abstract_sleep (a_seconds: INTEGER): INTEGER is
		do
			Result := posix_sleep (a_seconds)
		end


end
