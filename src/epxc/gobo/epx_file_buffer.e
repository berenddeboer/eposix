note

	description: "Lexical analyzer input file buffers for STDC_FILE."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	EPX_FILE_BUFFER


inherit

	YY_FILE_BUFFER
		redefine
			content,
			file,
			fill,
			name,
			new_default_buffer
		end


create

	make,
	make_with_size


feature -- Access

	name: STRING
			-- Name of buffer.
		do
			Result := file.name
		end

	content: EPX_CHARACTER_BUFFER
			-- Input buffer characters.

	file: STDC_TEXT_FILE
			-- Input file. Should have buffering disabled.


feature -- Element change

	fill
			-- Fill buffer with characters from `file'.
			-- Do not lose unprocessed characters in buffer.
			-- Resize buffer if necessary. Set `filled' to True if
			-- characters have been added to buffer.
		local
			buff: like content
			bytes: INTEGER
		do
			-- If the last call to `fill' failed to add more characters,
			-- this means that the end of file has already been
			-- reached. Do not attempt to fill again the buffer in that
			-- case.
			if filled and not end_of_file then
				-- First move last characters to start of buffer
				-- and eventually resize `content' if necessary.
				compact_left
				buff := content
				-- Read in more data.
				-- It's best to read in blocks divisible by 512 bytes
				bytes := capacity - count
				bytes := (bytes // 512) * 512
					check
						bytes_positive: bytes >= 0
					end
				file.read_buffer (buff, count, bytes)
				if not file.end_of_input then
					count := count + file.last_read
					filled := True
				else
					filled := False
					end_of_file := True
				end
				buff.put (End_of_buffer_character, count + 1)
				buff.put (End_of_buffer_character, count + 2)
			else
				filled := False
			end
		end


feature {NONE} -- Implementation

	new_default_buffer (a_number_of_bytes: INTEGER): like content
			-- Create a new buffer that is like `content'.
		do
			create Result.make (a_number_of_bytes)
		end


invariant

	default_capacity_large_enough: Read_buffer_capacity >= 512

end
