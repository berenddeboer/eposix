indexing

	description: "Test SUS file system class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


deferred class

	TEST_S_FILE_SYSTEM


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		end

	SUS_FILE_SYSTEM


feature

	test_all is
		local
			stat: SUS_STATUS
			f: STDC_TEXT_FILE
		do
			debug
				print ("real path: ")
				print (resolved_path_name ("../"))
				print ("%N")
			end
			assert ("real path not empty.", not resolved_path_name ("../").is_empty)

			unlink ("tmp.tmp")
			unlink ("test.berend")

			create f.create_write ("tmp.tmp")
			f.write_string ("hello")
			f.close

			create_symbolic_link ("tmp.tmp", "test.berend")

			stat := symbolic_link_status ("test.berend")
			assert ("test.berend is a symbolic link.",  stat.is_symbolic_link)

			stat := status ("test.berend")
			print ("block count: ")
			print (stat.block_count)
			print ("%N")
			print ("block size: ")
			print (stat.block_size)
			print ("%N")
			unlink ("test.berend")
			unlink ("tmp.tmp")
		end

end
