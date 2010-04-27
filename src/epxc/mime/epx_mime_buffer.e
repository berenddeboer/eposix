indexing

	description:

		"Lexical analyzer input buffer which can detect separation between header and body of request, and not read more than necessary to prevent blocking. It also supports reading just Content-Length bytes from the input stream and it supports Transfer-Encoding: chunked. Especially supporting the latter made this class quite unreadable. My humble apologies."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"

class

	EPX_MIME_BUFFER


inherit

	EPX_STREAM_BUFFER
		redefine
			fill,
			max_bytes_to_read,
			wipe_out
		end

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		end


create

	make,
	make_with_size


feature -- Status

	end_of_file_on_end_of_header: BOOLEAN
			-- If empty line read, return end of file?

	chunk_encoding_error: BOOLEAN
			-- Was there an error decoding the chunks?

	is_chunk_encoded: BOOLEAN is
		do
			Result := chunk_expect_size or else chunk_expect_end_of_chunk
		end

	is_valid_position (a_position: INTEGER): BOOLEAN is
			-- Is `a_position' a valid position in this buffer?
		do
			Result := a_position >= 1 and then a_position <= count + 1
		end


feature -- Buffer behaviour

	read_headers_after_chunk is
			-- Reset state so we can pick up the headers after all chunks
			-- have been read.
		do
			filled := True
			end_of_file := False
			chunk_expect_size := False
			chunk_expect_end_of_chunk := False
			chunk_start := 0
		ensure
			no_chunks_anymore: not chunk_expect_size
			no_end_of_chunk_anymore: not chunk_expect_end_of_chunk
			not_end_of_input: not end_of_file
		end

	set_end_of_file_on_end_of_header (enable: BOOLEAN) is
			-- Set `end_of_file_on_end_of_header'.
		do
			end_of_file_on_end_of_header := enable
			consecutive_end_of_lines := 0
			end_of_file := False
		ensure
			end_of_file_on_end_of_header_set: end_of_file_on_end_of_header = enable
			not_end_of_input: not end_of_file
		end

	set_end_of_file_on_content_length (a_content_length: INTEGER) is
			-- Set `end_of_file_on_content_length'.
			-- Buffer may already contain characters that have to be
			-- returned first, so `index' should indicate the position in
			-- the buffer that has been read up to now.
		require
			content_length_not_negative: a_content_length >= 0
		local
			remaining_characters_in_buffer: INTEGER
		do
			remaining_characters_in_buffer := (count - index) + 1
			if remaining_characters_in_buffer > a_content_length then
				-- It would perhaps be better if I returned `end_of_file'
				-- and shuffled the remaining characters back in the
				-- input, but I don't know if that's possible nor if that
				-- is desirable. Because what do those characters after
				-- Content-Length actually mean? Content-Length shouldn't
				-- appear inside a multipart message, or can it?
				fix_garbage_after_content_length (index + a_content_length - 1)
				content_left_to_read := 0
			else
				content_left_to_read := a_content_length - remaining_characters_in_buffer
			end
			-- We have to set `end_of_file' in case we already have
			-- everything in the buffer there is to read. Upon the next
			-- `fill' we will return end-of-file.
			end_of_file := content_left_to_read = 0
			end_of_file_on_end_of_header := False
		ensure
			end_of_file_on_content_length: content_left_to_read <= a_content_length
		end

	set_transfer_encoding_chunked is
			-- Assume the message body is encoded to the "chunked"
			-- Transfer-Encoding.
			-- `index' should point to the first character in the buffer
			-- that has not been read.
		require
			header_read: not end_of_file_on_end_of_header
		do
			chunk_expect_size := True
			chunk_expect_end_of_chunk := False
			chunk_left_to_read := 0
			content_left_to_read := 0
			chunk_start := index
			saved_count := count
		ensure
			expect_chunk_size: chunk_expect_size
			not_expect_end_of_chunk_marker: not chunk_expect_end_of_chunk
		end


