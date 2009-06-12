indexing

	description: "Test POSIX file class."

	Bugs: "1. Assumes 8 bit characters."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	TEST_P_FILE

inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	POSIX_CURRENT_PROCESS

	POSIX_FILE_SYSTEM


feature -- Tests

	test_make_from_file is
		local
			file: POSIX_TEXT_FILE
			fd: POSIX_FILE_DESCRIPTOR
		do
			create file.open_append ("test.berend")
			create fd.make_from_file (file)
			debug
				print ("fildes: ")
				print (fd.value)
				print ("%N")
			end
			file.close
		end

	test_make_from_file_descriptor is
		local
			file: POSIX_TEXT_FILE
			fd: POSIX_FILE_DESCRIPTOR
		do
			create fd.open_read ("test.berend")
			create file.make_from_file_descriptor (fd, "r")
			file.close
			remove_file ("test.berend")
		end

	test_wait_for_input is
		local
			timed_fin: POSIX_TIMED_FIN_CHARACTER
		do
			create timed_fin.make (5, stdin)
			if timed_fin.is_signal_alarm_handled then
				print ("Type a character or wait 5s for time-out: ")
				if timed_fin.execute then
					print ("no timeout.%N")
				else
					print ("timeout.%N")
				end
			else
				print ("!! Alarm doesn't raise an exception.%N")
			end
		end

	test_create_temporary_file is
		local
			tmpfile: POSIX_TEMPORARY_FILE
		do
			create tmpfile.make
			tmpfile.puts ("hello%N")
			tmpfile.close
		end

	test_read is
			-- test reading bytes in chunks
		local
			chunk_size: INTEGER
			buf: POSIX_BUFFER
			fd: POSIX_BINARY_FILE
			file_size: INTEGER
			bytes_read: INTEGER
		do
			print ("Test reading chunks.%N")
			file_size := status ("/bin/sh").size
			print ("filesize: ")
			print (file_size)
			print ("%N")
			chunk_size := 512
			create buf.allocate (chunk_size)
			if is_readable ("/bin/sh.exe") then
				-- cygwin
				create fd.open_read ("/bin/sh.exe")
			else
				create fd.open_read ("/bin/sh")
			end
			from
				fd.read_buffer (buf, 0, chunk_size)
			until
				fd.end_of_input
			loop
				bytes_read := bytes_read + fd.last_read
				fd.read_buffer (buf, 0, chunk_size)
			end
			fd.close
			buf.deallocate
			assert_equal ("all bytes read.", file_size, bytes_read)
		end

end
