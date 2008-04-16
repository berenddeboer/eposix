indexing

	description: "Test SHELL_COMMAND class."

	author: "Berend de Boer"
	date: "$Date: 2003/11/29 $"
	revision: "$Revision: #1 $"

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
