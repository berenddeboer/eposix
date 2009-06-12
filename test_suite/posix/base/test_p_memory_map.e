indexing

	description: "Test Posix memory mapping class."

  author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

deferred class

	TEST_P_MEMORY_MAP

inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	POSIX_SYSTEM

	POSIX_CURRENT_PROCESS

	POSIX_FILE_SYSTEM


feature

	test_all is
		local
			fd: POSIX_FILE_DESCRIPTOR
			map: POSIX_MEMORY_MAP
			byte: INTEGER
		do
			assert ("Memory mapped files are not supported.", supports_memory_mapped_files)

			-- Create a file.
			create fd.create_read_write ("test.berend")
			fd.write_string ("hello world.")

			-- Create memory map.
			create map.make_shared (fd, 0, 6)

			-- Read a byte from the mapping.
			byte := map.peek_uint8 (5)
			assert_equal ("Read a space.", 32, byte)

			-- Cleanup.
			map.close
			fd.close
			remove_file ("test.berend")
		end

end
