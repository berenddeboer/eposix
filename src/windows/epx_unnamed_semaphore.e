indexing

	description:

		"Unnamed semaphore for Windows."

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

class

	EPX_UNNAMED_SEMAPHORE


inherit

	EPX_SEMAPHORE

	ABSTRACT_UNNAMED_SEMAPHORE [INTEGER]
		undefine
			do_close,
			raise_posix_error
		end


create

	create_unshared


feature {NONE} -- Initialization

	create_unshared (a_value: INTEGER) is
			-- Create an unnamed semaphore with initial value
			-- `a_value'. The semaphore handle cannot be given to
			-- processes.
		local
			r: INTEGER
		do
			-- On Windows, semaphores can always be shared, given
			-- permissions, by calling DuplicateHandle.
			shared := False
			r := posix_createsemaphore (default_pointer, a_value, Maximum_integer, default_pointer)
			if r /= 0 then
				capacity := 1
				set_handle (r, True)
				-- If initial value is zero, a semaphore an acquired
				-- semaphore is created.
				is_acquired := a_value = 0
			else
				raise_windows_error
			end
		end


feature -- Status

	shared: BOOLEAN
			-- Can this semaphore be shared between processes?


end
