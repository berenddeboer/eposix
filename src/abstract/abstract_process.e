indexing

	description: "Abstraction class for POSIX and WINDOWS child."

	author: "Berend de Boer"
	date: "$Date: 2003/01/09 $"
	revision: "$Revision: #3 $"

deferred class

	ABSTRACT_PROCESS


inherit

	STDC_PROCESS


feature -- Process properties

	pid: INTEGER is
			-- The process identifier.
		require
			valid_pid: is_pid_valid
		deferred
		ensure
			valid_pid: Result > 0
		end

	is_pid_valid: BOOLEAN is
			-- Has this process a correct pid?
		deferred
		end


feature -- Signal this process

	terminate is
			-- Attempt to gracefully terminate this process.
		require
			valid_pid: is_pid_valid
		deferred
		end


end
