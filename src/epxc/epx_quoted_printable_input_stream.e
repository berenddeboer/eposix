indexing

	description: "Stream that gets quoted-printable data from another stream and emits decoded characters."

	known_bugs: "Does not delete white space at the end of a line."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_QUOTED_PRINTABLE_INPUT_STREAM


inherit

	EPX_STREAM_INPUT_STREAM [CHARACTER]
		rename
			last_item as last_character,
			read as read_character
		redefine
			end_of_input,
			last_character,
			make,
			read_character
		end

	EPX_OCTET_ENCODING
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
			create next_characters.make (1, 2)
		end


feature -- Status report

	end_of_input: BOOLEAN is
			-- Has the end of input stream been reached?
		do
			Result := next_character_count = 0 and then source.end_of_input
		end


feature -- Input

	read_character is
			-- Read the next item in input stream.
			-- Make the result available in `last_item'.
		local
			valid_character_read: BOOLEAN
		do
			-- We loop until a valid character is read and skip invalid
			-- ones, as suggested in RFC 2045, section 6.7.
			-- We have one bug: we don't delete trailing white space.
			-- Also we're not very robust in case of ==40 and such.
			-- Have to read cached character reading and source.read as
			-- the same, need primivite read_character.
			from
			until
				end_of_input or else
				valid_character_read
			loop
				if next_character_count > 1 then
					-- Return from cache.
					next_character_count := next_character_count - 1
					last_character := next_characters.item (next_character_count)
				else
					-- Return character from source.
					next_character_count := 0
					source.read
					if not end_of_input then
						last_character := source.last_item
						inspect last_character
						when '=' then
							read_octet_value
							valid_character_read := True
						when '%R', '%N', '%T' then
							-- valid control charcters
							valid_character_read := True
						else
							valid_character_read :=
								last_character.code >= 32 and then
								last_character.code <= 126
						end
					end
				end
			end
		end


feature -- Access

	last_character: CHARACTER
			-- Last item read


feature {NONE} -- Input decoding

	next_characters: ARRAY [CHARACTER]

	next_character_count: INTEGER

	read_octet_value is
			-- An '=' has been read, read next two digits.
		require
			has_input: not end_of_input
			last_character_is_equal_sign: last_character = '='
			no_next_characters: next_character_count = 0
		local
			digit1,
			digit2: CHARACTER
		do
			source.read
			-- If '=' is last character, just return that.
			if not end_of_input then
				digit1 := source.last_item
				if digit1 = '%N' or else digit1 = '%R' then
					-- Soft line break
					last_character := digit1
				elseif is_valid_hex_digit (digit1) then
					source.read
					if end_of_input then
						-- Return '=' and `digit1'
						next_characters.put (digit1, 1)
						next_character_count := 2
					else
						digit2 := source.last_item
						if is_valid_hex_digit (digit2) then
							last_character := from_hex_characters (digit1, digit2)
						else
							-- Return '=' and the next two as separate characters
							next_characters.put (digit1, 1)
							next_characters.put (digit2, 2)
							next_character_count := 3
						end
					end
				else
					-- Robust implementation, '=' followed by something.
					-- Return '=' and that something as separate characters.
					next_characters.put (digit1, 1)
					next_character_count := 2
				end
			end
		ensure
			next_character_count_not_one: next_character_count /= 1
		end


invariant

	next_characters_not_void: next_characters /= Void
	valid_next_character_count: next_character_count >= 0 and next_character_count <= next_characters.upper + 1

end
