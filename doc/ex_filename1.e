class	EX_FILENAME1

create

	make

feature

	make is
		local
			path: STDC_PATH
		do
			create path.make_from_string ("/tmp/myfile.e")
			path.parse (<<".e">>)
			print_path (path)

			create path.make_expand ("$HOME/myfile.e")
			path.parse (<<".e">>)
			print_path (path)
		end

	print_path (a_path: STDC_PATH) is
		do
			print ("Directory: ")
			print (a_path.directory)
			print (", basename: ")
			print (a_path.basename)
			print (", suffix: ")
			print (a_path.suffix)
			print ("%N")
		end

end
