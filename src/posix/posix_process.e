indexing

	description: "Class that covers POSIX process related routines."

	author: "Berend de Boer"
	date: "$Date: 2003/01/09 $"
	revision: "$Revision: #3 $"


deferred class

	POSIX_PROCESS


inherit

	ABSTRACT_PROCESS

	POSIX_BASE

	PAPI_SIGNAL

	PAPI_WAIT


feature -- signal this process

	kill (a_signal_code: INTEGER) is
			-- Send signal `signal_code' to the process
		require
			valid_pid: is_pid_valid
			valid_signal: a_signal_code >= 0
			-- not_terminated: not is_terminated
		do
			safe_call (posix_kill (pid, a_signal_code))
		end

	terminate is
			-- attempt to gracefully terminate this process
		do
			safe_call (posix_kill (pid, SIGTERM))
		end


end
