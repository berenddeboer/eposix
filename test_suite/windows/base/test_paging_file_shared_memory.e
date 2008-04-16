indexing

	description: "getest based test for Windows paging-file backed shared memory."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


deferred class

	TEST_PAGING_FILE_SHARED_MEMORY

inherit

	TS_TEST_CASE

feature -- Tests

	test_basics is
		local
			shm: WINDOWS_PAGING_FILE_SHARED_MEMORY
			shm_client: WINDOWS_PAGING_FILE_SHARED_MEMORY
		do
			create shm.create_read_write ("temp", 4096)
			shm.poke_integer (52, 1234)
			assert ("Read integer", shm.peek_integer (52) = 1234)
			create shm_client.open_read ("temp", 4096)
			assert ("Read integer", shm_client.peek_integer (52) = 1234)
			shm_client.close
			shm.close
		end

end
