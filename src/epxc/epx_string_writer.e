indexing

	description: "Writer for STRING class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

class

	EPX_STRING_WRITER

obsolete "2003-04-23: class will be removed in a future release."

inherit

	EPX_WRITER


create

	make


feature -- creation

	make (a_s: STRING) is
		require
			valid_string: a_s /= Void
		do
			str := a_s
		end


feature -- commands

	write_character (c: CHARACTER) is
		do
			str.append_character (c)
		end

	write_pointer (p: POINTER; size: INTEGER) is
		local
			buf: STDC_BUFFER
			i: INTEGER
		do
			if size > 0 then
				create buf.make_from_pointer (p, size, false)
				from
					i := 0
				until
					i = size
				loop
					write_character (buf.peek_character (i))
					i := i + 1
				end
			end
		end

	write_string (s: STRING) is
		do
			str.append_string (s)
		end


feature {NONE} -- private state

	str: STRING


invariant

	can_write: str /= Void

end -- class EPX_STRING_WRITER
