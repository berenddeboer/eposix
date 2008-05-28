indexing

	description: "Class that covers Posix semaphore routines."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"

class

	POSIX_NAMED_SEMAPHORE


inherit

	EPX_NAMED_SEMAPHORE

	POSIX_SEMAPHORE
		export
			{ANY} SEM_VALUE_MAX
		end


create

	open,
	create_nonexclusive,
	create_exclusive,
	create_mode


feature {NONE} -- Initialization

	create_exclusive (a_name: STRING; a_value: INTEGER) is
			-- Create a named semaphore. Semaphore may not exist already.
		require
			uninitialized: not is_open
			semaphores_supported: supports_semaphores
			name_valid: is_valid_name (a_name)
			valid_value: a_value >= 0 and a_value <= SEM_VALUE_MAX
		do
			create_mode (a_name, True, S_IRUSR + S_IWUSR, a_value)
		ensure
			initialized: raise_exception_on_error implies is_open
			name_set: name.is_equal (a_name)
			acquired: is_open implies ((a_value = 0) = is_acquired)
		end


end
