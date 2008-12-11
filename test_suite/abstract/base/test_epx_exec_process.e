indexing

	description: "Test EPX exec process class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


deferred class

	TEST_EPX_EXEC_PROCESS


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	EPX_CURRENT_PROCESS


feature

	test_output is
			-- Test exec process itself by just doing an ls.
		local
			ls: EPX_EXEC_PROCESS
		do
			print ("My pid: ")
			print (pid)
			print ("%N")

			create ls.make ("ls", Void)
			ls.execute
			ls.wait_for (True)

			-- execute ls and print output
			create ls.make_capture_output ("ls", Void)
			ls.execute
			print ("ls pid: ")
			print (ls.pid)
			print ("%N")
			from
				ls.fd_stdout.read_string (512)
			until
				ls.fd_stdout.end_of_input
			loop
				print (ls.fd_stdout.last_string)
				ls.fd_stdout.read_string (512)
			end

			-- close stdout (needed?) and wait
			ls.fd_stdout.close
			ls.wait_for (True)
		end

	test_input is
			-- test input capturing
			-- more.com seems to be very unreliable...
		local
			more: EPX_EXEC_PROCESS
			i: INTEGER
		do
			create more.make_capture_input ("less", Void)
			-- create more.make_capture_input ("more", Void)
			more.execute
			print ("more pid: ")
			print (more.pid)
			print ("%N")
			sleep (3)
			from
				i := 0
			until
				i = 25
			loop
				more.fd_stdin.put_string (i.out)
				more.fd_stdin.put_string ("%N")
				i := i + 1
			end

			-- send EOF to more so it will exit
			more.fd_stdin.close

			-- wait for more to terminate
			more.wait_for (True)
		end

	test_pipe is
			-- Execute ls and pipe output to more
		local
			ls,
			more: EPX_EXEC_PROCESS
		do
			create ls.make_capture_output ("ls", Void)
			create more.make_capture_input ("less", Void)
			ls.execute
			print ("ls pid: ")
			print (ls.pid)
			print ("%N")
			more.execute
			print ("more pid: ")
			print (more.pid)
			print ("%N")
			from
				ls.fd_stdout.read_string (512)
			until
				ls.fd_stdout.end_of_input or else more.fd_stdin.end_of_input
			loop
				--print (ls.fd_stdout.last_string)
				more.fd_stdin.put_string (ls.fd_stdout.last_string)
				ls.fd_stdout.read_string (512)
			end

			-- close captured io for both processes
			ls.fd_stdout.close
			more.fd_stdin.close

			-- wait for both (!) processes
			ls.wait_for (True)
			more.wait_for (True)
		end

	test_exit_code is
		local
			ls: EPX_EXEC_PROCESS
		do
			create ls.make_capture_output ("ls", Void)
			ls.set_arguments (<<"QQ*">>)
			ls.execute
			ls.wait_for (True)
			assert_not_equal ("Exit failure.", EXIT_SUCCESS, ls.exit_code)
		end

	test_wait_for is
		local
			ls: EPX_EXEC_PROCESS
		do
			create ls.make_capture_output ("ls", Void)
			ls.set_arguments (<<"QQ*">>)
			ls.execute
			ls.wait_for (False)
			-- Tricky test, so no assert
			if not ls.is_terminated then
				debug
					print ("Status not yet available.")
				end
				ls.wait_for (True)
				assert ("Status available.", ls.is_terminated)
			end
			assert_not_equal ("Exit failure.", EXIT_SUCCESS, ls.exit_code)
		end

	test_fail is
		local
			rescued: BOOLEAN
			exec: EPX_EXEC_PROCESS
		do
			if not rescued then
				create exec.make ("/usr/local/bin/nonexistent", Void)
				exec.execute
				exec.wait_for (True)
				assert_not_equal ("Not existing program detected.", EXIT_SUCCESS, exec.exit_code)
			else
				assert ("Not existing program detected.", True)
			end
		rescue
			rescued := True
			retry
		end

end
