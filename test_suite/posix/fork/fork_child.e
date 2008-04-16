indexing

	description: "Child for Posix fork test."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"

class

	FORK_CHILD


inherit

	POSIX_FORK_ROOT


feature

	execute is
		local
			writer: POSIX_TEXT_FILE
		do
			debug ("test")
				print (" FORK_CHILD execute%N")
			end
			create writer.open ("berend.tmp", "w")
			debug ("test")
				print ("FORK_CHILD fifo opened%N")
			end
			writer.write_string ("first%N")
			debug ("test")
				print ("FORK_CHILD first string written%N")
			end
			writer.write_string ("stop%N")
			debug ("test")
				print ("FORK_CHILD second string written%N")
			end
			writer.close
			debug ("test")
				print ("FORK_CHILD fifo closed%N")
			end

			-- we give the reader some time to process these messages
			sleep (5)
		end

end
