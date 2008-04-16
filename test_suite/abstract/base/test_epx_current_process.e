indexing

	description: "Test EPX_CURRENT_PROCESS class."

	author: "Berend de Boer"
	date: "$Date: 2006/04/14 $"
	revision: "$Revision: #2 $"


deferred class

	TEST_EPX_CURRENT_PROCESS


inherit

	TS_TEST_CASE

	EPX_CURRENT_PROCESS


feature

	test_all is
		do
			millisleep (0)
			millisleep (150)
			millisleep (1010)
		end

end
