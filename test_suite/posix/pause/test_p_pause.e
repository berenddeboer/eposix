indexing

	description: "Test Posix pause."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	TEST_P_PAUSE

inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	POSIX_CURRENT_PROCESS

feature

	test_sighup is
		local
			child: TEST_P_PAUSE_CHILD
		do
			create child.make
			fork (child)

			-- Wait a bit before sending signal.
			sleep (2)
			child.kill (SIGHUP)

			child.wait_for (True)
		end

end
