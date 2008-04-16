indexing

	description: "eposix's file and socket classes (STDC_FILE, POSIX_FILE_DESCRIPTOR, SUS_SOCKET) all inherit from this class. This makes eposix plug compatible with Gobo and any other library using a KI_CHARACTER_OUTPUT_STREAM."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


deferred class

	EPX_CHARACTER_OUTPUT_STREAM


inherit

	STDC_BASE

	KI_CHARACTER_OUTPUT_STREAM
		undefine
			close
		redefine
			append
		end


feature -- Output

	append (an_input_stream: KI_INPUT_STREAM [CHARACTER]) is
			-- Read items of `an_input_stream' until the end
			-- of input is reached, and write these items to
			-- current output stream.
			-- `append' is safe for non-blocking descriptors.
		local
			epx_input_stream: EPX_CHARACTER_INPUT_STREAM
			buffer: STDC_BUFFER
			bytes_to_read,
			bytes_to_write: INTEGER
			read_offset,
			write_offset: INTEGER
		do
			errno.clear
			epx_input_stream ?= an_input_stream
			if epx_input_stream = Void then
				precursor (an_input_stream)
			else
				create buffer.allocate (8192)
				from
					read_offset := 0
					bytes_to_read := buffer.capacity
					epx_input_stream.read_buffer (buffer, read_offset, bytes_to_read)
				invariant
					read_offset >= 0 and read_offset <= buffer.capacity
					bytes_to_write >= 0 and bytes_to_write <= buffer.capacity
					bytes_to_read >= 0 and bytes_to_read <= buffer.capacity
					read_offset + bytes_to_read <= buffer.capacity
				until
					errno.is_not_ok or else
					epx_input_stream.end_of_input
				loop
					bytes_to_write := read_offset + epx_input_stream.last_read
					write_buffer (buffer, 0, bytes_to_write)
					bytes_to_write := bytes_to_write - last_written
					if bytes_to_write > 0 then
						buffer.move (last_written, 0, bytes_to_write)
						read_offset := bytes_to_write
					else
						read_offset := 0
					end
					bytes_to_read := buffer.capacity - read_offset
					epx_input_stream.read_buffer (buffer, read_offset, bytes_to_read)
				end
				-- Could still have stuff in buffer for non-blocking writes
				from
					bytes_to_write := read_offset + epx_input_stream.last_read
					write_offset := 0
				until
					errno.is_not_ok or else
					bytes_to_write = 0
				loop
					write_buffer (buffer, write_offset, bytes_to_write)
					bytes_to_write := bytes_to_write - last_written
					write_offset := write_offset + last_written
				end
				buffer.deallocate
			end
		end

	last_written: INTEGER is
			-- How many bytes were written by last call to write?
			-- Can be less than requested for non-blocking output.
			-- Check `last_blocked' in that case.
		deferred
		end

	put_buffer, write_buffer (buf: STDC_BUFFER; offset, nbytes: INTEGER) is
			-- Write data from `buf' position `offset' for `nbytes' bytes.
			-- Number of bytes actually written are available in `last_written'.
			-- `last_written' will be less than `nbytes' if non-blocking
			-- writes are in effect.
		require
			is_open_write: is_open_write
			nbytes_not_negative: nbytes >= 0
			offset_not_negative: offset >= 0
			buf_not_void: buf /= Void
			dont_write_garbage: buf.capacity >= offset + nbytes
		deferred
		ensure
			written_no_more_than_requested: last_written <= nbytes
		end

end
