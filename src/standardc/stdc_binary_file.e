indexing

	description: "Binary file."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"

class

	STDC_BINARY_FILE

inherit

	STDC_FILE
		export
			{NONE} read_line, read_new_line
		end


create

	create_read_write,
	create_write,
	open,
	open_append,
	open_read,
	open_read_write,
	open_write,
	attach_to_stream


feature -- Status

	is_valid_mode (a_mode: STRING): BOOLEAN is
			-- Is `a_mode' a valid binary open mode?
		do
			Result :=
				a_mode /= Void and then
				not a_mode.is_empty and then
				is_binary_mode_specification (a_mode)
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
				-- already ok
				mode := a_mode
			when 't', 'T' then
				do_raise ("It is not allowed to specify the text flag %
								 %for binary files.")
			else
				create mode.make (a_mode.count + 1)
				mode.append_string (a_mode)
				mode.append_character ('b')
			end
		ensure then
			binary_mode: is_binary_mode_specification (mode)
		end


end
