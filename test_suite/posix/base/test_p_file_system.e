indexing

	description: "Test Posix file system class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

deferred class

	TEST_P_FILE_SYSTEM


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	POSIX_CURRENT_PROCESS
		export
			{NONE} all
		end

	POSIX_FILE_SYSTEM
		export
			{NONE} all
		end

	POSIX_SYSTEM
		export
			{NONE} all
		end


feature -- The tests

	test_unlinking is
		do
			unlink (file_name)
			assert (file_name + " is removed.", not is_existing (file_name))
			touch (file_name)
			unlink (file_name)
			assert (file_name + " is removed.", not is_existing (file_name))
		end

	test_file_system is
		local
			stat: POSIX_STATUS
			tmpfile: POSIX_BINARY_FILE
			temp_status: POSIX_STATUS
		do
			assert ("Have temporary directory.", not temporary_directory.is_empty)
			debug
				print ("The temporary directory: ")
				print (temporary_directory)
				print ("%N")
			end

			create tmpfile.create_read_write (file_name)
			tmpfile.close
			temp_status := status (file_name)
			debug
				print ("Last access time: ")
				print (temp_status.access_time)
				print ("%N")
				print ("Last change time: ")
				print (temp_status.status_change_time)
				print ("%N")
				print ("Last modification time: ")
				print (temp_status.modification_time)
				print ("%N")
			end
			assert ("Have last access time.", temp_status.access_time > 0)
			assert ("Temporary file is not a block device.", not temp_status.is_block_special)
			assert ("Temporary file is not a character device.", not temp_status.is_character_special)
			assert ("Temporary file is not a directory.", not temp_status.is_directory)
			assert ("Temporary file is not a fifo.", not temp_status.is_fifo)
			assert ("Temporary file is a regular file.", temp_status.is_regular_file)

			-- Remove write permission.
			set_read_only (file_name)
			assert ("Not is permission bit writable file.", not status (file_name).permissions.allow_write)
			assert ("Not is writable file (perhaps you're root?).", not is_writable (file_name))
			assert ("Is permission bit readable file.", status (file_name).permissions.allow_owner_read)

			set_writable (file_name)
			assert ("Is permission bit writable file.", status (file_name).permissions.allow_write)
			remove_file (file_name)

			-- Status info
			touch (file_name)
			stat := status (file_name)
			assert_equal ("Size is zero.", 0, stat.size)
			create tmpfile.open_read_write (file_name)
			tmpfile.write_string ("1234")
			tmpfile.close
			assert_equal ("Cached size not changed.", 0, stat.size)
			assert_equal ("Size changed.", 4, status (file_name).size)
			debug
				print ("uid: ")
				print (stat.permissions.uid)
				print (".%N")
			end
			remove_file (file_name)
			assert ("File does not exist.", not is_existing (file_name))

			assert ("/bin/sh is executable file.", is_executable ("/bin/sh"))
		end

	test_accessibility is
		local
			tmpfile: POSIX_BINARY_FILE
		do
			create tmpfile.create_read_write (file_name)
			tmpfile.close
			assert ("Is existing file.", is_existing (file_name))
			assert ("Is real user ID readable file.", is_readable (file_name))
			assert ("Is writable file.", is_writable (file_name))
			assert ("Is empty file.", is_empty (file_name))
		end

	test_permissions is
		local
			tmpfile: POSIX_BINARY_FILE
			perm: POSIX_PERMISSIONS
		do
			create tmpfile.create_read_write (file_name)
			tmpfile.close
			perm := permissions (file_name)
			assert ("User is allowed to read/write tmp.tmp.",  perm.allow_owner_read_write)
			assert ("Group is allowed to read tmp.tmp.",  perm.allow_group_read)
			assert ("Anyone is allowed to read tmp.tmp.", perm.allow_anyone_read)
			assert ("Set user id is not set.", not perm.is_set_user_id)

			-- Change group to wheel.
			if is_in_group (0) then
				perm.set_group_id (0)
				perm.apply
				perm.refresh
				assert ("Group changed.", perm.group_id = 0)
			else
				print ("You are not in group wheel, can't run this test.%N")
			end

			-- Give anyone write permission.
			perm.set_allow_anyone_read_write (True)
			perm.apply
		end

	test_permissions_cache is
		local
			tmpfile: POSIX_BINARY_FILE
			perm: POSIX_PERMISSIONS
		do
			create tmpfile.create_read_write (file_name)
			tmpfile.close

			-- Cache permission.
			perm := status (file_name).permissions

			-- Test if cache can be refreshed.
			perm.refresh

			-- Remove read permission.
			perm := status (file_name).permissions
			perm.set_allow_read_write (False)
			perm.apply
			if system_name.substring_index ("CYGWIN", 1) = 0 then
				-- Test fails on cygwin
				assert ("Is no longer readable.", not is_readable (file_name))
			end
			assert ("Is no longer writable.", not perm.allow_write)
			perm.set_allow_read_write (True)
			perm.apply
			assert ("Is writable again.", perm.allow_write)
			unlink (file_name)
		end

	test_directory is
			-- Test directory functions.
		local
			dir: STRING
		do
			dir := getcwd
			chdir ("..")
			chdir (dir)
			assert_equal("Directory is the expected directory.", dir, getcwd)
			mkdir ("abc")
			chdir ("abc")
			change_directory ("..")
			rename_to ("abc", "def")
			assert ("Is directory.", status("def").is_directory)
			rmdir ("def")
			assert ("Is not directory.", not is_existing ("def"))
		end


	test_directory_reading is
		local
			dir: POSIX_DIRECTORY
			i: INTEGER
		do
			from
				dir := browse_directory (".")
				dir.start
				i := 0
			until
				dir.exhausted
			loop
				i := i + 1
				debug
					print (dir.item)
					print ("%N")
				end
				dir.forth
			end
			assert ("At least one entry.", i > 0)
		end

	test_hard_link is
		do
			remove_file ("link.tmp")
			touch ("file.tmp")
			link ("file.tmp", "link.tmp")
			assert ("link.tmp is a readable file.", is_readable ("link.tmp"))
			unlink ("link.tmp")
			unlink ("file.tmp")
			assert ("file.tmp is not a readable file.", not is_readable ("file.tmp"))
		end

	test_fifo is
		do
			-- fifo not supported on cygwin
			if system_name.substring_index ("CYGWIN", 1) = 0 then
				unlink ("berend.tmp")
				create_fifo ("berend.tmp", S_IRUSR + S_IWUSR)
				-- you can now read or write the fifo
				-- some other process should do the reverse
				assert ("Temporary file is fifo.", status("berend.tmp").is_fifo)
				unlink ("berend.tmp")
			else
				print ("fifo not supported on Cygwin.%N")
			end
		end


feature {NONE} -- Implementation

	file_name: STRING is "tmp.tmp"

end
