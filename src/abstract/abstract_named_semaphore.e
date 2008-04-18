indexing

	description:

		"Named semaphore abstraction that works both in Windows and POSIX."

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	ABSTRACT_NAMED_SEMAPHORE [H]


inherit

	ABSTRACT_SEMAPHORE [H]


feature {NONE} -- Initialization

	create_nonexclusive (a_name: STRING; a_value: INTEGER) is
			-- Create a named semaphore with initial value `a_value'. If
			-- `a_value' is zero, the semaphore is created in the
			-- acquired state.
			-- If a semaphore with name `a_name' exists, `a_value' is
			-- ignored.
		require
			uninitialized: not is_open
			semaphores_supported: supports_semaphores
			name_valid: is_valid_name (a_name)
			valid_value: a_value >= 0 and a_value <= abstract_sem_value_max
		deferred
		ensure
			initialized: raise_exception_on_error implies is_open
			name_set: name.is_equal (a_name)
			acquired: is_open implies ((a_value = 0) = is_acquired)
		end

	open (a_name: STRING) is
			-- Open the existing semaphore with name `a_name'.
		require
			uninitialized: not is_open
			semaphores_supported: supports_semaphores
			name_valid: is_valid_name (a_name)
		deferred
		ensure
			initialized: raise_exception_on_error implies is_open
			name_set: name.is_equal (a_name)
			not_acquired: not is_acquired
		end


feature -- Access

	name: STRING
			-- Semaphore name


feature -- Status

	is_valid_name (a_name: STRING): BOOLEAN is
			-- Is `a_name' a valid semaphore name?
			-- Operating Systems have many different rules for valid
			-- names, some require a slash and some forbid it.
			-- Generally speaking the name must not be empty and no
			-- longer than `PATH_MAX' characters.
		deferred
		ensure
			valid_name: Result implies (a_name /= Void and then not a_name.is_empty)
		end


invariant

	name_not_empty: name /= Void and then not name.is_empty

end
