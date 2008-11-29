indexing

	description: "Abstraction class for POSIX and WINDOWS child."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	ABSTRACT_PROCESS


inherit

	STDC_PROCESS


feature -- Access

	pid: INTEGER is
			-- The process identifier
		require
			valid_pid: is_pid_valid
		deferred
		ensure
			valid_pid: Result > 0
		end


feature -- Status

	is_pid_valid: BOOLEAN is
			-- Has this process a correct pid?
		do
			-- SmartEiffel gets confused by all the renaming ending up in
			-- EPX_EXEC_PROCESS, so it calls this for a child, so we
			-- trick SE to do the right thing.
			Result := se_child_pid > 0
		end


feature -- Signal this process

	terminate is
			-- Attempt to gracefully terminate this process.
		require
			valid_pid: is_pid_valid
		deferred
		end


feature {NONE} -- State necessary for SE

	se_child_pid: INTEGER


end
