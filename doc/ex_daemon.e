class EX_DAEMON

inherit

	POSIX_DAEMON

	ARGUMENTS


create

	make

feature -- the parent

	make is
		do
			-- necessary under SmallEiffel
			ignore_child_stop_signal

			if argument_count = 0 then
				print ("Options:%N")
				print ("-d    start daemon%N")
			else
				if equal(argument(1), "-d") then
					detach
					print ("Daemon started.%N")
					print ("Its pid: ")
					print (last_child_pid)
					print ("%N")
				end
			end
		end

feature -- the daemon

	execute is
		do
			-- daemon stays alive for 20 seconds
			sleep (20)
		end

end
