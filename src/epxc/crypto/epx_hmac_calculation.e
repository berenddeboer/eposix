indexing

	description:

		"Perform calculation of a HASH function."

	library: "eposix library"
	standards: "RFC 2104"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2008, Berend de Boer"
	license: "MIT License (see LICENSE)"
	date: "$Date$"
	revision: "$Revision$"


class

	EPX_HMAC_CALCULATION


inherit

	EPX_HASH_CALCULATION
		redefine
			checksum,
			wipe_out
		end


create

	make


feature {NONE} -- Initialization

	make (a_key: STRING; a_calculation: EPX_HASH_CALCULATION) is
			-- Initialize. Object does not store a copy of `a_key'.
		require
			not_empty: a_key /= Void and then not a_key.is_empty
			calculation_not_void: a_calculation /= Void
		local
			i: INTEGER
			padded_key: STRING
		do
			calculation := a_calculation
			calculation.wipe_out
			-- Although we don't store `a_key', we store the xorred ipad
			-- and opd. According to RFC 2104: "We stress that the stored
			-- intermediate values need to be treated and protected the
			-- same as secret keys."
			if a_key.count <= a_calculation.block_length then
				padded_key := a_key.twin
			else
				calculation.put_string (a_key)
				calculation.finalize
				padded_key := calculation.binary_checksum.substring (0, calculation.binary_checksum.capacity-1)
				calculation.secure_wipe_out
			end
			from
				i := padded_key.count + 1
			until
				i > calculation.block_length
			loop
				padded_key.append_character ('%U')
				i := i + 1
			end
			create key_xor_ipad.make_filled ('%/54/', block_length)
			create key_xor_opad.make_filled ('%/92/', block_length)
			perform_xor (key_xor_ipad, padded_key)
			perform_xor (key_xor_opad, padded_key)
			calculation.put_string (key_xor_ipad)
			-- Wipe out `padded_key'
			from
				i := 1
			until
				i > padded_key.count
			loop
				padded_key.put ('%U', 1)
				i := i + 1
			end
		end


feature -- Access

	block_length: INTEGER is
			-- Length of a single block upon which the hash operates
		do
			Result := calculation.block_length
		end

	checksum: STRING is
		do
			Result := calculation.checksum
		end

	hash_output_length: INTEGER is
			-- Byte length of the hash output function
		do
			Result := calculation.hash_output_length
		end

	minimum_recommended_key_length: INTEGER is
			-- Minimal recommended length of key
		do
			Result := hash_output_length
		end


feature -- Operations

	put_buffer (buf: STDC_BUFFER; start, stop: INTEGER) is
		do
			calculation.put_buffer (buf, start, stop)
		end

	put_character (c: CHARACTER) is
		do
			calculation.put_character (c)
		end

	put_substring (s: STRING; start, stop: INTEGER) is
		do
			calculation.put_substring (s, start, stop)
		end

	finalize is
		local
			first_hash: STDC_BUFFER
		do
			calculation.finalize
			first_hash := calculation.binary_checksum.twin
			calculation.wipe_out
			calculation.put_string (key_xor_opad)
			calculation.put_buffer (first_hash, 0, first_hash.capacity-1)
			calculation.finalize
			binary_checksum := calculation.binary_checksum
			is_checksum_available := True
			first_hash.deallocate
		end

	wipe_out is
		do
			precursor
			calculation.wipe_out
			calculation.put_string (key_xor_ipad)
		end


feature {NONE} -- Implementation

	calculation: EPX_HASH_CALCULATION

	B: INTEGER is 64
			-- byte-length of single compression block

	key_xor_ipad: STRING

	key_xor_opad: STRING

	perform_xor (s, a_key: STRING) is
			-- Perform xor of every byte in `s' with `key' and put the
			-- result in `s's.
		require
			s_has_proper_length: s /= Void and then s.count = block_length
			key_has_proper_length: a_key /= Void and then a_key.count = block_length
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > s.count
			loop
				s.put ((s.item (i).code.bit_xor (a_key.item (i).code)).to_character, i)
				i := i + 1
			end
		end


invariant

	calculation_not_void: calculation /= Void

end
