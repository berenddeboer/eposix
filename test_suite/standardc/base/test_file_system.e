indexing

	description: "Test common file system class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"

deferred class

	TEST_FILE_SYSTEM

inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	STDC_CURRENT_PROCESS

	STDC_FILE_SYSTEM


feature

	test_all is
		local
			name1,
			name2: STRING
			tmpfile: STDC_BINARY_FILE
			s: STRING
		do
			-- Create a  file
			name1 := "tmp.tmp"
			create tmpfile.create_read_write (name1)
			tmpfile.close

			assert ("Is readable file.", is_readable (name1))
			assert ("Is readable and writable file.", is_modifiable (name1))

			name2 := "abc.tmp"
			rename_to (name1, name2)
			assert ("Renamed.", not is_readable (name1))

			remove_file (name2)
			assert ("Removed.", not is_readable (name2))

			create s.make_from_string (expand_path ("~/tmp"))
			assert_not_equal ("Expanded path.", "~/tmp", s)
			debug
				print ("Expanded path: ")
				print (expand_path ("~/tmp"))
				print ("%N")
			end
		end

end
