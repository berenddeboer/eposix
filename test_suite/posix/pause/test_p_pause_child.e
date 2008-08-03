indexing

	description: "POSIX pause child."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

class

	TEST_P_PAUSE_CHILD


inherit

	POSIX_FORK_ROOT
		rename
			exceptions as test_exceptions
		end

	POSIX_SIGNAL_HANDLER


create

	make


feature

	make is
		do
		end


feature -- forked child

	execute is
		local
			signal: POSIX_SIGNAL
		do
			create signal.make (SIGHUP)
			signal.set_handler (Current)
			signal.apply
			print ("Child starts to sneeze...%N")
			pause
			print ("Paused for: ")
			print (clock)
			print (" clock ticks.%N")
		end


feature {NONE} -- Signal handler

	signalled (signal_value: INTEGER) is
		do
			-- do nothing
		end

end
