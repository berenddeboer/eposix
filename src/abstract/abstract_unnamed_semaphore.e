indexing

	description:

		"Base class for semaphores without a name."

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


deferred class

	ABSTRACT_UNNAMED_SEMAPHORE [H]


inherit

	ABSTRACT_SEMAPHORE [H]


feature {NONE} -- Initialization

	create_unshared (a_value: INTEGER) is
			-- Create an unnamed semaphore with initial value
			-- `a_value'. The semaphore handle cannot be given to
			-- processes.
		require
			uninitialized: not is_open
			semaphores_supported: supports_semaphores
			valid_value: a_value >= 0 and a_value <= abstract_sem_value_max
		deferred
		ensure
			initialized: raise_exception_on_error implies is_open
			unshared: not shared
			acquired: is_open implies ((a_value = 0) = is_acquired)
		end


feature -- Status

	shared: BOOLEAN is
			-- Can this semaphore be shared between processes?
		deferred
		end


end
