indexing

	description: "Deferred class that implements POSIX semaphores on top of ABSTRACT_SEMAPHORE."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_SEMAPHORE


inherit

	ABSTRACT_SEMAPHORE [INTEGER]
		undefine
			raise_posix_error
		redefine
			do_close
		end

	WINDOWS_BASE


feature -- Commands

	attempt_acquire is
			-- Lock the semaphore only if it is not locked. If it is locked
			-- by some process, this command returns immediately and the
			-- semaphore is not locked
		local
			r: INTEGER
		do
			r := posix_waitforsingleobject (handle, 0)
			is_acquired := r = WAIT_OBJECT_0
			if not is_acquired and then r = WAIT_FAILED then
				raise_windows_error
			end
		end

	acquire is
			-- Lock the semaphore.
		local
			r: INTEGER
		do
			r := posix_waitforsingleobject (handle, INFINITE)
			if r = WAIT_FAILED then
				raise_windows_error
			else
				is_acquired := True
			end
		end

	release is
			-- Unlock the semaphore.
		do
			safe_win_call (posix_releasesemaphore (handle, 1, default_pointer))
			is_acquired := False
		end


feature -- Status

	supports_semaphores: BOOLEAN is True
			-- Does this Operating System supports semaphores?


feature {NONE} -- Low level handle functions

	do_close: BOOLEAN is
			-- Close resource. Return False if an error occurred. Error
			-- value should be in `errno'. This routine may never call
			-- another object, else it cannot be used safely in
			-- `dispose'.
		do
			Result := posix_closehandle (handle)
			if not Result then
				errno.set_value (posix_getlasterror)
			else
				Result := precursor
			end
		end

	unassigned_value: INTEGER is 0
			-- The value that indicates that `handle' is unassigned.


feature {NONE} -- Abstract API

	abstract_sem_value_max: INTEGER is
			-- Maximum initial value for a semaphore.
		do
			Result := Maximum_integer
		end


end
