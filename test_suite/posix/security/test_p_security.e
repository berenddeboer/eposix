indexing

	description: "Test POSIX securiy class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


deferred class

	TEST_P_SECURITY


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	POSIX_FILE_SYSTEM

	MEMORY

feature -- Security tests

	test_exception_handling is
			-- No exception should occur in this test.
		local
			file: STDC_BINARY_FILE
			fd: POSIX_FILE_DESCRIPTOR
			perm: POSIX_PERMISSIONS
		do
			security.error_handling.disable_exceptions
			create file.open_read ("does.not.exist")
			assert_not_equal ("First error set.", 0, file.errno.first_value)

			file.errno.clear_first
			create file.create_read_write ("/a/b/c/x/y/z/does.not.exist")
			assert_not_equal ("First error set.", 0, file.errno.first_value)

			file.errno.clear_first
			create fd.open_read ("does.not.exist")
			assert_not_equal ("First error set.", 0, file.errno.first_value)

			file.errno.clear_first
			change_directory ("does.not.exist")
			assert_not_equal ("First error set.", 0, file.errno.first_value)

			-- create a file and make it readonly
			touch ("/tmp/file.berend")
			perm := permissions ("/tmp/file.berend")
			perm.set_allow_owner_write (False)
			perm.apply
			create fd.create_write ("/tmp/file.berend")
			assert_not_equal ("First error set.", 0, file.errno.first_value)
			create fd.open_read ("/tmp/file.berend")
			-- We can't write because the string hasn't been opened for writing,
			-- so we hit the precondition.
			-- Make sure to compile without precondition checking!
			fd.write_string ("1%N")
			fd.write_string ("2%N")
			assert_not_equal ("First error set.", 0, file.errno.first_value)
			fd.errno.clear_first
			fd.close

			security.error_handling.enable_exceptions
		end


end
