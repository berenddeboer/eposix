indexing

	description: "Class that abstracts POSIX and Windows child processes."

	author: "Berend de Boer"
	date: "$Date: 2003/03/20 $"
	revision: "$Revision: #4 $"


deferred class

	ABSTRACT_CHILD_PROCESS


inherit

	ABSTRACT_PROCESS

	STDC_CHILD_PROCESS


feature -- Actions that parent may execute

	wait_for (suspend: BOOLEAN) is
			-- Wait for process to terminate if `suspend', else just get
			-- status info.
		require
			pid_refers_to_child: is_pid_valid
			not_terminated: not is_terminated
		deferred
		ensure
			terminated: suspend implies is_terminated
			pid_invalid: is_terminated implies not is_pid_valid
		end


invariant

	pid_known_is_not_terminated: is_pid_valid = not is_terminated

end
