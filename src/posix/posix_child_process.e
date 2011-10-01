indexing

	description: "Class that covers POSIX child process."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #9 $"


deferred class

	POSIX_CHILD_PROCESS


inherit

	POSIX_PROCESS

	ABSTRACT_CHILD_PROCESS


feature -- Child's pid

	pid: INTEGER is
		do
			Result := my_pid
		end


feature -- Status

	is_pid_valid: BOOLEAN is
			-- Is `pid' valid?
		do
			Result := my_pid > 0
		end


feature -- Actions that parent may execute

	wait_for (suspend: BOOLEAN) is
			-- Wait for this process to terminate. If `suspend' then we
			-- wait until the information about this process is available,
			-- else we return immediately.
			-- If suspend is False, check the running property to see
			-- if this child is really terminated.
		local
			wait_pid: INTEGER
			options: INTEGER
		do
			if stat_loc = Void then
				create stat_loc.allocate_and_clear (4)
			end
			options := 0
			if not suspend then
				options := flip_bits (options, WNOHANG, True)
			end
			wait_pid :=
				posix_waitpid (
					my_pid,
					stat_loc.ptr,
					options)
			if wait_pid = -1 then
				raise_posix_error
			end
			running := wait_pid <= 0
			if not running then
				my_pid := 0
			end
			termination_info := stat_loc.peek_integer (0)
		end

	force_terminate (a_milliseconds: INTEGER) is
			-- Try to terminate child with signal first, if child does
			-- not terminate within `a_milliseconds' forcibly terminate
			-- it.
		require
			a_milliseconds_positive: a_milliseconds > 0
		do
			if not is_terminated then
				wait_for (False)
				if not is_terminated then
					terminate
					wait_for_termination (a_milliseconds)
					if not is_terminated then
						kill (SIGKILL)
						wait_for_termination (a_milliseconds)
					end
				end
			end
		ensure
			terminated: is_terminated
		end

	wait_for_termination (a_milliseconds: INTEGER) is
			-- Wait `a_time' milliseconds for `a_child' to terminate.
		require
			a_milliseconds_positive: a_milliseconds > 0
		local
			i: INTEGER
			process: EPX_CURRENT_PROCESS
		do
			from
				create process
			until
				is_terminated or else
				i >= a_milliseconds
			loop
				process.millisleep (10)
				wait_for (False)
				i := i + 10
			end
		end


feature -- Signal

	kill (a_signal_code: INTEGER) is
			-- Send signal `signal_code' to the process.
		require
			valid_pid: is_pid_valid
			valid_signal: a_signal_code >= 0
			-- not_terminated: not is_terminated
		do
			safe_call (posix_kill (pid, a_signal_code))
		end

	terminate is
			-- Attempt to gracefully terminate the process.
		do
			safe_call (posix_kill (pid, SIGTERM))
		end


feature {POSIX_CURRENT_PROCESS}

	set_pid (a_pid: INTEGER) is
			-- Initialize pid as seen by parent, just after a fork.
		do
			my_pid := a_pid
			running := True
		ensure
			pid_set: pid = a_pid
			running: not is_terminated
		end


feature {NONE} -- Implementation

	my_pid: INTEGER

	stat_loc: STDC_BUFFER
			-- Termination info returned by `wait_for'

	termination_info: INTEGER
			-- also known as statloc

end
