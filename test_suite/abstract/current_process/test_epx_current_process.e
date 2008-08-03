indexing

	description: "Test epx current process."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	TEST_EPX_CURRENT_PROCESS


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	EPX_CURRENT_PROCESS


feature

	test_all is
		do
			-- on Windows we seem to have to use stdout as our first output
			-- else it will not be redirected by shell pipes
			stdout.put_string ("Test epx current process.%N")

			print ("Test sleep before.%N")
			sleep (1)
			print ("Test sleep after.%N")

			assert("fd_stdin attached to terminal.", fd_stdin.is_attached_to_terminal)

			print ("Test redirecting stderr. Capture stdout to see difference.%N")
			-- flush stream buffers, else output may be in wrong order
			stdout.flush
			stderr.flush
			fd_stderr.make_as_duplicate (fd_stdout)
			fd_stdout.put_string ("hello world through fd stdout.%N")
			fd_stderr.put_string ("hello world through fd stderr.%N")
			stdout.put_string ("hello world through stream stdout.%N")
			stderr.put_string ("hello world through stream stderr.%N")
		end


end
