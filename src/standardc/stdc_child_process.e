indexing

	description: "Class that covers Standard C child process."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


deferred class

	STDC_CHILD_PROCESS


inherit

	STDC_BASE


feature -- Termination info

	has_exit_code: BOOLEAN is
			-- Does `exit_code' return a valid value?
		do
			Result := is_terminated
		end

	is_terminated: BOOLEAN is
			-- Is child not running any more?
		do
			Result := not running
		end

	exit_code: INTEGER is
			-- Exit code of process.
		require
			valid_status_info: has_exit_code
		deferred
		end


feature {NONE} -- Implementation

	running: BOOLEAN
			-- Must be set to True while a child process is running.


end
