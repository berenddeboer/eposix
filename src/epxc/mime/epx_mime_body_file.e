indexing

	description: "Body that is stored in a file."

	author: "Berend de Boer"
	date: "$Date: 2007/05/17 $"
	revision: "$Revision: #5 $"

class

	EPX_MIME_BODY_FILE


inherit

	EPX_MIME_BODY_TEXT
		redefine
			as_string
		end


creation

	make


feature {NONE} -- Initialization

	make is
			-- Initialize text body.
		do
			create file.make
		end


feature -- Access to body content

	as_string: STRING is
			-- Return `file'.
		local
			buf: STDC_BUFFER
		do
			from
				file.rewind
				Result := ""
				create buf.allocate (8192)
			until
				file.end_of_input
			loop
				file.read_buffer (buf, 0, 8192)
				if file.last_read > 0 then
					buf.append_to_string (Result, 0, file.last_read - 1)
				end
				--Result.append_string (buf.substring (0, file.last_read - 1))
			end
			file.rewind
			buf.deallocate
		ensure then
			file_position_at_beginning: file.tell = 0
		end

	rewind_stream is
			-- Make sure `stream' starts returning character the
			-- beginning of the body.
		do
			file.rewind
		end

	stream: EPX_CHARACTER_INPUT_STREAM is
			-- Return a stream to the actual body.
		do
			Result := file
		end


feature -- Change body commands

	append_character (c: CHARACTER) is
			-- Extend `file' with `c' somehow.
		do
			file.write_character (c)
		end

	append_string (s: STRING) is
			-- Extend `file' with `s' somehow.
		do
			file.write_string (s)
		end


feature -- Access

	file: STDC_TEMPORARY_FILE
			-- The body as a file


invariant

	file_not_void: file /= Void
	file_open: file.is_open

end
