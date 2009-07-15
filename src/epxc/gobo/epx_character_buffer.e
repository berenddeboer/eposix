indexing

	description: "Gobo KI_CHARACTER_BUFER on top of STDC_BUFFER."

	implementation:
	"STDC_BUFFER is zero-based, while KI_CHARACTER_BUFFER is 1 based,%
	%care has been taken to map everything correctly, but there still%
	%might be some off-by-one errors lurking...%
	%And don't even think of mixing STDC_BUFFER calls with %
	%KI_CHARACTER_BUFFER calls!"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

class

	EPX_CHARACTER_BUFFER

inherit

	KI_CHARACTER_BUFFER
		undefine
			copy,
			is_equal
		redefine
			append_substring_to_string
		end

	STDC_BUFFER
		rename
			allocate as make,
			capacity as count,
			substring as buffer_substring
		end

create

	make,
	make_from_string


feature -- Access

	item (i: INTEGER): CHARACTER is
		do
			Result := posix_peek_character (ptr, i-1)
		end

	substring (s, e: INTEGER): STRING is
		do
			Result := buffer_substring (s-1, e-1)
		end


feature -- Element change

	append_substring_to_string (s, e: INTEGER; a_string: STRING) is
			-- Append string made up of characters held in buffer
			-- between indexes `s' and `e' to `a_string'.
		do
			c_substring_with_string (a_string, s-1, e-1)
		end

	put (v: CHARACTER; i: INTEGER) is
		do
			posix_poke_character (ptr, i-1, v)
		end

end
