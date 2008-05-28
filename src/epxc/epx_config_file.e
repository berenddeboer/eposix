indexing

	description: "Basic configuration file reader. Configuration files%
	%are text files with possible lines with comments in them.%
	%Comment line (start with # or ;) are skipped by this class."

	author: "Berend de Boer"
	date: "$Date: 2002/02/06 $"
	revision: "$Revision: #2 $"

class

	EPX_CONFIG_FILE


inherit

	ANY

	EPX_FACTORY
		export
			{NONE} all;
			{ANY} fs
		end


create

	make


feature -- Initialization

	make (a_filename: STRING) is
			-- Open `a_filename' for reading.
		require
			readable: fs.is_readable (a_filename)
		do
			create file.open_read (a_filename)
			line_number := 0
		end


feature -- Status

	eof: BOOLEAN is
		obsolete "2007-01-26: use `end_of_input' instead"
		do
			Result := end_of_input
		end

	end_of_input: BOOLEAN is
			-- End of input?
		do
			Result := not file.is_open or else file.end_of_input
		end

	is_key_value_line: BOOLEAN is
			-- Does `last_line' look like "key = value"
		require
			not_end_of_input: not end_of_input
		do
			key_value_regexp.match (last_line)
			Result := key_value_regexp.has_matched
			key_value_regexp.wipe_out
		end


feature -- Access

	key: STRING
			-- Key found in line, set by `split_on_equal_sign'

	last_line: STRING is
		require
			not_end_of_input: not end_of_input
		do
			Result := file.last_string
		end

	line_number: INTEGER
			-- Current line number

	value: STRING
			-- Value found in line, set by `split_on_equal_sign'


feature -- Reading

	read_line is
			-- Read the next non-comment line.
		do
			from
				do_read_line
			until
				file.end_of_input or else not is_comment
			loop
				do_read_line
			end
			if file.end_of_input then
				file.close
			end
		ensure
			not_comment: end_of_input or else not is_comment
		end

	split_on_equal_sign is
			-- Assume `last_line' is of the format 'key = value', and
			-- split the line into its two components.
		require
			not_end_of_input: not end_of_input
			is_key_value_line: is_key_value_line
		do
			key_value_regexp.match (last_line)
				check
					matched: key_value_regexp.has_matched
				end
			key := key_value_regexp.captured_substring (1)
			key.right_adjust
			value := key_value_regexp.captured_substring (2)
			value.right_adjust
			key_value_regexp.wipe_out
		end


feature {NONE} -- Implementation

	do_read_line is
		require
			not_end_of_input: not end_of_input
		local
			c: CHARACTER
			i: INTEGER
			is_blank: BOOLEAN
		do
			line_number := line_number + 1
			file.read_line

			-- remove leading blanks
			from
				i := 1
				is_blank := True
			until
				not is_blank or else
				i > file.last_string.count
			loop
				c := file.last_string.item (i)
				is_blank := c = ' ' or else c = '%T'
				i := i + 1
			end
			if not is_blank and then i > 2 then
				file.last_string.keep_tail (i - 2)
			end

			-- remove trailing blanks
			from
				i := file.last_string.count
				is_blank := True
			until
				i = 0 or else
				not is_blank
			loop
				c := file.last_string.item (i)
				is_blank := c = ' ' or else c = '%T'
				i := i - 1
			end
			if not is_blank then
				file.last_string.keep_head (i + 1)
			end
		end

	file: STDC_TEXT_FILE
			-- Configuration file

	is_comment: BOOLEAN is
			-- Is last line read a comment?
			-- Empty lines count as comment too.
		do
			Result :=
				file.last_string.count = 0 or else
				file.last_string.item (1) = '#' or else
				file.last_string.item (1) = ';'
		end

	key_value_regexp: RX_PCRE_REGULAR_EXPRESSION is
		-- regepx that matches "key = value" lines
		once
			create Result.make
			Result.compile ("^[ \t]*([^=]+)=[ \t]*(.*)$")
		ensure
			not_void: Result /= Void
			compiled: Result.is_compiled
		end


invariant

	line_number_not_negative: line_number >= 0

end
