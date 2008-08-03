indexing

	description: "Test Posix terminal access classes."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	TEST_P_TERMINAL


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	POSIX_CURRENT_PROCESS


feature

	test_all is
			-- Testing Posix terminal interface.
		do
			stdout.write_string ("Password: ")
			stdout.flush

			-- turn off echo
			fd_stdin.terminal.set_echo_input (False)
			fd_stdin.terminal.apply_flush

			-- read password
			fd_stdin.read_string (256)

			-- turn echo back on
			fd_stdin.terminal.set_echo_input (True)
			fd_stdin.terminal.apply_now

			print ("%NYour password was: ")
			print (fd_stdin.last_string)
		end

end
