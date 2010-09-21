indexing

	description: "Standard C text file."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"

class

	STDC_TEXT_FILE

inherit

	STDC_FILE

	EPX_TEXT_INPUT_STREAM
		rename
			close as close_for_reading,
			is_closable as is_closable_for_reading
		undefine
			is_closable_for_reading,
			rewind
		end


create

	make,
	create_read_write,
	create_write,
	open,
	open_append,
	open_read,
	open_read_write,
	open_write,
	attach_to_stream


feature -- Text specific routines

	put_nl, put_newline, write_nl, write_newline is
			-- write a single newline
		do
			write_string ("%N")
		end


feature -- Reading

	gets (bytes: INTEGER) is
		obsolete "Use read_line instead"
		do
			read_line
		end


feature -- Status

	is_valid_mode (a_mode: STRING): BOOLEAN is
			-- Is `a_mode' a valid text open mode?
		do
			Result :=
				a_mode /= Void and then
				not a_mode.is_empty and then
				not is_binary_mode_specification (a_mode)
		end


feature {NONE}

	set_mode (a_mode: STRING) is
			-- set text mode
		local
			c: CHARACTER
		do
			c := a_mode.item (a_mode.count)
			inspect c
			when  'b',  'B' then
				do_raise ("It is not allowed to specify the binary flag %
								 %for text files.")
			when 't', 'T' then
				-- already ok
				mode := a_mode
			else
				-- It's not sure if every POSIX system allows this.
				-- mode := a_mode + "t"
				mode := a_mode
			end
		ensure then
			text_mode: not is_binary_mode_specification (mode)
		end


end
