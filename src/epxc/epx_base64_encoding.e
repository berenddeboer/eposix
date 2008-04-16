indexing

	description: "Routines to encode and decode base64 sequence of characters."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

class

	EPX_BASE64_ENCODING


inherit

	ANY

	KL_IMPORTED_INTEGER_ROUTINES
		export
			{NONE} all
		end


feature -- Routines

	decoded_characters: STRING
			-- Characters decoded by `decode_24bits'.

	decode_24_bits (c1, c2, c3, c4: CHARACTER) is
			-- Decode the 24 bits in `c1'..`c4' into `first_character',
			-- `second_character' and `third_character'.
		require
			c1_is_valid_base64_character: is_base64_character (c1)
			c2_is_valid_base64_character: is_base64_character (c1)
			c3_is_valid_base64_character: is_base64_character (c1)
			c4_is_valid_base64_character: is_base64_character (c1)
		local
			code1,
			code2,
			code3,
			code4: INTEGER
			code: INTEGER
		do
			if decoded_characters = Void then
				create decoded_characters.make_filled (' ', 3)
			end
			code1 := decode_character (c1)
			code2 := decode_character (c2)
			code3 := decode_character (c3)
			code4 := decode_character (c4)
			code := (code1 * shift_2_bits_left) + (code2 // shift_4_bits_right)
			decoded_characters.put (INTEGER_.to_character (code), 1)
			code := (code2 * shift_4_bits_left) + (code3 // shift_2_bits_right)
			code := code \\ 256
			decoded_characters.put (INTEGER_.to_character (code), 2)
			code := (code3 * shift_6_bits_left) + (code4)
			code := code \\ 256
			decoded_characters.put (INTEGER_.to_character (code), 3)
		end


feature -- Character routines

	decode_character (ch: CHARACTER): INTEGER is
			-- Decode character, code thanks to Franck Arnaud.
			-- Returns -1 if `ch' is an ignorable character.
			-- Returns -2 if `ch' is an invalid character.
		do
			inspect ch
			when 'A' then Result := 0
			when 'B' then Result := 1
			when 'C' then Result := 2
			when 'D' then Result := 3
			when 'E' then Result := 4
			when 'F' then Result := 5
			when 'G' then Result := 6
			when 'H' then Result := 7
			when 'I' then Result := 8
			when 'J' then Result := 9
			when 'K' then Result := 10
			when 'L' then Result := 11
			when 'M' then Result := 12
			when 'N' then Result := 13
			when 'O' then Result := 14
			when 'P' then Result := 15
			when 'Q' then Result := 16
			when 'R' then Result := 17
			when 'S' then Result := 18
			when 'T' then Result := 19
			when 'U' then Result := 20
			when 'V' then Result := 21
			when 'W' then Result := 22
			when 'X' then Result := 23
			when 'Y' then Result := 24
			when 'Z' then Result := 25
			when 'a' then Result := 26
			when 'b' then Result := 27
			when 'c' then Result := 28
			when 'd' then Result := 29
			when 'e' then Result := 30
			when 'f' then Result := 31
			when 'g' then Result := 32
			when 'h' then Result := 33
			when 'i' then Result := 34
			when 'j' then Result := 35
			when 'k' then Result := 36
			when 'l' then Result := 37
			when 'm' then Result := 38
			when 'n' then Result := 39
			when 'o' then Result := 40
			when 'p' then Result := 41
			when 'q' then Result := 42
			when 'r' then Result := 43
			when 's' then Result := 44
			when 't' then Result := 45
			when 'u' then Result := 46
			when 'v' then Result := 47
			when 'w' then Result := 48
			when 'x' then Result := 49
			when 'y' then Result := 50
			when 'z' then Result := 51
			when '0' then Result := 52
			when '1' then Result := 53
			when '2' then Result := 54
			when '3' then Result := 55
			when '4' then Result := 56
			when '5' then Result := 57
			when '6' then Result := 58
			when '7' then Result := 59
			when '8' then Result := 60
			when '9' then Result := 61
			when '+' then Result := 62
			when '=' then Result := 0 -- treat padding character as 0 bits
			when '/' then Result := 63
			when ' ', '%T', '%R', '%N' then Result := -1
			else
				Result := -2
			end
		ensure
			valid_result: Result >= -2 and Result < 64
		end

	is_base64_character (c: CHARACTER): BOOLEAN is
			-- Is `c' is a valid base64 character?
		do
			Result := decode_character (c) >= 0
		end


feature {NONE} -- Decoding bit shift constants

	shift_2_bits_left: INTEGER is 4
	shift_4_bits_left: INTEGER is 16
	shift_6_bits_left: INTEGER is 64
	shift_2_bits_right: INTEGER is 4
	shift_4_bits_right: INTEGER is 16


invariant

	decoded_characters_valid:
		decoded_characters = Void or else
		(decoded_characters.count = 3)

end
