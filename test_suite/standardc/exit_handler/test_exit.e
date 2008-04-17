indexing

	description: "Test Standard C exit handling."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


deferred class

	TEST_EXIT

inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	STDC_CURRENT_PROCESS

	STDC_EXIT_SWITCH_ACCESSOR

	STDC_EXIT_HANDLER
		rename
			execute as on_exit
		end


feature

	test_install_and_exit is
		do
			exit_switch.install (Current)
			exit_switch.uninstall (Current)
			exit_switch.install (Current)
			exit (0)
		end


feature -- On exit

	on_exit is
		do
			print ("exiting%N")
			assert ("Exiting.", True)
		end


end
