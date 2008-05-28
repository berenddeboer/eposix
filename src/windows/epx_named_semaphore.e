indexing

	description:

		"Named semaphore for Windows."

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	EPX_NAMED_SEMAPHORE


inherit

	EPX_SEMAPHORE

	ABSTRACT_NAMED_SEMAPHORE [INTEGER]
		undefine
			do_close,
			raise_posix_error
		end


create

	create_nonexclusive,
	open


feature {NONE} -- Initialization

	create_nonexclusive (a_name: STRING; a_value: INTEGER) is
			-- Create a named semaphore with initial value `a_value'. If
			-- `a_value' is zero, the semaphore is created in the
			-- acquired state.
			-- If a semaphore with name `a_name' exists, `a_value' is
			-- ignored.
		local
			r: INTEGER
		do
			name := a_name
			r := posix_createsemaphore (default_pointer, a_value, Maximum_integer, sh.string_to_pointer (a_name))
			sh.unfreeze_all
			if r /= 0 then
				capacity := 1
				set_handle (r, True)
				-- If initial value is zero, an acquired semaphore is
				-- created. In case an existing semaphore is opened, we
				-- just don't know if we can release or can acquire.
				if posix_getlasterror = ERROR_SUCCESS then
					is_acquired := a_value = 0
				end
			else
				raise_windows_error
			end
		end

	open (a_name: STRING) is
			-- Open the existing semaphore with name `a_name'.
		local
			r: INTEGER
		do
			is_acquired := False
			name := a_name
			r := posix_opensemaphore (SEMAPHORE_ALL_ACCESS, False, sh.string_to_pointer (a_name))
			sh.unfreeze_all
			if r /= 0 then
				capacity := 1
				set_handle (r, True)
			else
				raise_windows_error
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
				a_name.count <= MAX_PATH
		end


end
