class EX_EXEC2

inherit

	POSIX_CURRENT_PROCESS

create

	make

feature

	make is
		local
			ls: POSIX_EXEC_PROCESS
		do
			-- list contents of current directory
			create ls.make_capture_output ("ls", <<"-1", ".">>)
			ls.execute
			print ("ls pid: ")
			print (ls.pid)
			print ("%N")
			from
				ls.stdout.read_string (512)
			until
				ls.stdout.end_of_input
			loop
				print (ls.stdout.last_string)
				ls.stdout.read_string (512)
			end

			-- close captured io
			ls.stdout.close

			-- wait for process
			ls.wait_for (True)
		end

end
