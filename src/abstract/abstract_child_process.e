note

	description: "Class that abstracts POSIX and Windows child processes."

	author: "Berend de Boer"


deferred class

	ABSTRACT_CHILD_PROCESS


inherit

	ABSTRACT_PROCESS

	STDC_CHILD_PROCESS


feature -- Access

	pid: INTEGER
			-- The process identifier
		require
			valid_pid: is_pid_valid
		deferred
		ensure
			valid_pid: Result > 0
		end


feature -- Status

	is_pid_valid: BOOLEAN
			-- Is `pid' valid?
		deferred
		end


feature -- Signal

	terminate
			-- Attempt to gracefully terminate the child.
		require
			valid_pid: is_pid_valid
		deferred
		end


feature -- Actions that parent may execute

	wait_for (suspend: BOOLEAN)
			-- Wait for process to terminate if `suspend', else just get
			-- status info.
		require
			pid_refers_to_child: is_pid_valid
			not_terminated: not is_terminated
		deferred
		ensure
			terminated: suspend implies is_terminated
			-- Does not work for SE:
			pid_invalid: is_terminated implies not is_pid_valid
		end


invariant

	--2007-12-13: invariant failure in some cases, root cause not determined yet
	--pid_known_is_not_terminated: is_pid_valid = not is_terminated

end
