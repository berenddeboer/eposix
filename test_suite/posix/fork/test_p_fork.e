indexing

	description: "Test Posix mkfifo and forking."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"

deferred class

	TEST_P_FORK


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	POSIX_CURRENT_PROCESS
		export
			{NONE} all
		end

	POSIX_FILE_SYSTEM
		export
			{NONE} all
		end

	POSIX_SYSTEM
		export
			{NONE} all
		end


feature -- Tests

	test_fork is
		do
			if system_name.substring_index ("CYGWIN", 1) = 0 then
				do_test_fork
			else
				print ("fifo not supported on Cygwin, can't test forking.%N")
			end
		end


feature {NONE} -- Implementation

	do_test_fork is
		local
			reader: POSIX_TEXT_FILE
			stop_sign: BOOLEAN
			child: FORK_CHILD
		do
			debug ("test")
				print ("My pid: ")
				print (pid)
				print ("%N")
			end

			unlink ("berend.tmp")
			debug ("test")
				print ("Make a fifo.%N")
			end
			create_fifo ("berend.tmp", S_IRUSR + S_IWUSR)
			create child
			print ("Fork object.%N")
			fork (child)
			debug ("test")
				print ("child pid: ")
				print (child.pid)
				print ("%N")
			end
			assert ("PID valid", child.is_child_pid_valid)

			-- we will now block until file is opened for writing.
			debug ("test")
				print ("TEST_P_FORK: before open%N")
			end
			create reader.open_read ("berend.tmp")
			debug ("test")
				print ("TEST_P_FORK: after open%N")
			end
			from
				stop_sign := False
			until
				stop_sign
			loop
				debug ("test")
					print ("TEST_P_FORK: read_line%N")
				end
				reader.read_line
				print (reader.last_string)
				stop_sign := equal (reader.last_string, "stop")
			end
			reader.close

			-- now wait for the writer to terminate
			child.wait_for (True)

			unlink ("berend.tmp")
		end

end
