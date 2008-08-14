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
			valid_checksum_length: checksum /= Void implies checksum.count = hash_output_length * 2
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
