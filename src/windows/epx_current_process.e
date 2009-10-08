indexing

	description: "Class that covers portable Windows current process code."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"


class

	EPX_CURRENT_PROCESS


inherit

	ABSTRACT_CURRENT_PROCESS
		undefine
			raise_posix_error
		end

	WINDOWS_PROCESS

	WAPI_WINDOWS
		export
			{NONE} all
		end


feature -- Access (doesn't make a lot of sense if you're not inheriting)

	effective_user_name: STRING is
			-- Name of the user currently associated with the current
			-- thread
		local
			buf: STDC_BUFFER
		do
			create buf.allocate_and_clear (UNLEN + 1)
			scratch := buf.capacity
			safe_win_call (posix_getusername (buf.ptr, $scratch))
			Result := sh.pointer_to_string (buf.ptr)
		end

	raw_environment_variables: ARRAY [STRING] is
			-- The raw list of name=value pairs of environment
			-- variables passed to this process;
			-- A new list is created every time this feature is accessed.
		local
			env: POINTER
			p: POINTER
			name_value: STRING
		do
			env := posix_getenvironmentstrings
			if env /= default_pointer then
				create Result.make (0, -1)
				from
					p := env
				until
					p = default_pointer
				loop
					name_value := sh.pointer_to_string (p)
					if not name_value.is_empty then
						Result.force (name_value, Result.upper + 1)
						p := p + name_value.count + 1
					else
						p := default_pointer
					end
				end
				safe_win_call (posix_freeenvironmentstrings (env))
			else
				raise_windows_error
				create Result.make (0, -1)
			end
		end


feature -- Standard file descriptors

	fd_stdin: EPX_FILE_DESCRIPTOR is
		once
			create {WINDOWS_FILE_DESCRIPTOR} Result.attach_to_fd (posix_getstdhandle (STD_INPUT_HANDLE), False)
		end

	fd_stdout: EPX_FILE_DESCRIPTOR is
		once
			create {WINDOWS_FILE_DESCRIPTOR} Result.attach_to_fd (posix_getstdhandle (STD_OUTPUT_HANDLE), False)
		end

	fd_stderr: EPX_FILE_DESCRIPTOR is
		once
			create {WINDOWS_FILE_DESCRIPTOR} Result.attach_to_fd (posix_getstdhandle (STD_ERROR_HANDLE), False)
		end


feature -- Sleeping

	millisleep (a_milliseconds: INTEGER) is
			-- Sleep for `a_milliseconds' milliseconds. Due to timer
			-- resolution issues, the minimum resolution might be in the
			-- order of 10ms or higher.
		do
			posix_sleep (a_milliseconds)
		end


feature {NONE} -- Abstract API

	abstract_getpid: INTEGER is
		do
			Result := posix_getcurrentprocessid
		end

	abstract_sleep (a_seconds: INTEGER): INTEGER is
		do
			posix_sleep (a_seconds * 1000)
			Result := 0
		end


feature {NONE} -- Implementation

	scratch: INTEGER
			-- Scratch var, must be global says SE

end
