indexing

	description: "Abstract fork root class."

	usage: "Implement execute method and either:%
	%- pass this class to your fork method if you inherit from%
	%  POSIX_CURRENT_PROCESS%
	%- or call the fork method and pass yourself."


	author: "Berend de Boer"


deferred class

	POSIX_FORK_ROOT


inherit

	POSIX_CHILD_PROCESS
		rename
			is_pid_valid as is_child_pid_valid,
			pid as child_pid,
			kill as kill_child,
			terminate as terminate_child
		redefine
			has_exit_code
		end

	POSIX_CURRENT_PROCESS
-- 		select
-- 			pid,
-- 			is_pid_valid,
-- 			kill,
-- 			terminate
-- 		end

	PAPI_WAIT
		export
			{NONE} all
		end

	CAPI_STDLIB
		export
			{NONE} all
		end


feature -- Process properties

	is_valid_child_process: BOOLEAN is
			-- Does this object have a valid child process identifier?
			-- The child process itself may have stopped though.
		obsolete "Use is_child_pid_valid instead."
		do
			Result := is_child_pid_valid
		end


feature {POSIX_CURRENT_PROCESS}

	frozen start is
			-- Called by the `fork' routine.
			-- Makes sure child does never return.
		do
			after_fork
			execute
			exit_with_success
		ensure
			does_not_return: false
		rescue
			-- last resort
			minimal_exit (EXIT_FAILURE)
		end


feature {NONE} -- After fork routines

	after_fork is
			-- chance for code to do something before the main execute
			-- mainly here for POSIX_DAEMON.
		do
			-- do nothing
		end

	execute is
			-- Start if child process.
		deferred
		end


feature -- termination info

	has_exit_code: BOOLEAN is
			-- Does `exit_code' return a valid value?
		do
			Result := is_terminated and then is_terminated_normally
		end

	is_terminated_normally,
	is_exited: BOOLEAN is
			-- Has this process been terminated normally?
		require
			valid_status_info: is_terminated
		do
			Result := posix_wifexited (termination_info)
		end

	exit_code: INTEGER is
			-- Low-order 8 bits of call to _exit or exit for this process
		do
			Result := posix_wexitstatus (termination_info)
		end

	is_signalled: BOOLEAN is
			-- Was child process terminated due to receipt of a signal
			-- that was not caught?
		require
			valid_status_info: is_terminated
		do
			Result := posix_wifsignaled (termination_info)
		end

	signal_code: INTEGER is
			-- Signal which caused the process to terminate
		require
			valid_status_info: is_terminated
			terminated_by_signal: is_signalled
		do
			Result := posix_wtermsig (termination_info)
		end


end
