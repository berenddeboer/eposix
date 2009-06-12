indexing

	description: "Test Posix asynchronous io."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	TEST_P_ASYNC_IO


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptiosn
		end

	POSIX_CURRENT_PROCESS

	POSIX_FILE_SYSTEM

	POSIX_SYSTEM


feature -- Tests if test possible

	test_all is
		do
			print ("testing Posix asynchronous io.%N")

			if not supports_asynchronous_io then
				stderr.puts ("!! Asynchronous i/o not supported, test not possible.%N")
			else
				do_test_all
			end
		end

feature {NONE} -- Actual test

	do_test_all	is
		local
			fd: POSIX_FILE_DESCRIPTOR
			request: POSIX_ASYNC_IO_REQUEST
		do
			create fd.create_read_write ("berend.temp")
			create request.make (fd)
			request.set_offset (0)
			-- Write something.
			request.write_string ("hello world.")
			sleep (2)
			assert_equal ("Result is bytes written.", 12, request.return_status)
			request.set_offset (6)
			request.set_count (5)
			request.read_string
			request.wait_for
			assert_equal ("Result is bytes read.", 5, request.return_status)
			assert_equal ("Read as expected.", "world", request.last_string)

			request.set_offset (12)
			request.write_string ("ABC")
			-- synchronize somehow removes write request??
			-- saw this behaviour with Linux 6.2 and 7.1
			-- if you take a look at berend.temp you see zero's where ABC
			-- should have been.
			--request.synchronize
			request.wait_for
			assert_equal ("Result is bytes written.", 3, request.return_status)

			request.set_offset (15)
			request.write_string ("more text.")
			request.cancel
			if request.cancel_failed then
				print ("Operation could not be canceled anymore.%N")
			end
			request.wait_for
			sleep (2)

			fd.close

			remove_file ("berend.temp")
		end

end
