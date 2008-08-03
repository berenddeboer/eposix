indexing

	description: "Test (recursive) directory browsing."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	TEST_DIRECTORY_BROWSING


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	EPX_FILE_SYSTEM

	ABSTRACT_PATH_FILTER
		redefine
			require_status
		end


feature -- Tests

	test_browsing is
			-- Exhaustively test directory browsing code.
		local
			dir: ABSTRACT_DIRECTORY
		do
			dir := browse_directory ("dir1")
			do_browse (dir, 2, 0)
			dir.set_recursive (True)
			do_browse (dir, 2, 0)
			dir := browse_directory ("dir2")
			do_browse (dir, 3, 0)
			dir.set_recursive (True)
			do_browse (dir, 5, 0)
			dir := browse_directory ("dir3")
			do_browse (dir, 3, 0)
			dir.set_recursive (True)
			do_browse (dir, 5, 1)
			dir := browse_directory ("dir4")
			do_browse (dir, 2, 1)
			dir.set_recursive (True)
			do_browse (dir, 2, 1)
			dir := browse_directory ("dir5")
			do_browse (dir, 2, 2)
			dir.set_recursive (True)
			do_browse (dir, 2, 2)
			dir := browse_directory ("dir6")
			do_browse (dir, 3, 0)
			dir.set_recursive (True)
			do_browse (dir, 8, 0)
			dir := browse_directory ("dir7")
			dir.set_recursive (True)
			do_browse (dir, 11, 1)
		end


feature {NONE} -- Implementation

	do_browse (a_directory: ABSTRACT_DIRECTORY; a_number_of_directories, a_number_of_files: INTEGER) is
		require
			a_directory_not_void: a_directory /= Void
		do
			a_directory.set_filter (Current)
			number_of_directories := 0
			number_of_files := 0
			from
				a_directory.start
			until
				a_directory.exhausted
			loop
				a_directory.forth
			end
			assert_equal ("Number of directories in " + a_directory.directory_name + " is correct", a_number_of_directories, number_of_directories)
			assert_equal ("Number of files in " + a_directory.directory_name + " is correct", a_number_of_files, number_of_files)
		end

	number_of_directories: INTEGER
			-- Number of directories counted by `is_valid'

	number_of_files: INTEGER
			-- Number of files counted by `is_valid'


feature {NONE} -- Filter characteristics

	is_valid (a_status: ABSTRACT_STATUS; path_name: STRING): BOOLEAN is
			-- Is `path_name' a valid path to return?
		do
			debug ("test")
				print ("Doing: ")
				print (path_name)
				print ("%N")
			end
			-- Skip .svn directory
			if not path_name.has_substring (once ".svn") then
				if a_status.is_directory then
					number_of_directories := number_of_directories + 1
				elseif a_status.is_regular_file then
					number_of_files := number_of_files + 1
				end
			end
			Result := True
		end

	require_status: BOOLEAN is True
			-- Should `is_valid' receive a valid status?


end
