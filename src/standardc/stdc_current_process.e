indexing

	description: "Class that covers current process related routines."
	usage: "Just inherit from this class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #10 $"

class

	STDC_CURRENT_PROCESS


inherit

	STDC_PROCESS

	CAPI_STDLIB
		export
			{NONE} all
		end

	CAPI_LOCALE
		export
			{NONE} all
		end

	CAPI_TIME
		rename
			posix_time as current_time
		export
			{NONE} all;
			{ANY} current_time
		end

	EPX_ARGUMENTS


feature -- Process standard input/output/error

	stdin: STDC_TEXT_FILE is
		once
			create Result.attach_to_stream (stream_stdin, "r")
		ensure
			stdin_not_void: Result /= Void
			open_read: Result.is_open_read
		end

	stdout: STDC_TEXT_FILE is
		once
			create Result.attach_to_stream (stream_stdout, "w")
		ensure
			stdout_not_void: Result /= Void
			open_read: Result.is_open_write
		end

	stderr: STDC_TEXT_FILE is
		once
			create Result.attach_to_stream (stream_stderr, "w")
		ensure
			stderr_not_void: Result /= Void
			open_read: Result.is_open_write
		end


feature {NONE} -- Features to exit a program

	abort is
			-- Causes abnormal process termination.
			-- On many systems, dumps core.
		do
			posix_abort
		ensure
			we_should_never_come_here: False
		end


	exit (a_status: INTEGER) is
			-- Terminate this process with exit code `a_status'.
		do
			posix_exit (a_status)
		end

	exit_with_failure is
			-- Exit program immediately with OS dependent failure code.
		do
			exit (EXIT_FAILURE)
		end

	exit_with_success is
			-- Exit program immediately with OS dependent OK code.
		do
			exit (EXIT_SUCCESS)
		end


feature -- Various

	clock: INTEGER is
			-- Approximation of processor time used by the program, or -1
			-- if unknown
		do
			Result := posix_clock
		end


feature -- Random numbers

	random: INTEGER is
			-- Returns a pseudo-random integer between 0 and `RAND_MAX'.
		do
			Result := posix_rand
		ensure
			random_in_range: random >= 0 and random <= RAND_MAX
		end

	rand: INTEGER is
		obsolete "use random instead."
		do
			Result := random
		end

	set_random_seed (a_seed: INTEGER) is
			-- Sets `a_seed' as the seed for a new sequence of
			-- pseudo-random integers to be returned by `random'. These
			-- sequences are repeatable by calling `set_random_seed' with
			-- the same seed value. If no seed value is provided, the
			-- `random' function is automatically seeded with a value of
			-- 1.
		require
			seed_not_negative: a_seed >= 0
		do
			posix_srand (a_seed)
		end

	srandom (a_seed: INTEGER) is
		obsolete "Use set_random_seed instead."
		do
			set_random_seed (a_seed)
		end


feature -- Global locale

	locale: STRING is
			-- Current locale
		do
			Result := sh.pointer_to_string (posix_setlocale (LC_ALL, default_pointer))
		end

	numeric_format: STDC_LOCALE_NUMERIC is
			-- Various information for formatting numbers and monetary
			-- quantities
		once
			create Result
		ensure
			numeric_format_not_void: Result /= Void
		end

	set_locale (category: INTEGER; new_locale: STRING) is
			-- Set given locale to `new_locale'. `new_locale' is either a
			-- well-known constant like "C" or "da_DK" or an opaque
			-- string that was returned by another call of `setlocale'.
		local
			p: POINTER
		do
			p := posix_setlocale (category, sh.string_to_pointer (new_locale))
			sh.unfreeze_all
			if p = default_pointer then
				raise_posix_error
			end
		end

	set_c_locale is
			-- Set locale to the Standard C locale (the default).
		do
			set_locale (LC_ALL, "C")
		end

	set_native_decimal_point is
			-- Set the decimal point character using the LC_NUMERIC
			-- environment variable.
		do
			set_locale (LC_NUMERIC, "")
		end

	set_native_locale is
			-- Set entire locale to the native's setting which is
			-- determend by environment variables like LC_NUMERIC,
			-- LC_COLLATE, LC_CTYPE etc.
		do
			set_locale (LC_ALL, "")
		end

	set_native_time is
			-- Set time display to the native's setting using the LC_TIME
			-- environment variable.
		do
			set_locale (LC_TIME, "")
		end


end