feature -- Element change

	fill is
			-- Read next data from buffer. Also handle chunks, if chunked
			-- transfer encoding is used. Also don't read more than
			-- Content-Length if this has been set.
			-- This feature is quite complex because it tries to hide
			-- from the upper layer a couple of things:
			-- 1. Scanning ahead in order to stop properly after having
			--    read the end of the header
			-- 2. Stop after having read Content-Length bytes.
			-- 3. Decode chunked encoding.
		local
			c: CHARACTER
			i: INTEGER
			fill_needed: BOOLEAN
		do
			if chunk_expect_size then
				-- Cater for the fact that the chunk size could be
				-- somewhere in our buffer, but when we forced a refill,
				-- we had to let `index' point to the end of the
				-- buffer. So we correct `index' here.
				if chunk_start > 0 then
					index := chunk_start
					count := saved_count
					c := content.item (1)
					c := content.item (2)
				end
				-- If we have saved characters we need to put them back first.
				-- They only can overwrite `End_of_buffer_character's.
				if saved_character_1 /= '%U' then
						check
							overwrite_eob: content.item (index) = End_of_buffer_character
						end
					content.put (saved_character_1, index)
				end
				if saved_character_2 /= '%U' then
						check
							overwrite_eob: content.item (index + 1) = End_of_buffer_character
						end
					content.put (saved_character_2, index + 1)
				end
				-- Magic markers could be overwritten, so put them back
				if saved_character_1 /= '%U' and saved_character_2 /= '%U' then
					mark_end_of_input (count + 1)
				end
				if chunk_expect_end_of_chunk then
					-- If we come here after having read a chunk, the chunk
					-- ends with CRLF (or just LF). In that case, skip past this.
					read_end_of_chunk_marker
				end
				-- content.item (index) should now point to a digit.
				read_chunk_size
				-- If there is an error, `chunk_left_to_read' is set to
				-- zero as well.
				end_of_file := chunk_left_to_read = 0
				filled := not end_of_file
				-- Skip the fill if there is still stuff in the input
				-- buffer. This can happen because we have reset `index'
				-- when reading the first chunk.
				if not end_of_file then
					fill_needed := index > count
					if not fill_needed then
						-- In this case we also need to correct `count' and
						-- `chunk_left_to_read'.
						-- We don't need to save the original count, we
						-- already did so in `set_transfer_encoding_chunked'.
						count := index + chunk_left_to_read - 1
						-- `count' could now point the last character in our buffer.
						if count > saved_count then
							-- If so, set it to `saved_count' and we're done.
							chunk_left_to_read := count - saved_count
							count := saved_count
							saved_character_1 := '%U'
							saved_character_2 := '%U'
							-- And `saved_count' is now no longer needed as
							-- subsequent fills will only read chunk size
							-- amount.
							saved_count := 0
						else
							-- Else `count' points now somewhere in our buffer.
							-- But that implies we need two
							-- `End_of_buffer_character's after `count' as
							-- well.
							-- These saved characters should be the CRLF at
							-- the end of the chunk, or just LF + the first
							-- digit of the next chunk size.
							saved_character_1 := content.item (count + 1)
							saved_character_2 := content.item (count + 2)
							mark_end_of_input (count + 1)
							-- And on our next call to `fill' we will expect
							-- another chunk size.
							chunk_expect_size := True
							chunk_left_to_read := 0
						end
					end
				end
			else
				fill_needed := True
			end
			if fill_needed then
				precursor
				if not end_of_file then
					if end_of_file_on_end_of_header then
						from
							i := 0
						until
							consecutive_end_of_lines = 2 or else
							i = count
						loop
							c := content.peek_character (i)
							inspect c
							when '%R' then
								--ignore
							when '%N' then
								consecutive_end_of_lines := consecutive_end_of_lines + 1
							else
								consecutive_end_of_lines := 0
							end
							i := i + 1
						end
						end_of_file := consecutive_end_of_lines = 2
					else
						if chunk_left_to_read > 0 then
							chunk_left_to_read := chunk_left_to_read - file.last_read
							if chunk_left_to_read = 0 then
								chunk_expect_size := True
							end
						end
						if content_left_to_read > 0 then
							content_left_to_read := content_left_to_read - file.last_read
							end_of_file := content_left_to_read = 0
						end
					end
				end
			end
		end

	wipe_out is
		do
			precursor
			chunk_expect_size := False
			chunk_left_to_read := 0
			content_left_to_read := 0
			end_of_file_on_end_of_header := False
			chunk_encoding_error := False
		ensure then
			no_error: not chunk_encoding_error
		end


feature {NONE} -- Implementation

	consecutive_end_of_lines: INTEGER
			-- The number of consecutive %R%N (or just %N)'s that been seen in
			-- the input so far

	content_left_to_read: INTEGER
			-- How many bytes are remaining in the input stream?

	fix_garbage_after_content_length (a_new_count: INTEGER) is
			-- There is some shit out there, guess the
			-- manufacturer, that sends more than Content-Length.
			-- That would cause `bytes_read' to become larger than
			-- `content_length'. If that is going to be the case, call
			-- this routine.
			-- Note that we assume that Content-Length is correct, and
			-- that any more characters are basically garbage.
		require
			newcount_less_than_count: a_new_count < count
		do
			count := a_new_count
			mark_end_of_input (count + 1)
		ensure
			end_marked: content.item (count + 1) =  End_of_buffer_character
			end_marked: content.item (count + 2) =  End_of_buffer_character
		end

	mark_end_of_input (a_position: INTEGER) is
			-- Mark `a_position' as the end of input, see comment in
			-- YY_BUFFER.`flush'.
		do
			content.put (End_of_buffer_character, a_position)
			content.put (End_of_buffer_character, a_position + 1)
		end

	max_bytes_to_read: INTEGER is
			-- The maximum number of bytes that should be read by `fill'
		do
			Result := precursor
			if chunk_left_to_read > 0 then
				if Result > chunk_left_to_read then
					Result := chunk_left_to_read
				end
			end
			if content_left_to_read > 0 then
				if Result > content_left_to_read then
					Result := content_left_to_read
				end
			end
		ensure then
			never_read_more_than_content: content_left_to_read > 0 implies Result <= content_left_to_read
			never_read_more_than_chunk: chunk_left_to_read > 0 implies Result <= chunk_left_to_read
		end


