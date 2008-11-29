indexing

	description:
		"Describes file related security."

	usage: "Inherit from STDC_SECURITY_ACCESSOR."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


class

	STDC_SECURITY_FILES


inherit

	STDC_SECURITY_ASPECT


create {STDC_SECURITY}

	make


feature {NONE} -- Initialization

	make is
			-- Allow everything.
		do
			max_open_files := Max_Int
		ensure
			no_files_open: open_files = 0
		end


feature -- Access

	max_open_files: INTEGER
			-- Maximum number of files that may be open;
			-- When `max_open_files' is reached and another is opened, an
			-- exception will be raised. Note that the system will be
			-- open one more file. The check if the maximum has been
			-- reached is done after the file has been opened, not
			-- before.

	open_files: INTEGER is
			-- The number of files that are currently open
		external "C"
		alias "posix_open_files"
		ensure
			open_files_not_negative: Result >= 0
		end


feature -- Change

	set_max_open_files (a_value: INTEGER) is
			-- Change the number of files that maybe open at a given
			-- time.
		require
			value_not_less_than_open_files: a_value >= open_files
		do
			max_open_files := a_value
		ensure
			max_open_files_set: max_open_files = a_value
		end


feature {STDC_SECURITY_ACCESSOR} -- Count resource usage

	decrease_open_files is
		require
			can_decrease_number_of_files: open_files > 0
		external "C"
		alias "posix_decrease_open_files"
		ensure
			open_files_decreased: open_files = old open_files - 1
		end

	increase_open_files is
		do
			-- Increase the number of files first, as the file is already
			-- open and must be closed. This means we can open one more
			-- file than `max_open_files'.
			posix_increase_open_files
			check_max_open_files
		ensure
			open_files_increased: open_files = old open_files + 1
		end


feature {NONE} -- Implementation

	memory: MEMORY is
			-- Ensuring that resource counting is correct, works only
			-- when garbage collector doesn't kick in to dispose handles.
			-- Need to test if garbage collector enabled or not.
		once
			create Result
		end

	posix_increase_open_files is
		external "C"
		ensure
			open_files_increased: open_files = old open_files + 1
		end


feature -- Checks

	check_max_open_files is
			-- Raise exception if the number of open files has exceeded
			-- `max_open_files'.
		do
			if open_files > max_open_files then
				raise_security_error ("Maximum allowed open files exceeded.")
			end
		end

	is_open_files_increased (should_increase: BOOLEAN; old_open_files: INTEGER): BOOLEAN is
			-- Is `open_files' correctly incremented depending on
			-- `should_increase' given old `open_files'?
			-- Routine to be used in postconditions.
		require
			old_open_files_not_negative: old_open_files >= 0
		do
			Result :=
				memory.collecting or else
				((should_increase implies
				  open_files = old_open_files + 1) and then
				 (not should_increase implies
				  open_files = old_open_files))
		ensure
			no_test_when_gc_enabled: memory.collecting implies Result
		end

invariant

	max_open_files_not_negative: max_open_files >= 0
	open_files_within_limit: open_files - 1 <= max_open_files

end
