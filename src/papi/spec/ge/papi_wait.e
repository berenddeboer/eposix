indexing

	description: "Class that covers Posix sys/wait.h."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

class

	PAPI_WAIT


feature -- C binding functions

	posix_wait (statloc: POINTER): INTEGER is
			-- Waits for process termination

		external "C blocking"



		end

	posix_waitpid(a_pid: INTEGER; statloc: POINTER options: INTEGER): INTEGER is
			-- Waits for process termination
		require
			valid_pid: a_pid > 0

		external "C blocking"



		end


feature -- C binding statloc evaluation

	posix_wexitstatus (a_value: INTEGER): INTEGER is
			-- Evaluates to the low-order eight bits of the `status'
			-- argument that the child passed to exit, or the value the
			-- child process returned from main.
		external "C"
		end

	posix_wifexited (a_value: INTEGER): BOOLEAN is
			-- Evaluates to a non-zero value if status was returned for
			-- a child that terminated normally
		external "C"
		end

	posix_wifsignaled (a_value: INTEGER): BOOLEAN is
			-- Evaluates to a non-zero value if status was returned for
			-- a child that terminated due to the receipt of a signal
			-- that was not caught
		external "C"
		end

	posix_wifstopped (a_value: INTEGER): BOOLEAN is
		external "C"
		end

	posix_wstopsig (a_value: INTEGER): BOOLEAN is
		external "C"
		end

	posix_wtermsig (a_value: INTEGER): INTEGER is
		external "C"
		end


feature -- waitpid contants

	WNOHANG: INTEGER is
			-- do not suspend execution
		external "C"
		alias "const_wnohang"
		end

	WUNTRACED: INTEGER is
			-- report status of childs that are stopped and whose status has not
			-- yet been reported since they stopped
		external "C"
		alias "const_wuntraced"
		end


end -- class PAPI_WAIT
