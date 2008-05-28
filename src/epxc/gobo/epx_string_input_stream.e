indexing

	description: "Stream that returns the contents of a string."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


class

	EPX_STRING_INPUT_STREAM


inherit

	KI_CHARACTER_INPUT_STREAM
		redefine
			is_rewindable,
			rewind,
			valid_unread_character
		end


create

	make


feature {NONE} -- Initialization

	make (a_value: STRING) is
			-- Initialize stream to return `a_value'.
		require
			value_not_void: a_value /= Void
		do
			value := a_value
			position := 0
			name := ""
		ensure
			value_set: value.is_equal (a_value)
		end


feature -- Input

	read_character is
			-- Read the next item in input stream.
			-- Make the result available in `last_item'.
		do
			position := position + 1
			if position <= value.count then
				last_character := value.item (position)
			end
		end

	read_string (nb: INTEGER) is
		local
			end_pos: INTEGER
		do
			if value.is_empty then
				last_string := ""
				position := 1
			else
				position := position + 1
				if position > value.count then
					last_string := ""
				else
					end_pos := nb.min (value.count - position + 1)
					last_string := value.substring (position, end_pos)
					position := end_pos
				end
			end
		end

	rewind is
			-- Return input from beginning of stream, if applicable.
		do
			position := 0
		end


feature -- Unreading

	unread_character (an_item: CHARACTER) is
		do
			-- ignore, not supported.
		end

	valid_unread_character (a_character: CHARACTER): BOOLEAN is
			-- Can `a_character' be put back in input stream?
		once
			-- We don't allow unreading.
			Result := False
		end


feature -- Status report

	is_rewindable: BOOLEAN is True
			-- Can this stream be restarted to return input from the beginning?

	end_of_input: BOOLEAN is
			-- Has the end of input stream been reached?
		do
			Result := position > value.count
		end

	is_open_read: BOOLEAN is True
			-- Can items be read from input stream?


feature -- Access

	last_character: CHARACTER

	last_string: STRING

	name: STRING
			-- Name of input stream


feature {NONE} -- Implementation

	position: INTEGER
			-- Next position in `value' to return by `read_character'.

	value: STRING
			-- String whose content is returned.


invariant

	position_not_negative: position >= 0
	value_not_void: value /= Void

end
