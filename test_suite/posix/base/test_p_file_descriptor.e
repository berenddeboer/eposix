indexing

	description: "Test Posix file descriptor class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	TEST_P_FILE_DESCRIPTOR

inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	POSIX_CONSTANTS

	POSIX_SYSTEM

	POSIX_FILE_SYSTEM


feature

	FirstByte: INTEGER is 65
	SecondByte: INTEGER is 66

	test_various is
		local
			fd: POSIX_FILE_DESCRIPTOR
			buf: STDC_BUFFER
			byte: INTEGER
		do
			unlink ("test.berend")
			assert ("File created.", not is_existing ("test.berend"))
			create fd.create_read_write ("test.berend")
			assert ("File created.", is_writable ("test.berend"))

			-- Write a byte to that file.
			create buf.allocate (2)
			buf.poke_uint8 (0, FirstByte)
			buf.poke_uint8 (1, SecondByte)
			fd.write_buffer (buf, 0, buf.capacity)
			fd.close

			-- Open existing file with read-only access.
			create fd.open_read ("test.berend")

			-- Read a byte.
			fd.read_buffer (buf, 0, buf.capacity)
			byte := buf.peek_uint8 (0)
			assert_equal ("Result is as expected.", FirstByte, byte)

			assert_equal ("Expected size.", 2, fd.status.size)
			debug
				print ("Other file information:%N")
				print ("uid: ")
				print (fd.status.unix_uid.out)
				print (".%N")
				print ("gid: ")
				print (fd.status.unix_gid.out)
				print (".%N")
				print ("inode: ")
				print (fd.status.inode.out)
				print (".%N")
				print ("mtime: ")
				print (fd.status.mtime.out)
				print (".%N")
			end
			assert ("Not attached to terminal.", not fd.is_attached_to_terminal)
			fd.close

			-- Open existing file with read and write access.
			create fd.open_read_write ("test.berend")

			-- Test lseek first byte.
			buf.poke_uint8 (0, 0)
			buf.poke_uint8 (1, 0)
			fd.seek (0)
			fd.read_buffer (buf, 1, 1)
			byte := buf.peek_uint8 (1)
			assert_equal ("Result as expected.", FirstByte, byte)

			-- Test lseek from end.
			fd.seek_from_end (-1)
			fd.read_buffer (buf, 0, 1)
			byte := buf.peek_uint8 (0)
			assert_equal ("Result as expected.", 66, byte)

			if supports_file_synchronization then
				fd.synchronize
			end
			if supports_synchronized_io then
				fd.synchronize_data
			end

			fd.seek (2)
			fd.write_string ("hello.%N")
			fd.seek (2)
			fd.read_string (8)
			assert_equal ("Expected hello.", "hello.%N", fd.last_string)
			fd.close
		end

	test_create_from_file is
		local
			fd, fd2: POSIX_FILE_DESCRIPTOR
			file: POSIX_TEXT_FILE
		do
			create file.open_read ("test.berend")
			create fd.make_from_file (file)
			create fd2.make_as_duplicate (fd)
			fd2.make_as_duplicate (fd)
			fd2.close
			-- not fd.is_owner, so can't close
			-- fd.close
			file.close
			remove_file ("test.berend")
		end

end
