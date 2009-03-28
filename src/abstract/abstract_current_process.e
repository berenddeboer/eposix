indexing

	description: "Class that covers the common POSIX and Windows %
	%current process related routines."
	usage: "Just inherit from this class."
	notes: "Most of the features of this class are available only if%
	%you really are a ABSTRACT_CURRENT_PROCESS, they cannot be applied to%
	%an instance of this class, this to protect against unintended effects."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"


deferred class

	ABSTRACT_CURRENT_PROCESS


inherit

	STDC_CURRENT_PROCESS



feature -- Access

	effective_user_name: STRING is
			-- Name of the user currently associated with the current
			-- thread
		deferred
		ensure
			name_not_void: Result /= Void
		end

	full_command_name: STRING is
			-- `command_name' with fully qualified path;
			-- An empty string is returned in case `command_name' is
			-- empty. As any program can setup the arguments passed to
			-- another program, an empty `command_name' is a possibility.
		local
			fs: EPX_FILE_SYSTEM
			c: STRING
		once
			c := command_name
			if not c.is_empty then
				create fs
				Result := fs.resolved_path_name (command_name)
			end
		ensure
			full_command_name_not_void: Result /= Void
		end

	pid: INTEGER is
			-- Process identifier, unique for this process
		do
			Result := abstract_getpid
		end


feature {NONE} -- Access (but only when inheriting)

	environment_variables: ARRAY [STRING] is
			-- List of environment variables passed to this process;
			-- Be aware that a name can actually be empty!
			-- A new list is returned every time this feature is called.
		local
			raw: ARRAY [STRING]
			i: INTEGER
			p: INTEGER
			name_value,
			name: STRING
		do
			raw := raw_environment_variables
			create Result.make (raw.lower, raw.upper)
			from
				i := raw.lower
			variant
				raw.count - i
			until
				i > raw.upper
			loop
				name_value := raw.item (i)
				p := name_value.index_of ('=', 1)
				if p /= 0 then
					name := name_value.substring (1, p-1)
				else
					name := name_value
				end
				Result.put (name, i)
				i := i + 1
			end
		ensure
			environment_variables_not_void: Result /= Void
		end

	raw_environment_variables: ARRAY [STRING] is
			-- The raw list of name=value pairs of environment
			-- variables passed to this process
			-- A new list is created every time this feature is accessed.
			-- Because this list can contain basically anything (caller
			-- sets it up), treat with caution for secure programs.
		deferred
		ensure
			raw_environment_variables_not_void: Result /= Void
		end


feature -- Every process also has standard file descriptors which might not be compatible with stdin/stdout/stderr (Windows)

	fd_stdin: ABSTRACT_FILE_DESCRIPTOR is
		deferred
		ensure
			fd_stdin_not_void: Result /= Void
			not_owner: not Result.is_owner
		end

	fd_stdout: ABSTRACT_FILE_DESCRIPTOR is
		deferred
		ensure
			fd_stdout_not_void: Result /= Void
			not_owner: not Result.is_owner
		end

	fd_stderr: ABSTRACT_FILE_DESCRIPTOR is
		deferred
		ensure
			fd_stderr_not_void: Result /= Void
			not_owner: not Result.is_owner
		end


feature -- Sleeping

	millisleep (a_milliseconds: INTEGER) is
			-- Sleep for `a_milliseconds' milliseconds. Due to timer
			-- resolution issues, the minimum resolution might be in the
			-- order of 10ms or higher.
		require
			milliseconds_not_negative: a_milliseconds >= 0
		deferred
		end

	sleep (seconds: INTEGER) is
			-- Delays process execution up to `seconds'. Can return early
			-- if interrupted. Check `unslect_seconds'
		require
			max_portable_value: seconds >= 0 and seconds <= 65535
		local

		do
			unslept_seconds := abstract_sleep (seconds)
			-- unslept_seconds should be 0 or else we got a signal
		ensure
			unslept_less_than_seconds: unslept_seconds <= seconds
		end

	unslept_seconds: INTEGER
			-- The number of seconds still to sleep, before being
			-- interrupted; it is set by `sleep'. If it is zero, no
			-- interrupt occurred and process slept for the allotted
			-- time.


feature {NONE} -- Abstract API

	abstract_getpid: INTEGER is
		deferred
		end

	abstract_sleep (a_seconds: INTEGER): INTEGER is
		require
			a_seconds_not_negative: a_seconds >= 0
		deferred
		end


end
