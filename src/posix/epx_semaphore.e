indexing

	description: "Deferred class that implements POSIX semaphores on top of ABSTRACT_SEMAPHORE."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


deferred class

	EPX_SEMAPHORE


inherit

	ABSTRACT_SEMAPHORE [POINTER]
		undefine
			do_close
		end

	POSIX_BASE

	PAPI_SEMAPHORE
		export
			{NONE} all
		end


feature -- Commands

	attempt_acquire is
			-- Lock the semaphore only if it is not locked. If it is locked
			-- by some process, this command returns immediately and the
			-- semaphore is not locked
		local
			r: INTEGER
		do
			r := posix_sem_trywait (handle)
			is_acquired := r = 0
			if not is_acquired and r /= EAGAIN then
				raise_posix_error
			end
		end

	acquire is
			-- Lock the semaphore.
		do
			safe_call (posix_sem_wait (handle))
			is_acquired := True
		end

	release is
			-- Unlock the semaphore.
		do
			safe_call (posix_sem_post (handle))
			is_acquired := False
		end


feature {NONE} -- Access

	value: INTEGER is
			-- Value of semaphore if not locked;
			-- Value is <= 0 if this semaphore is locked.
		do
			safe_call (posix_sem_getvalue (handle, $my_sem_value))
			Result := my_sem_value
		end


feature -- Status

	supports_semaphores: BOOLEAN is
			-- Does this Operating System supports semaphores?
			-- Most systems support unnamed semaphores, but still return
			-- False here...
		do
			Result := posix_semaphores
		end


feature {NONE} -- Low level handle functions

	unassigned_value: POINTER is
			-- The value that indicates that `handle' is unassigned.
		do
			Result := default_pointer
		end


feature {NONE} -- Implementation

	my_sem_value: INTEGER
			-- Temporary storage used in `value'


feature {NONE} -- Abstract API

	abstract_sem_value_max: INTEGER is
			-- Maximum initial value for a semaphore.
		do
			Result := SEM_VALUE_MAX
		end


end
