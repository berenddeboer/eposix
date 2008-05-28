class EX_EXEC1

inherit

	EPX_CURRENT_PROCESS

create

	make

feature

	make is
		local
			ls: EPX_EXEC_PROCESS
		do
			-- list contents of current directory
			create ls.make_capture_output ("ls", <<"-1", ".">>)
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

			-- close captured io
			ls.fd_stdout.close

			-- wait for process
			ls.wait_for (True)
		end

end
