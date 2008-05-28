indexing

	description:

		"Named semaphores for POSIX. Note that Linux (tested with 2.4.24 does not support these)"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	EPX_NAMED_SEMAPHORE


inherit

	EPX_SEMAPHORE

	ABSTRACT_NAMED_SEMAPHORE [POINTER]
		redefine
			do_close
		end


create

	create_nonexclusive,
	open


feature {NONE} -- Initialization

	create_mode (a_name: STRING; exclusive: BOOLEAN; a_mode: INTEGER; a_value: INTEGER) is
			-- Create a named semaphore with permissions given by
			-- `a_mode' and initial value `a_value'.
		require
			uninitialized: not is_open
			semaphores_supported: supports_semaphores
			name_valid: is_valid_name (a_name)
			valid_value: a_value >= 0 and a_value <= SEM_VALUE_MAX
		local
			oflag: INTEGER
			r: POINTER
		do
			name := a_name
			oflag := O_CREAT
			if exclusive then
				oflag := oflag + O_EXCL
			end
			r := posix_sem_open (sh.string_to_pointer (name), oflag, a_mode, a_value)
			sh.unfreeze_all
			if r /= SEM_FAILED then
				capacity := 1
				set_handle (r, True)
				-- If initial value is zero, an acquired semaphore is
				-- created.
				if a_value = 0 then
					if exclusive then
						is_acquired := True
					else
						-- If not exclusive, we might have opened an
						-- existing semaphore, so check the current value.
						-- In this case `is_acquired' really means that
						-- semaphore can be released.
						-- But this code can be risky. I suggest you don't
						-- create a nonexclusive semaphore with value 0.
						is_acquired := value = 0
					end
				end
			else
				raise_posix_error
			end
		ensure
			initialized: raise_exception_on_error implies is_open
			name_set: name.is_equal (a_name)
			acquired: is_open implies ((a_value = 0) = is_acquired)
		end

	create_nonexclusive (a_name: STRING; a_value: INTEGER) is
			-- Create a named semaphore. If a semaphore with name
			-- `a_name' exists, `a_value' is ignored.
		do
			create_mode (a_name, False, S_IRUSR + S_IWUSR, a_value)
		end

	open (a_name: STRING) is
			-- Open the existing semaphore with name `a_name'.
		local
			r: POINTER
		do
			is_acquired := False
			name := a_name
			r := posix_sem_open (sh.string_to_pointer (name), 0, 0, 0)
			sh.unfreeze_all
			if r /= SEM_FAILED then
				capacity := 1
				set_handle (r, True)
			else
				raise_posix_error
			end
		end


feature -- Status

	is_valid_name (a_name: STRING): BOOLEAN is
			-- Is `a_name' a valid semaphore name?
			-- Operating Systems have many different rules for valid
			-- names, some require a slash and some forbid it.
			-- Generally speaking the name must not be empty and no
			-- longer than `PATH_MAX' characters.
		do
			Result :=
				a_name /= Void and then
				not a_name.is_empty and then
				a_name.count <= PATH_MAX
		end


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
			r := posix_sem_close (handle)
			Result := r /= -1
			b := precursor
		end


end
