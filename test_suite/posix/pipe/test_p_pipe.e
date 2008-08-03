indexing

	description: "Test Posix pipe."

  author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"

deferred class

	TEST_P_PIPE

inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions,
			execute as test_execute
		end

	POSIX_FORK_ROOT


feature

	pipe: POSIX_PIPE

	test_all is
		local
			stop_sign: Boolean
			word: INTEGER
		do
			-- Create pipe.
			create pipe.make

			-- Fork.
			fork (Current)
			-- close our side of the pipe, else pipe is never closed.
			pipe.fdout.close

			from
				stop_sign := False
				word := 1
			until
				stop_sign
			loop
				debug
					print ("####%N")
				end
				pipe.fdin.read_line
				debug
					print (pipe.fdin.last_string)
				end
				inspect word
				when 1 then
					assert_equal ("Got line.", sentence, pipe.fdin.last_string)
				when 2 then
					assert_equal ("Got stop.", third_word, pipe.fdin.last_string)
				end
				stop_sign := equal(pipe.fdin.last_string, "stop")
				word := word + 1
			end

			-- Wait for child to terminate.
			wait

			pipe.close
		end


feature -- forked child

	execute is
		do
			pipe.fdin.close
			pipe.fdout.write_string (first_word)
			pipe.fdout.write_string (second_word)
			-- give reader sometime to read above strings first
			sleep (2)
			pipe.fdout.write_string (third_word)
			-- when we exit, our pipe is automatically closed, so parent gets eof
			-- pipe.fdout.close
		end

feature {NONE} -- Once strings

	first_word: STRING is "hello "
	second_word: STRING is "world.%N"
	third_word: STRING is "stop"
	sentence: STRING is "hello world."

end