feature {NONE} -- Chunked encoding implementation

	chunk_end_of_input: BOOLEAN is
			-- Is there no more input data in `content' nor in `file'?
		do
			Result :=
				index > count and then
				file.end_of_input
		end

	chunk_expect_size: BOOLEAN
			-- Are we expecing the chunk size line or the chunk itself?

	chunk_expect_end_of_chunk: BOOLEAN
			-- Are we expecting to see the CRLF marking the end of the chunk data?

	chunk_last_character: CHARACTER
			-- Last character returned by `chunk_read_character'

	chunk_left_to_read: INTEGER
			-- How many bytes are remaining in the input stream for the current chunk?

	chunk_read_character is
			-- Read a character from `content' or if that is empty, from `file'.
		require
			not_end_of_input: not chunk_end_of_input
		do
			if index > count then
				file.read_character
				chunk_last_character := file.last_character
			else
				chunk_last_character := content.item (index)
				index := index + 1
			end
		ensure
			index_advanced: old index <= count implies index = old index + 1
		end

	chunk_start: INTEGER
			-- Where in buffer does chunk start?


	read_chunk_size is
			-- Read the chunk size for Transfer-Encoding chunked.
			-- TODO: should quit early when reading a size that is
			-- clearly out of bounds.
		require
			reading_chunk_size: chunk_expect_size
		local
			chunk_size_line_read: BOOLEAN
			chunk_size: STRING
		do
			-- Read size of chunk first. Chunk size can either be
			-- fully in buffer already read, or still in stream, or
			-- partly in both, so cater for all these situations.
			from
				chunk_size := ""
				chunk_read_character
				-- There really should be a digit now if the stream is correct.
				-- The last chunk has size 0.
			until
				chunk_end_of_input or else
				chunk_last_character = '%N'
			loop
				if chunk_last_character /= '%R' then
					chunk_size.append_character (chunk_last_character)
				end
				chunk_read_character
			end
			chunk_size_line_read := chunk_last_character = '%N'
			if chunk_size_line_read then
				if STRING_.is_hexadecimal (chunk_size) then
					chunk_left_to_read := STRING_.hexadecimal_to_integer (chunk_size)
					if chunk_start > 0 then
						-- Set where the next chunk starts in our buffer
						chunk_start := index + chunk_left_to_read
						-- But that could be past the last character in our
						-- buffer, in which case we can start relying on
						-- `index' being correct again.
						if chunk_start > count then
							chunk_start := 0
						end
					end
				else
					-- Something wrong, should have gotten hex octets, so
					-- signal end-of-file. And set parse error.
					chunk_encoding_error := True
					chunk_left_to_read := 0
				end
			else
				-- We should have gotten a size
				chunk_encoding_error := True
				chunk_left_to_read := 0
			end
			chunk_expect_size := False
			chunk_expect_end_of_chunk := True
		ensure
			no_size_expected: not chunk_expect_size
			after_chunk_read_end_of_chunk_marker: chunk_expect_end_of_chunk
			nothing_to_read_after_error: chunk_encoding_error implies chunk_left_to_read = 0
		end

	read_end_of_chunk_marker is
			-- Read the CRLF after the chunk data.
		do
			from
				chunk_read_character
			until
				chunk_end_of_input or else
				chunk_last_character = '%N'
			loop
				chunk_encoding_error := chunk_last_character /= '%R'
				chunk_read_character
			end
		end

	saved_character_1,
	saved_character_2: CHARACTER
			-- When `force_fill' is called, buffer contents is
			-- overwritten. They are saved in these characters, so can be
			-- used by `fill'.

	saved_count: INTEGER
			-- We play around with `count' when handling chunked
			-- transfers, we need this value to restore it to its
			-- original value.


invariant

	chunk_left_to_read_not_negative:	chunk_left_to_read >= 0
	content_left_to_read_not_negative: content_left_to_read >= 0
	only_one_tricked_eof_active: not (end_of_file_on_end_of_header and content_left_to_read > 0)

	chunk_start_valid: chunk_start >= 0 and chunk_start <= capacity
	saved_count_valid: saved_count >= 0 and saved_count <= capacity
	chunk_start_implies_size_on_next_fill: not end_of_file implies (chunk_start > 0 implies chunk_expect_size)

	consecutive_end_of_lines_not_negative: consecutive_end_of_lines >= 0

end
