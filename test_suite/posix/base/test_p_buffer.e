indexing

	description: "Test Posix dynamic memory class."

  author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

deferred class

	TEST_P_BUFFER

inherit

	TS_TEST_CASE

feature

	test_all is
		local
			buf: POSIX_BUFFER
		do
			create buf.allocate (100)
			buf.deallocate
		end

end
