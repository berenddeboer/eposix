indexing

	description: "Body that is stored in a file."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"

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
			file := new_file
		end


feature -- Access to body content

	as_string: STRING is
			-- Contents of `file'.
		local
			buf: STDC_BUFFER
		do
			-- Should be precondition, not sure how to do that
				check
					file_open_for_read: file.is_open_read
				end
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
			-- can't test
			-- file_position_at_beginning: file.tell = 0
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
			file.put_character (c)
		end

	append_string (s: STRING) is
			-- Extend `file' with `s' somehow.
		do
			file.put_string (s)
		end


feature -- Access

	file: EPX_CHARACTER_IO_STREAM
			-- The body as a file


feature {NONE} -- Implementation

	new_file: like file is
		do
			create {STDC_TEMPORARY_FILE} Result.make
		ensure
			not_void: Result /= Void
		end


invariant

	file_not_void: file /= Void
	file_open_for_writing: file.is_open_write
	file_rewindable: file.is_rewindable

end
