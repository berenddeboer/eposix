indexing

	description: "Test Windows file system class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

deferred class

	TEST_W_FILE_SYSTEM

inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	WINDOWS_FILE_SYSTEM

feature -- Tests

	test_drive is
		do
			print ("Current drive: ")
			print (current_drive)
			print (":%N")
		end


	test_directory is
			-- Test directory functions.
		local
			dir: STRING
		do
			dir := getcwd
			chdir ("..")
			print ("Dir: ")
			print (getcwd)
			print (".%N")
			chdir (dir)
			print ("Dir: ")
			print (getcwd)
			print (".%N")
			assert_equal ("Directory is expected directory.", dir, getcwd)
			mkdir ("abc")
			chdir ("abc")
			print ("Dir: ")
			print (getcwd)
			print (".%N")
			change_directory ("..")
			rename_to ("abc", "def")
			rmdir ("def")
		end

end
