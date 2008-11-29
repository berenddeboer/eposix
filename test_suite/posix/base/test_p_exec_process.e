indexing

	description: "Test POSIX exec process class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	TEST_P_EXEC_PROCESS

inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	POSIX_CURRENT_PROCESS


feature -- Tests

	test_input is
			-- Test input capturing using a stream.
		local
			more: POSIX_EXEC_PROCESS
			i: INTEGER
		do
			create more.make_capture_input ("less", Void)
			-- create more.make_capture_input ("more", Void)
			more.execute
			from
				i := 0
			until
				i = 25
			loop
				more.stdin.put_string (i.out)
				more.stdin.put_character ('%N')
				i := i + 1
			end

			-- send EOF to more so it will exit
			-- we can't close a stream, so we close the descriptor instead.
			more.stdin.flush
			more.fd_stdin.close

			-- wait for more to terminate
			more.wait_for (True)
		end

	test_kill is
			-- Test kill on the mail program.
		local
			mail: POSIX_EXEC_PROCESS
			signal: POSIX_SIGNAL
		do
			-- we first have to turn off the (Small)Eiffel signal
			-- handling, this should move to forked process??
			create signal.make (SIGTERM)
			signal.set_default_action
			signal.apply

			create mail.make ("sendmail", <<"berend">>)
			mail.set_capture_error (True)
			mail.execute
			mail.wait_for (False)
			assert ("Status not yet available.", not mail.is_terminated)
			mail.terminate
			mail.wait_for (True)
			-- mail terminated normally. (error or due to Eiffel
			-- exception handling? Works sometimes...
			assert ("Mail not terminated normally.", not mail.is_terminated_normally)
			assert ("Mail was signalled.", mail.is_signalled)
			assert_equal ("Signal is signal we send.", SIGTERM, mail.signal_code)
		end

	test_exit_code is
		local
			test: POSIX_EXEC_PROCESS
		do
			create test.make ("./test.sh", Void)
			test.execute
			test.wait_for (True)
			assert ("test.sh terminated normally.", test.is_terminated_normally)
			assert ("test.sh not signalled.", not test.is_signalled)
			assert_integers_equal ("test.sh exit code.", 10, test.exit_code)
		end

end
