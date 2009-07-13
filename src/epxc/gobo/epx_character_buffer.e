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
			append_substring_to_string,
			as_special
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


feature -- Conversion

	as_special: SPECIAL [CHARACTER] is
			-- 'SPECIAL [CHARACTER]' version of current character buffer;
			-- Characters are indexed starting at 1;
			-- Note that the result may share the internal data with `Current'.
		local
			i: INTEGER
			s: SPECIAL [CHARACTER]
			c: CHARACTER
		do
			-- Unfortunately we must copy the data out of the buffer for
			-- this routine. For ISE I probably can use
			-- SPECIAL.base_address for a faster copy?
			-- We must return a 1 based SPECIAL, so have dummy character
			-- at the beginning.
			create s.make (count + 1)
			from
				c := posix_peek_character (ptr, i)
			variant
				(count + 1) - i
			until
				c = '%U'
			loop
				s.put (c, i + 1)
				i := i + 1
				c := posix_peek_character (ptr, i)
			end
			Result := s
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
