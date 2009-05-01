indexing

	description: "POSIX daemon class."

	usage: "Inherit from this class, implement `execute' and call just `detach' in your creation routine (don't call `execute'). You can `execute' for the non-daemonised (interactive) version."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


deferred class

	POSIX_DAEMON


inherit

	POSIX_FORK_ROOT
		redefine
			after_fork
		end

	CAPI_SIGNAL
		export
			{NONE} all
		end

	PAPI_UNISTD
		export
			{NONE} all
		end

	PAPI_STAT
		export
			{NONE} all
		end


feature -- Daemon specific actions

	detach is
			-- detach from command-line, not very useful if you want to
			-- spawn multiple daemons, but you can always pass daemons to
			-- the fork routine yourself.
		do
			fork (Current)
			-- As we fork twice, wait for the first child to terminate,
			-- that should almost be immediately.
			set_pid (last_child_pid)
			wait_for (True)
		end

	after_fork is
			-- Code thanks to W. Richard Stevens.
			-- If you are started from inetd, you're in big trouble
			-- already and sinking deeper in the mud. For inetd there will
			-- be another method to call, perhaps `init_inetd' or so.
		local
			pr: POINTER
			r: INTEGER
			i: INTEGER
		do
			-- become session leader
			safe_call (posix_setsid)

			-- ignore SIGHUP
			pr := posix_signal (SIGHUP, SIG_IGN)
			if pr = SIG_ERR then
				raise_posix_error
			end

			-- guarantee we cannot acquire a controlling terminal by
			-- forking again
			if posix_fork /= 0 then
				-- let first child terminate
				exit (EXIT_SUCCESS)
			end

			-- change working directory to root, so volume can be unmounted
			r := posix_chdir (sh.string_to_pointer ("/"))
			sh.unfreeze_all

			-- clear our file mode creation mask
			r := posix_umask (0)

			-- clear first 64 (open) file descriptors here.
			-- However, SmartEiffel doesn't like that, we have to leave
			-- the first 3 file descriptors open...
--  			if stdin.is_open then
--  				stdin.detach
--  			end
--  			if stdout.is_open then
--  				stdout.detach
--  			end
--  			if stderr.is_open then
--  				stderr.detach
--  			end
--  			if fd_stdin.is_open then
--  				fd_stdin.detach
--  			end
--  			if fd_stdout.is_open then
--  				fd_stdout.detach
--  			end
--  			if fd_stderr.is_open then
--  				fd_stderr.detach
--  			end
			from
				i := 3
			until
				i = 63
			loop
				r := posix_close (i)
				i := i + 1
			end

			-- perhaps open stdin, stdout and stderr to /dev/null here?
		end


end
