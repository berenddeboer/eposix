indexing

	description: "Test EPX_CURRENT_PROCESS class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	TEST_EPX_CURRENT_PROCESS


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	EPX_CURRENT_PROCESS


feature

	test_all is
		do
			millisleep (0)
			millisleep (150)
			millisleep (1010)
		end

end
