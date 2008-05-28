indexing

	description: "Stream that gets base64 data from another stream and emits decoded characters."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	EPX_BASE64_INPUT_STREAM


inherit

	EPX_STREAM_INPUT_STREAM [CHARACTER]
		rename
			last_item as last_character,
			read as read_character
		redefine
			end_of_input,
			last_character,
			make,
			read_character,
			valid_unread_item
		end

	KL_IMPORTED_INTEGER_ROUTINES
		export
			{NONE} all
		end

	EPX_BASE64_ENCODING
		rename
			decoded_characters as triplet
		export
			{NONE} all
		end


create

	make,
	make_connect


feature {NONE} -- Initialization

	make is
		do
			precursor
			create codes.make (1, 4)
			create triplet.make_filled (' ', 3)
			triplet_position := 4
		end


feature -- Input

	read_character is
			-- Read the next item in input stream.
			-- Make the result available in `last_item'.
		do
			if triplet_position = 4 then
				read_24_bits
			end
			if not end_of_input then
				last_character := triplet.item (triplet_position)
				triplet_position := triplet_position + 1
			end
		end


feature -- Status report

	end_of_input: BOOLEAN
			-- Has the end of input stream been reached?

	valid_unread_item (an_item: CHARACTER): BOOLEAN is
			-- Can `an_item' be put back in input stream?
		do
			Result := False
		end


feature -- Access

	last_character: CHARACTER
			-- Last item read


feature {NONE} -- Decoding

	codes: ARRAY [INTEGER]

	read_24_bits is
			-- Read the next four characters, decode them, and make the
			-- decoded characters available in `decoded'.
			-- Sets `end_of_input' if premature end of input reached.
			-- Sets `triplet_position' to the first character.
			-- It ignores invalid characters.
		local
			c: CHARACTER
			i: INTEGER
			code: INTEGER
		do
			-- Fill `codes' with four 6-bit values.
			triplet_position := 1
			from
				i := 1
				source.read
			until
				source.end_of_input or else
				i > 4
			loop
				c := source.last_item
				if c = '=' then
					triplet_position := triplet_position + 1
				end
				code := decode_character (c)
				inspect code
				when -1 then
					-- white space, ignore
				when -2 then
					-- bad base64 stream
				else
					codes.put (code, i)
					i := i + 1
				end
				if i <= 4 then
					source.read
				end
			end

			-- Bit-shift `codes' into 3 characters
			if i = 5 and then triplet_position <= 3 then
				code := (codes.item (1) * shift_2_bits_left) + (codes.item (2) // shift_4_bits_right)
				triplet.put (INTEGER_.to_character (code), triplet_position)
				if triplet_position < 3 then
					code := (codes.item (2) * shift_4_bits_left) + (codes.item (3) // shift_2_bits_right)
					code := code \\ 256
					triplet.put (INTEGER_.to_character (code), triplet_position + 1)
					if triplet_position = 1 then
						code := (codes.item (3) * shift_6_bits_left) + (codes.item (4))
						code := code \\ 256
						triplet.put (INTEGER_.to_character (code), 3)
					end
				end
			else
				end_of_input := True
			end
		end

	triplet_position: INTEGER
			-- Position in `triplet'.


invariant

	codes_not_void: codes /= Void
	codes_valid: codes.lower = 1 and then codes.upper = 4
	triplet_not_void: triplet /= Void
	triplet_has_three_characters: triplet.count = 3
	valid_triplet_position: triplet_position >= 1 and triplet_position <= 4

end
