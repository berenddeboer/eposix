indexing

	description:

		"Unnamed semaphore for POSIX"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_UNNAMED_SEMAPHORE


inherit

	EPX_SEMAPHORE

	ABSTRACT_UNNAMED_SEMAPHORE [POINTER]
		redefine
			do_close
		end


create

	create_unshared


feature {NONE} -- Initialization

	do_create (a_value: INTEGER) is
			-- Create an unnamed semaphore with initial value `a_value'.
		require
			uninitialized: not is_open
			semaphores_supported: supports_semaphores
			valid_value: a_value >= 0 and a_value <= SEM_VALUE_MAX
		local
			r: INTEGER
		do
			make_sem
			r := posix_sem_init (sem.ptr, shared, a_value)
			if r /= -1 then
				capacity := 1
				set_handle (sem.ptr, True)
				is_acquired := a_value = 0
			else
				raise_posix_error
			end
		end

	create_unshared (a_value: INTEGER) is
			-- Create an unnamed semaphore with initial value `a_value'.
			-- The semaphore can be shared between processes;
		do
			shared := False
			do_create (a_value)
		end


feature -- Status

	shared: BOOLEAN
			-- Can this semaphore be shared between processes?


feature {NONE} -- Low level handle functions

	do_close: BOOLEAN is
			-- Close resource. Return False if an error occurred. Error
			-- value should be in `errno'. This routine may never call
			-- another object, else it cannot be used safely in
			-- `dispose'.
		local
			r: INTEGER
			b: BOOLEAN
		do
			r := posix_sem_destroy (handle)
			Result := r /= -1
			sem.deallocate
			sem := Void
			b := precursor
		end


feature {NONE} -- Sempahore creation

	make_sem is
			-- allocate `sem'.
		do
			if sem = Void then
				create sem.allocate_and_clear (posix_sem_t_size)
			end
		ensure
			sem_allocated: sem /= Void and then sem.capacity >= posix_sem_t_size
		end

	sem: STDC_BUFFER
			-- Holds unnamed semaphore information


invariant

	handle_in_sync_with_sem: sem /= Void implies (sem.ptr = handle)

end
