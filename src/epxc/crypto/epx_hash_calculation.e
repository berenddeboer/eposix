indexing

	description:

		"Base class for all hash calculations"

	library: "eposix library"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2008, Berend de Boer"
	license: "MIT License (see LICENSE)"
	date: "$Date$"
	revision: "$Revision$"


deferred class

	EPX_HASH_CALCULATION


inherit

	KL_IMPORTED_CHARACTER_ROUTINES
		export
			{NONE} all
		end


feature -- Status

	is_checksum_available: BOOLEAN
			-- has `finalize' been called?

feature -- Access

	binary_checksum: STDC_BUFFER
			-- Final checksum as binary string; calculated
			-- by `finalize'

	checksum: STRING is
			-- Final checksum in lowercase hexadecimal digits; calculated
			-- by `finalize'
		require
			finalized: is_checksum_available
			binary_checksum_available: binary_checksum /= Void
		deferred
		ensure
			checksum_not_void: checksum /= Void
			valid_checksum_length: checksum.count = hash_output_length * 2
		end

	block_length: INTEGER is
			-- Length of a single block upon which the hash operates
		deferred
		ensure
			positive: Result > 0
		end

	hash_output_length: INTEGER is
			-- Byte length of the hash output function
		deferred
		ensure
			positive: Result > 0
		end


feature -- Operations

	hash_string (a_data: STRING) is
			-- Calculate hash for `a_data'.
		require
			data_not_empty: a_data /= Void and then not a_data.is_empty
		do
			if binary_checksum /= Void then
				wipe_out
			end
			put_string (a_data)
			finalize
		ensure
			binary_checksum_set: binary_checksum /= Void
			finalized: is_checksum_available
		end

	put_buffer (buf: STDC_BUFFER; start, stop: INTEGER) is
		require
			not_finalized: not is_checksum_available
			buf_not_void: buf /= Void
			valid_range: buf.is_valid_range (start, stop)
		deferred
		end

	put_character (c: CHARACTER) is
		require
			not_finalized: not is_checksum_available
		deferred
		end

	put_string (s: STRING) is
		require
			not_finalized: not is_checksum_available
		do
			if s /= Void and then not s.is_empty then
				put_substring (s, 1, s.count)
			end
		end

	put_substring (s: STRING; start, stop: INTEGER) is
		require
			not_finalized: not is_checksum_available
			s_not_void: s /= Void
			valid_start: start >= 1 and then start <= s.count
			valid_stop: stop >= 1 and then stop <= s.count
		deferred
		end

	finalize is
		require
			not_finalized: not is_checksum_available
		deferred
		ensure
			binary_checksum_set: binary_checksum /= Void
			finalized: is_checksum_available
		end

	secure_wipe_out is
			-- As `wipe_out' but clear data as well
		do
			wipe_out
		ensure
			not_finalized: not is_checksum_available
		end

	wipe_out is
			-- Start a new calculation.
		do
			is_checksum_available := False
			binary_checksum := Void
		ensure
			not_finalized: not is_checksum_available
		end


feature {NONE} -- Output

	append_zeros (s: STRING; i: INTEGER) is
			-- Apply left padding
		require
			s_not_void: s /= Void
		local
			j, v: INTEGER
		do
			if i > 0 then
				from
					j := 0
					v := 0x0fffffff
				until
					j = 7
				loop
					if i <= v then
						s.append_character ('0')
					end
					v := v.bit_shift_right (4)
					j := j + 1
				end
			end
		end

	to_hexadecimal_integer (integer: INTEGER): STRING is
		do
			create Result.make (8)
			append_hexadecimal_integer (integer, Result, False)
		end

	append_hexadecimal_integer (integer: INTEGER; string: STRING; upper_case: BOOLEAN) is
			-- Append 'value' as hexadecimal in `string' in upper/lower case.
		require
			string_not_void: string /= Void
		local
			s : STRING
			nibble : INTEGER
			v : INTEGER
			mask : INTEGER
		do
			if integer = 0 then
				string.append_character ('0')
			else
				create s.make (8)
				from
					v := integer
					mask := 15
				until
					v = 0
				loop
					--nibble := u_and (v, mask)
					nibble := v & mask
					s.append_character (hexadecimal_digit (nibble, upper_case))
					--v := v.right_shift (v, 4)
					v := bit_shift_right_unsigned (v, 4)
				end
				from
					v := s.count
				until
					v = 0
				loop
					string.append_character (s.item (v))
					v := v-1
				end
			end
		end

	hexadecimal_digit (n: INTEGER; upper_case: BOOLEAN): CHARACTER is
			-- A single digit
		require
			n_not_negative: n >= 0
			n_less_16: n < 16
		do
			Result := hexadecimal_digits.item (n+1)
			if upper_case then
				Result := CHARACTER_.as_upper (Result)
			end
		end

	hexadecimal_digits: STRING is "0123456789abcdef"


feature {NONE} -- Crypto primitives

	bit_rotate_left (value: INTEGER; n: INTEGER_8): INTEGER is
			-- Circulur shift of the 32 bits in to the left
		require
			n_positive: n > 0
		external "C inline"
		alias "[
(((unsigned int)$value) << $n) | (((unsigned int) $value) >> 32-$n)
]"
		end

-- 	thirty_two: INTEGER_8 is 32

-- 	bit_rotate_left (value: INTEGER; n: INTEGER_8): INTEGER is
-- 			-- Circulur shift of the 32 bits in to the left
-- 		require
-- 			n_positive: n > 0
-- 		do
-- 			Result := value.bit_shift_left (n) | bit_shift_right_unsigned (value, thirty_two - n)
-- 		end

	bit_shift_right_unsigned (value: INTEGER; n: INTEGER_8): INTEGER is
			-- Shift `value' by `n' positions right (sign bit not copied) bits
			-- falling off the end are lost.
			-- Routine here because ISE does not have an unsigned shift.
			-- Routine thanks to the Nenie project.
		require
			n_positive: n > 0
		do
			if value < 0 then
				-- bit_shift_right does sign extension, so shift by one,
				-- clear top bit, and do remainder bits on positive
				-- result.
				Result := value.bit_shift_right (1)
				Result := Result.bit_and ((1).bit_shift_left (31).bit_not)
				Result := Result.bit_shift_right (n - 1)
			else
					check
						sign_bit_clear: value >= 0
					end
				Result := value.bit_shift_right (n)
			end
		end


invariant

	valid_binary_checksum_length: binary_checksum /= Void implies binary_checksum.capacity = hash_output_length

end
