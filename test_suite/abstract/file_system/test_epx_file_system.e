indexing

	description: "Test portable file system class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #9 $"


deferred class

	TEST_EPX_FILE_SYSTEM


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	EPX_CURRENT_PROCESS

	EPX_FILE_SYSTEM


feature -- Tests

	file_name: STRING is "tmp.tmp"

	test_file_system is
		local
			stat: EPX_STATUS
			tmpfile: STDC_BINARY_FILE
			temp_status: EPX_STATUS
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
			assert ("Temporary file is not a character device.", not temp_status.is_character_special)
			assert ("Temporary file is not a directory.", not temp_status.is_directory)
			assert ("Temporary file is not a fifo.", not temp_status.is_fifo)
			assert ("Temporary file is a regular file.", temp_status.is_regular_file)
			remove_file (file_name)

			-- Status info
			create tmpfile.create_read_write (file_name)
			tmpfile.close
			stat := status (file_name)
			assert_integers_equal ("Size is zero.", 0, stat.size)
			create tmpfile.open_read_write (file_name)
			tmpfile.write_string ("1234")
			tmpfile.close
			assert_integers_equal ("Cached size not changed.", 0, stat.size)
			assert_integers_equal ("Size changed.", 4, status (file_name).size)
			remove_file (file_name)
			assert ("File does not exist.", not is_existing (file_name))

			assert ("I am an executable file.", is_executable (command_name))
		end

	test_accessibility is
		local
			tmpfile: STDC_BINARY_FILE
		do
			create tmpfile.create_read_write (file_name)
			tmpfile.close
			assert ("Is existing file.", is_existing (file_name))
			assert ("Is real user ID readable file.", is_readable (file_name))
			assert ("Is writable file.", is_writable (file_name))
			assert ("Is empty file.", is_empty (file_name))
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
			dir: ABSTRACT_DIRECTORY
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

	test_resolved_path is
		local
			rpath: STRING
		do
			rpath := resolved_path_name ("dir1")
			assert ("Has separators", rpath.has (path_separator))
			assert_equal ("ends with dir1", rpath.count - 3, rpath.substring_index ("dir1", 1))
			rpath := resolved_path_name ("build.eant")
			assert ("Has separators", rpath.has (path_separator))
			assert_equal ("ends with build.eant", rpath.count - 9, rpath.substring_index ("build.eant", 1))
			rpath := resolved_path_name ("./build.eant")
			assert ("Has separators", rpath.has (path_separator))
			assert_equal ("ends with build.eant", rpath.count - 9, rpath.substring_index ("build.eant", 1))
		end

end
