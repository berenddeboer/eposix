note

	description: "getest based test for EPX_LDIF_PARSER class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


deferred class

	TEST_LDIF_PARSER


inherit

	TS_TEST_CASE

	KL_SHARED_STANDARD_FILES
		export
			{NONE} all
		end


feature -- Tests

	test_ldif_example_1
		do
			parse  ("ldif/example1.ldf")
		end

	test_ldif_example_2
		do
			parse  ("ldif/example2.ldf")
		end

	test_ldif_example_3
		do
			parse  ("ldif/example3.ldf")
		end

	test_ldif_example_4
		do
			parse  ("ldif/example4.ldf")
		end

	test_ldif_example_5
		do
			parse  ("ldif/example5.ldf")
		end

	test_ldif_example_6
		do
			parse  ("ldif/example6.ldf")
		end

	test_ldif_example_7
		do
			parse  ("ldif/example7.ldf")
		end

	test_parsing_users
		local
			file: STDC_TEXT_FILE
			parser: EPX_LDIF_PARSER
		do
			create file.open_read ("ldif/users.ldf")
			create parser.make_from_stream (file)
			parser.parse
			assert ("users.ldf parsed ok", not parser.syntax_error)
			file.close

			-- test if we can invoke the parser twice
			file.open_read ("ldif/users.ldf")
			parser.make_from_stream (file)
			parser.parse
			assert ("users.ldf parsed ok", not parser.syntax_error)
			file.close
		end

	test_parsing_domain
		do
			parse  ("ldif/full_domain.ldf")
		end

	test_difficult
		do
			parse  ("ldif/difficult.ldf")
		end


feature {NONE} -- Implementation

	parse (filename: STRING)
		require
			filename_not_empty: filename /= Void and then not filename.is_empty
		local
			file: STDC_TEXT_FILE
			parser: EPX_LDIF_PARSER
		do
			create file.open_read (filename)
			create parser.make_from_stream (file)
			parser.parse
			if parser.syntax_error then
				std.output.put_string ("  parse error at ")
				std.output.put_string (parser.line.out)
				std.output.put_string (", ")
				std.output.put_string (parser.column.out)
				std.output.put_character ('%N')
			end
			assert (filename + " parsed ok", not parser.syntax_error)
			file.close
		end

end
