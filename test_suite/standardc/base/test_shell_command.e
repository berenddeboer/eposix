indexing

	description: "Test SHELL_COMMAND class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

deferred class

	TEST_SHELL_COMMAND

inherit

	TS_TEST_CASE

feature

	test_all is
			-- Test executing shell commands.
		local
			command: STDC_SHELL_COMMAND
		do
			create command.make ("/bin/ls *")
			command.execute
			debug
				print ("Exit code: ")
				print (command.exit_code)
				print ("%N")
			end

			create command.make ("/bin/rm /tmp/xxQQzz")
			command.execute
			assert ("Failure detected.", command.exit_code /= 0)
		end

end
