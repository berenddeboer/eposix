note

	description: "Lexical analyzer input file buffers for descendants of EPX_CHARACTER_INPUT_STREAMs."

	author: "Berend de Boer"


class

	EPX_STREAM_BUFFER


inherit

	YY_FILE_BUFFER
		redefine
			content,
			file,
			fill,
			new_default_buffer,
			set_string
		end


create

	make,
	make_with_size


feature -- Access

	content: EPX_CHARACTER_BUFFER
			-- Input buffer characters

	file: EPX_CHARACTER_INPUT_STREAM
			-- Input file


feature -- Element change

	fill
			-- Fill buffer with characters from `file'.
			-- Do not lose unprocessed characters in buffer.
			-- Resize buffer if necessary. Set `filled' to True if
			-- characters have been added to buffer.
		local
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
				-- Read in more data.
				bytes := max_bytes_to_read
				if not file.end_of_input and then file.errno.is_ok then
					file.read_buffer (content, count, bytes)
				end
				if not file.end_of_input and then file.errno.is_ok then
					count := count + file.last_read
					filled := True
				else
					filled := False
					end_of_file := True
				end
				content.put (End_of_buffer_character, count + 1)
				content.put (End_of_buffer_character, count + 2)
			else
				filled := False
			end
		end


feature -- Setting

	set_string (a_string: STRING)
			-- Not supported.
		do
			end_of_file := True
			-- Precursor {YY_BUFFER} (a_string)
			filled := False
		end


feature {NONE} -- Implementation

	max_bytes_to_read: INTEGER
			-- The maximum number of bytes that should be read by `fill'
		do
			Result := capacity - count
			if not file.is_streaming then
				-- For disk files, it's best to read in blocks
				-- divisible by 512 bytes
				if Result > 512 then
					Result := (Result // 512) * 512
				end
			end
		ensure
			not_negative: Result >= 0
			enough_capacity: Result <= capacity - count
		end

	new_default_buffer (a_number_of_bytes: INTEGER): like content
			-- Create a new buffer that is like `content'.
		do
			create Result.make (a_number_of_bytes)
		end


end
