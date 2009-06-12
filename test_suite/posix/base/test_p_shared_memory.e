indexing

	description: "Test Posix shared memory class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

deferred class

	TEST_P_SHARED_MEMORY


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	POSIX_SYSTEM

	POSIX_FILE_SYSTEM


feature

	test_all is
			-- Testing Posix shared memory interface.
			-- On my system I need to be root for a successful test.
		local
			fd, fd2: POSIX_SHARED_MEMORY
		do
			assert ("Shared memory objects supported.", supports_shared_memory_objects)

			-- Create a shared memory object.
			create fd.create_read_write ("/test.berend")

			fd.write_string ("Hello world.%N")
			fd.seek (6)
			fd.read_string (5)
			assert_equal ("Read what written.", "world", fd.last_string)

			fd.close

			create fd2.open_read ("/test.berend")
			fd2.seek (6)
			fd2.read_string (5)
			assert_equal ("Expect string first written.", "world", fd2.last_string)
			fd2.close

			unlink_shared_memory_object ("/test.berend")
		end


end
