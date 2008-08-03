indexing

	description: "Test POSIX nonblocking i/o."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


deferred class

	TEST_P_NONBLOCK


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	POSIX_CONSTANTS

	POSIX_SYSTEM

	POSIX_CURRENT_PROCESS

	POSIX_FILE_SYSTEM


feature

	test_stdin is
			-- Test non-blocking i/o on `fd_stdin'.
		local
			i: INTEGER
			buf: STDC_BUFFER
		do
			assert ("stdin nonblocking i/o not enabled.", fd_stdin.is_blocking_io)
			fd_stdin.set_blocking_io (False)

			-- read with buffer
			from
				i := 0
				create buf.allocate_and_clear (32)
			until
				i = 5
			loop
				print (i)
				print ("%N")
				print ("Enter something and press Enter: ")
				fd_stdin.read_buffer (buf, 0, buf.capacity)
				if not fd_stdin.last_blocked then
					print ("Characters entered: ")
					print (fd_stdin.last_read)
					print ("%N")
					print ("You entered: ")
					print (buf.substring (0, fd_stdin.last_read - 1))
					print ("%N")
					i := 5
				else
					sleep (1)
					i := i + 1
				end
			end

			-- read string
			from
				i := 0
			until
				i = 5
			loop
				print (i)
				print ("%N")
				print ("Enter something and press Enter: ")
				fd_stdin.read_string (3)
				if not fd_stdin.last_blocked then
					print ("Characters entered: ")
					print (fd_stdin.last_read)
					print ("%N")
					print ("You entered: ")
					print (fd_stdin.last_string)
					print ("%N")
					i := 5
				else
					sleep (1)
					i := i + 1
				end
			end
		end


end
