class EX_FILE2

create

	make

feature

	chunk_size: INTEGER is 512

	make is
		local
			file: POSIX_BINARY_FILE
			buffer: POSIX_BUFFER
		do
			create file.open_read ("/bin/sh")
			create buffer.allocate (chunk_size)
			from
				file.read_buffer (buffer, 0, chunk_size)
			until
				file.end_of_input
			loop
				file.read_buffer (buffer, 0, chunk_size)
			end
			file.close
		end

end
