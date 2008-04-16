indexing

	description: "Standard C last error number."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"

class

	STDC_ERRNO

inherit

	ANY

	EPX_EXTERNAL_HELPER
		export
			{NONE} all
		end

	CAPI_ERRNO
		export
			{NONE} all
		end

	CAPI_STRING
		export
			{NONE} all
		end


feature -- Commands

	clear is
			-- Reset error.
		do
			posix_clear_errno
		ensure
			no_error: is_ok
		end

	clear_all is
			-- Reset both `value' and `first_value'.
		do
			clear
			clear_first
		ensure
			no_error: is_ok
			no_first_error: first_value = 0
		end

	set_value (a_value: INTEGER) is
		do
			posix_set_errno (a_value)
		ensure
			value_set: value = a_value
		end


feature -- State

	is_not_ok: BOOLEAN is
			-- Are there any errors?
			-- Only valid if errno has been set.
		do
			Result := value /= 0
		end

	is_ok: BOOLEAN is
			-- Is everything just fine?
			-- Only valid if errno has been set.
		do
			Result := value = 0
		end


feature -- Access

	value: INTEGER is
			-- The error number itself
		do
			Result := posix_errno
		end

	message: STRING is
			-- Current error message
		do
			Result := error_message (value)
		ensure
			message_not_void: Result /= Void
		end

	strerror: STRING is
		obsolete "Use message instead."
		do
			Result := message
		end


feature -- The first, whatever that means,  error value

	clear_first is
			-- Reset notation of first error.
		do
			my_first_value.set_item (0)
		ensure
			no_first_error: first_value = 0
		end

	first_value: INTEGER is
			-- Error number of first error that has occurred after a
			-- `clear_first'
		do
			Result := my_first_value.item
		end

	first_message: STRING is
			-- Error message for `first_value'
		do
			Result := error_message (first_value)
		ensure
			first_message_not_void: Result /= Void
		end

	set_first is
			-- Make `first_value' equal to the current error value.
		do
			my_first_value.set_item (value)
		ensure
			first_value_set: first_value = value
		end


feature {NONE} -- Implementation

	error_message (an_errno: INTEGER): STRING is
			-- The error message given an error number.
			-- Returns a slightly more helpful error message in case
			-- `an_errno' is unknown.
		local
			p: POINTER
		do
			p := posix_strerror (an_errno)
			Result := sh.pointer_to_string (p)
			if Result.is_equal (once_unknown_error) then
				create Result.make_from_string (once_unknown_error_first)
				Result.append_string (an_errno.out)
				Result.append_string (once_unknown_error_last)
			end
		ensure
			error_message_not_void: Result /= Void
		end

	my_first_value: INTEGER_REF is
			-- Like `value', `first_value' is a global value
		once
			create Result
		ensure
			not_void: Result /= Void
		end


feature {NONE} -- Once strings

	once_unknown_error: STRING is "Unknown error%N"

	once_unknown_error_first: STRING is "Unknown error (value is "
	once_unknown_error_last: STRING is ")%N"

end
