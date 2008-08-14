indexing

	description: "Base class for all Standard C or POSIX classes."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #10 $"

class

	STDC_BASE

inherit

	ANY

	STDC_CONSTANTS
		export
			{NONE} all
		end

	EPX_EXTERNAL_HELPER
		export
			{NONE} all
		end

	STDC_SECURITY_ACCESSOR


feature -- Access

	errno: STDC_ERRNO is
			-- Access to the variable that contains the error that occurred.
		once
			create Result
		ensure
			errno_not_void: Result /= Void
		end


feature -- Status

	raise_exception_on_error: BOOLEAN is
			-- Should an exception be raised when an error occurs?
			-- If not, you have to check errno for any errors.
		do
			Result :=
				(error_action = 1) or else
				(error_action = 0 and then security.error_handling.exceptions_enabled)
		end


feature -- Change

	set_default_action_on_error is
			-- Use `security'.`error_handling.exceptions_enabled' to
			-- determine if an exception should be raised when a C call
			-- returns an error.
		do
			error_action := 0
		end

	set_raise_exception_on_error is
			-- Always raise an exception when a C call returns an error.
		do
			error_action := 1
		ensure
			exception_raised: raise_exception_on_error
		end

	set_continue_on_error is
			-- Never raise an exception when a C call returns an error.
		do
			error_action := 2
		ensure
			no_exception_raised: not raise_exception_on_error
		end

	inherit_error_handling (an_instance: STDC_BASE) is
			-- Handle errors like `an_instance'
		require
			instance_not_void: an_instance /= Void
		do
			error_action := an_instance.error_action
		ensure
			definition: error_action = an_instance.error_action
		end


feature {STDC_BASE} -- Exceptions

	error_action: INTEGER
			-- Action that should be taken when a C call returns an error:
			-- 0: check security.error_handling.exceptions_enabled
			-- 1: raise an exception
			-- 2: don't raise an exception


feature {NONE} -- Exceptions

	exceptions: EXCEPTIONS is
			-- Access to developer raised exceptions.
		once
			create Result
		end

	do_raise (name: STRING) is
		do
			exceptions.raise (name)
		end

	raise_posix_error is
			-- Throws an exception when something that is considered
			-- fatal has occurred.
			-- Exception throwing can be disabled by calling
			-- `security.error_handling.disable_exceptions'.
		require
			-- errno_should_be_set: errno.is_not_ok
		do
			if raise_exception_on_error then
				-- Unfreeze strings first because with exception we might
				-- not hit the unfreeze call in the caller.
				sh.unfreeze_all
				do_raise (errno.message)
			else
				if errno.first_value = 0 then
					errno.set_first
				end
			end
		end

	safe_call (res: INTEGER) is
			-- Raise an exception when value = -1.
		do
			if res = -1 then
				raise_posix_error
			end
		end


feature {NONE} -- Test or set bits in an integer

	flip_bits (bit_field, bits: INTEGER; on: BOOLEAN): INTEGER is
			-- Change zero or more bits and return the result.
		do
			if on then
				Result := posix_or (bit_field, bits)
			else
				Result := posix_and (bit_field, posix_not (bits))
			end
		ensure
			bits_flipped: (not on) or test_bits (Result, bits)
		end

	test_bits (bit_field, bits: INTEGER): BOOLEAN is
			-- Do all `bits' in `bit_field' have the value 1?
		do
			Result := posix_and (bit_field, bits) = bits
		end


feature {NONE} -- Make bit operations on integers possible

	posix_and (op1, op2: INTEGER): INTEGER is
		external "C"
		end

	posix_not (op: INTEGER): INTEGER is
		external "C"
		end

	posix_or (op1, op2: INTEGER): INTEGER is
		external "C"
		end


invariant

	valid_error_action: error_action >= 0 and error_action <= 2

end
