indexing

	description: "Class that covers Posix unnamed semaphore routines."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"

class

	POSIX_UNNAMED_SEMAPHORE


inherit

	EPX_UNNAMED_SEMAPHORE

	POSIX_SEMAPHORE


create

	create_shared,
	create_unshared


feature {NONE} -- Initialization

	create_shared (a_value: INTEGER) is
			-- Create an unnamed semaphore with initial value `a_value'.
			-- The semaphore cannot be shared between processes;
		require
			uninitialized: not is_open
			semaphores_supported: supports_semaphores
			valid_value: a_value >= 0 and a_value <= SEM_VALUE_MAX
		do
			-- Linux doesn't seem to support this. No way to find out, at
			-- run-time, it seems.
			shared := True
			do_create (a_value)
		ensure
			initialized: raise_exception_on_error implies is_open
			shared: shared
			acquired: is_open implies ((a_value = 0) = is_acquired)
		end


feature -- Commands

	destroy is
		obsolete "2004-06-21: use close instead."
		do
			close
		end


end
