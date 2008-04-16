indexing

	description: "Routines to encode and decode octets as in quoted-printable encoding for example."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

class

	EPX_OCTET_ENCODING


inherit

	ANY

	KL_IMPORTED_INTEGER_ROUTINES
		export
			{NONE} all
		end


feature -- Routines

	from_hex_characters (first, second: CHARACTER): CHARACTER is
			-- Given two hex digits, convert it to a character.
		require
			valid_first_digit: is_valid_hex_digit (first)
			valid_second_digit: is_valid_hex_digit (second)
		local
			mya, myb: INTEGER
		do
			mya := hex_digit (first)
			myb := hex_digit (second)
			mya := mya * 16 + myb
			Result := INTEGER_.to_character (mya)
		end

	from_hex_string (in: STRING): CHARACTER is
			-- Take a two digit hex string, and convert it to a character.
		require
			in_not_void: in /= Void
			has_two_digits: in.count = 2
			valid_first_digit: is_valid_hex_digit (in.item (1))
			valid_second_digit: is_valid_hex_digit (in.item (2))
		do
			Result := from_hex_characters (in.item (1), in.item (2))
		end

	hex_digit (c: CHARACTER): INTEGER is
			-- Convert the hex digit ("0123456789ABCDEF") to an integer value.
		require
			valid_hex_digit: is_valid_hex_digit (c)
		do
			inspect c
			when '0'..'9' then
				Result := c.code - ('0').code
			when 'A'..'F' then
				Result := c.code - (('A').code - 10)
			when 'a'..'f' then
				Result := c.code - (('a').code - 10)
			end
		ensure
			hex_value_returned: Result >= 0 and then Result <= 15
		end

	is_valid_hex_digit (digit: CHARACTER): BOOLEAN is
			-- Is `digit' an hexadecimal digit?
		do
			inspect digit
			when '0'..'9', 'A'..'F','a'..'f' then
				Result := True
			else
				Result := False
			end
		end

	to_hex (c: CHARACTER): STRING is
			-- Take a character and return a two digit hex string.
		local
			mya, myb: CHARACTER
		do
			mya := hex_map.item ((c.code // 16) + 1)
			myb := hex_map.item ((c.code \\ 16) + 1)
			create Result.make (2)
			Result.append_character (mya)
			Result.append_character (myb)
		ensure
			to_hex_not_void: Result /= Void
			two_digits: Result.count = 2
			hex_digits:
				hex_map.has (Result.item (1)) and
				hex_map.has (Result.item (2))
		end


feature {NONE} -- Once strings

	hex_map: STRING is "0123456789ABCDEF"


end
