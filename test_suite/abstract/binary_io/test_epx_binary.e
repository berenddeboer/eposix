indexing

	description: "Test binary std i/o."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	TEST_EPX_BINARY


inherit

	TS_TEST_CASE

	EPX_CURRENT_PROCESS


feature -- Tests

	test_all is
		local
			buf: STDC_BUFFER
			bytes_read: INTEGER
		do
			fd_stdout ("Supply this utility with input on stdin!%N")
			fd_stdout ("Example:%N")
			fd_stdout ("./eposix_test < chicken.bmp 2> test.bmp%N")
			create buf.allocate (512)
			from
				fd_stdin.read_buffer (buf, 0, 512)
			until
				fd_stdin.eof
			loop
				bytes_read := bytes_read + fd_stdin.last_read
				fd_stderr.write_buffer (buf, 0, fd_stdin.last_read)
				fd_stdin.read_buffer (buf, 0, 512)
			end
			fd_stderr.write_buffer (buf, 0, fd_stdin.last_read)
			bytes_read := bytes_read + fd_stdin.last_read
		end


end
