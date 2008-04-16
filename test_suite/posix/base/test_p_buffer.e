indexing

	description: "Test Posix dynamic memory class."

  author: "Berend de Boer"
	date: "$Date: 2003/12/04 $"
	revision: "$Revision: #1 $"

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
