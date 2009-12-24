indexing

	description: "getest based test for EPX_MIME classes."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #8 $"


deferred class

	TEST_MIME_PARSER


inherit

	TS_TEST_CASE

	EPX_MIME_FIELD_NAMES


feature -- Tests

	test_mail1 is
		local
			file: STDC_TEXT_FILE
			parser: EPX_MIME_PARSER
		do
			create file.open_read ("test1.msg")
			create parser.make_from_file (file)
			parser.parse
			assert ("test1.msg parsed ok", not parser.syntax_error)
			parser.part.header.search ("X-Sieve")
			assert ("Message has field X-Sieve", parser.part.header.found)
			debug ("mime")
				print ("length sieve: ")
				print (parser.part.header.found_item.value.count)
				print ("%N")
			end
			assert_equal ("Content of field X-Sieve", "cmu-sieve 2.0", parser.part.header.found_item.value)
			parser.part.header.search (field_name_mime_version)
			assert ("Field has no MIME-Version", not parser.part.header.found)
			assert ("Message has Date field", parser.part.header.has (field_name_date))
			assert ("Message has From field", parser.part.header.has (field_name_from))
			assert_equal ("From set", "<root@nederware.nl>", parser.part.header.item (field_name_from).value)
			debug ("mime")
				print_body (parser.part.body)
			end

			-- test if we can invoke the parser twice
			file.close
			file.open_read ("test1.msg")
			parser.make_from_file (file)
			parser.parse
			assert ("test1.msg parsed ok", not parser.syntax_error)
		end

	test_mail2 is
		local
			file: STDC_TEXT_FILE
			parser: EPX_MIME_PARSER
		do
			create file.open_read ("test2.msg")
			create parser.make_from_file (file)
			parser.parse
			assert ("test2.msg parsed ok", not parser.syntax_error)
			parser.part.header.search ("MIME-Version")
			assert ("Field has MIME-Version", parser.part.header.found)
			assert_equal ("Content of field MIME-Version", "1.0", parser.part.header.found_item.value)
			debug ("mime")
				print_body (parser.part.body)
			end
		end

	test_mail3 is
		local
			file: STDC_TEXT_FILE
			parser: EPX_MIME_PARSER
		do
			create file.open_read ("test3.msg")
			create parser.make_from_file (file)
			parser.parse
			assert ("test3.msg parsed ok", not parser.syntax_error)
			debug ("mime")
				print_body (parser.part.body)
			end
		end

	test_mail4 is
		local
			file: STDC_TEXT_FILE
			parser: EPX_MIME_PARSER
			multipart_body: EPX_MIME_BODY_MULTIPART
		do
			create file.open_read ("test4.msg")
			create parser.make_from_file (file)
			parser.parse
			assert ("test4.msg parsed ok", not parser.syntax_error)
			parser.part.header.search ("MIME-Version")
			assert ("Field has MIME-Version", parser.part.header.found)
			assert_equal ("Content of field MIME-Version", "1.0", parser.part.header.found_item.value)
			parser.part.header.search ("Content-Type")
			assert ("Have field Content-Type", parser.part.header.found)
			assert ("Feature content_type not void", parser.part.header.content_type /= Void)
			assert_integers_equal ("Have two parameters", 2, parser.part.header.content_type.parameters.count)
			assert ("Have parameter report-type", parser.part.header.content_type.parameters.has ("report-type"))
			assert ("Have parameter boundary", parser.part.header.content_type.parameters.has ("boundary"))
			assert ("Body is multi-part", parser.part.body.is_multipart)
			multipart_body ?= parser.part.body
			assert ("Multipart body not void.", multipart_body /= Void)
			assert_integers_equal ("Number of parts", 3, multipart_body.parts.count)
			print_body (multipart_body.parts.first.body)
			assert_integers_equal ("First part has one field.", 1, parser.part.body.part (1).header.count)
		end

	test_base64_encoding is
			-- Test if base64 encoding is done ok.
		local
			file: STDC_TEXT_FILE
			parser: EPX_MIME_PARSER
		do
			create file.open_read ("test8.msg")
			create parser.make_from_file (file)
			parser.parse
			assert ("test8.msg parsed ok", not parser.syntax_error)
			assert ("Body is multi-part", parser.part.body.is_multipart)
			assert ("First body is empty.", parser.part.body.part (1).body.as_string.is_empty)
			assert ("First body is not multi-part.", not parser.part.body.part (1).body.is_multipart)
			assert ("First body is empty.", parser.part.body.part (1).body.as_plain_text.is_empty)
			debug ("mime")
				print_body (parser.part.body.part (2).body)
			end
		end

	test_quoted_printable_encoding is
			-- Test if quoted-printable encoding is done ok.
			-- This really complex message tests a lot more though.
		local
			file: STDC_TEXT_FILE
			parser: EPX_MIME_PARSER
			part1,
			part2,
			part1_1,
			part1_2: EPX_MIME_PART
		do
			create file.open_read ("test9.msg")
			create parser.make_from_file (file)
			parser.parse
			assert ("test9.msg parsed ok", not parser.syntax_error)
			assert ("Body is multi-part", parser.part.body.is_multipart)
			-- Incorrect, should see TWO parts!!
			-- i.e. first part is multipart, second is image
			assert_integers_equal ("Body has two parts", 2, parser.part.body.parts_count)
			assert ("Multi-part body has multipart bodies it self.", parser.part.body.has_parts_with_multipart_bodies)
			part1 := parser.part.body.part (1)
			part2 := parser.part.body.part (2)
			assert ("part1 is multipart", part1.body.is_multipart)
			assert ("part2 is singlepart", not part2.body.is_multipart)
			assert_integers_equal ("Part in body has two parts", 2, part1.body.parts_count)
			part1_1 := part1.body.part (1)
			part1_2 := part1.body.part (2)
			assert ("part1_1 is a single-part body", not part1_1.body.is_multipart)
			assert ("part1_2 is a single-part body", not part1_2.body.is_multipart)
			debug ("mime")
				-- empty
				--print_body (part1_1.body)
				print_body (part1_2.body)
				print_body (part2.body)
			end
		end

	test_rfc2047_encodings is
			-- Test RFC 2047 B and Q encodings in header fields.
		local
			file: STDC_TEXT_FILE
			parser: EPX_MIME_PARSER
		do
			create file.open_read ("test10.msg")
			create parser.make_from_file (file)
			parser.parse
			assert ("test10.msg parsed ok", not parser.syntax_error)
			assert ("has Subject field.", parser.part.header.has ("Subject"))
			debug ("mime")
				print ("Subject: ")
				print (parser.part.header.item ("Subject").value)
				print ("%N")
			end

			parser.set_input_buffer (parser.new_string_buffer (rfc2047_example_1))
			parser.parse
			assert ("rfc2047_example_1 parsed ok", not parser.syntax_error)
			assert ("has Subject field.", parser.part.header.has ("Subject"))
			assert_equal ("Subject parsed ok.", "If you can read this you understand the example.", parser.part.header.item ("Subject").value)
			assert ("has Cc field.", parser.part.header.has ("Cc"))
			assert_strings_equal ("Cc parsed ok.", "%"André Pirard%" <PIRARD@vm1.ulg.ac.be>", parser.part.header.item ("Cc").value)

			parser.set_input_buffer (parser.new_string_buffer (rfc2047_example_2))
			parser.parse
			assert ("rfc2047_example_2 parsed ok", not parser.syntax_error)
			assert ("has From field.", parser.part.header.has ("From"))
			assert_strings_equal ("From parsed ok.", "%"Olle_Järnefors%" <ojarnef@admin.kth.se>", parser.part.header.item ("From").value)

			parser.set_input_buffer (parser.new_string_buffer (rfc2047_example_3))
			parser.parse
			assert ("rfc2047_example_3 parsed ok", not parser.syntax_error)

			parser.set_input_buffer (parser.new_string_buffer (rfc2047_example_4))
			parser.parse
			assert ("rfc2047_example_4 parsed ok", not parser.syntax_error)
		end

	test_parsing_cgi_input is
		local
			file: STDC_TEXT_FILE
			parser: EPX_MIME_PARSER
			string_body: EPX_MIME_BODY_STRING
			file_body: EPX_MIME_BODY_FILE
		do
			create file.open_read ("cgi_input1.txt")
			create parser.make_from_file (file)
			parser.parse
			assert_integers_equal ("Two fields", 2, parser.part.header.count)
			assert ("Body is multi-part", parser.part.body.is_multipart)
			assert_integers_equal ("Number of parts", 3, parser.part.body.parts_count)
			debug ("mime")
				print_body (parser.part.body.part (1).body)
			end
			file_body ?= parser.part.body.part (1).body
			assert ("1st part is a file body", file_body /= Void)
			string_body ?= parser.part.body.part (2).body
			assert ("2nd part is string body", string_body /= Void)
			assert_equal ("Contents of button", "Upload file(s)", string_body.as_string)
			string_body ?= parser.part.body.part (3).body
			assert ("3rd part is string_body", string_body /= Void)
			assert_equal ("Contents of uid", "1804289383", string_body.as_string)
		end

	test_bad_date is
			-- Test email with date past 2038.
		local
			file: STDC_TEXT_FILE
			parser: EPX_MIME_PARSER
		do
			create file.open_read ("test13.msg")
			create parser.make_from_file (file)
			parser.parse
			assert ("test13.msg parsed ok", not parser.syntax_error)
			parser.part.header.search ("MIME-Version")
			assert ("Field has MIME-Version", parser.part.header.found)
			assert_equal ("Content of field MIME-Version", "1.0", parser.part.header.found_item.value)
			debug ("mime")
				print_body (parser.part.body)
			end
		end

	test_content_disposition is
			-- Test email with Content-Disposition with file name with
			-- directory part.
		local
			file: STDC_TEXT_FILE
			parser: EPX_MIME_PARSER
			cd: EPX_MIME_FIELD_CONTENT_DISPOSITION
		do
			create file.open_read ("test14.msg")
			create parser.make_from_file (file)
			parser.parse
			assert ("test14.msg parsed ok", not parser.syntax_error)
			parser.part.header.search ("Content-Disposition")
			assert ("Field has Content-Disposition", parser.part.header.found)
			cd ?= parser.part.header.found_item
			cd.parameters.search ("filename")
			assert ("Content-Disposition has parameter filename", cd.parameters.found)
			assert_equal ("Content of parameter filename of field Content-Disposition", "fname.ext", cd.parameters.found_item.value)
		end

	test_multipart_form_data_with_content_length is
			-- Content-Length fields shouldn't normally appear inside
			-- multipart/form/data. It's not forbidden, but when they
			-- appear, they should be ignored.
		local
			file: STDC_TEXT_FILE
			parser: EPX_MIME_PARSER
		do
			create file.open_read ("bad_form_data.form")
			create parser.make_from_file (file)
			parser.parse
			assert ("bad_form_data.form parsed ok", not parser.syntax_error)
			assert_integers_equal ("Two fields", 2, parser.part.multipart_body.parts_count)
		end

	test_simple_multipart_form_data is
			-- Content-Length fields shouldn't normally appear inside
			-- multipart/form/data. It's not forbidden, but when they
			-- appear, they should be ignored.
		local
			file: STDC_TEXT_FILE
			parser: EPX_MIME_PARSER
		do
			create file.open_read ("simple_form_data.form")
			create parser.make_from_file (file)
			parser.parse
			assert ("bad_form_data.form parsed ok", not parser.syntax_error)
			assert_integers_equal ("One field", 1, parser.part.multipart_body.parts_count)
		end

	test_chunked_encoding is
			-- Test parsing a MIME message which uses Transfer-Encoding:
			-- chunked. Can happen with HTTP requests and responses.
		local
			file: STDC_TEXT_FILE
			parser: EPX_MIME_PARSER
			body: STRING
		do
			-- Test case where entire message fits into our buffer.

			-- Test case where header + first chunk + part of 2nd chunk
			-- fit into our buffer.
			create file.open_read ("chunk1.msg")
			create parser.make_from_file (file)
			parser.parse
			assert ("chunk1.msg parsed ok", not parser.syntax_error)
			parser.part.header.search (field_name_transfer_encoding)
			assert ("Field has Transfer-Encoding", parser.part.header.found)
			assert_equal ("Content of field Transfer-Encoding", "chunked", parser.part.header.found_item.value)
			body := parser.part.body.as_plain_text
			assert_equal ("First character is T.", 'T', body.item (1))
			assert_equal ("Last character is \n.", ('%N').code, body.item (body.count).code)
			assert_equal ("Second to last character is 0.", ('0').code, body.item (body.count - 1).code)
			file.close

			-- Test case where the header + first character of chunk size
			-- fits into our buffer.
			-- The chunk size should be partially have to be read from stream.
			-- The chunk is read on the next `fill'.
			create file.open_read ("chunk2.msg")
			parser.make_from_file (file)
			parser.parse
			assert ("chunk2.msg parsed ok", not parser.syntax_error)
			parser.part.header.search (field_name_transfer_encoding)
			assert ("Field has Transfer-Encoding", parser.part.header.found)
			assert_equal ("Content of field Transfer-Encoding", "chunked", parser.part.header.found_item.value)
			body := parser.part.body.as_plain_text
			assert_equal ("First character is T.", 'T', body.item (1))
			assert_equal ("Last character is \n.", ('%N').code, body.item (body.count).code)
			assert_equal ("Second to last character is 0.", ('0').code, body.item (body.count - 1).code)
			file.close

			-- Test case where just the header fits into our buffer.
			-- The chunk size is read on the next `fill'.
			create file.open_read ("chunk3.msg")
			parser.make_from_file (file)
			parser.parse
			assert ("chunk3.msg parsed ok", not parser.syntax_error)
			parser.part.header.search (field_name_transfer_encoding)
			assert ("Field has Transfer-Encoding", parser.part.header.found)
			assert_equal ("Content of field Transfer-Encoding", "chunked", parser.part.header.found_item.value)
			body := parser.part.body.as_plain_text
			assert_equal ("First character is T.", 'T', body.item (1))
			assert_equal ("Last character is \n.", ('%N').code, body.item (body.count).code)
			assert_equal ("Second to last character is 0.", ('0').code, body.item (body.count - 1).code)
			file.close

			-- Test where empty line between header and body just falls
			-- over the buffer size.
			create file.open_read ("chunk4.msg")
			create parser.make_from_file (file)
			parser.parse
			assert ("chunk4.msg parsed ok", not parser.syntax_error)
			parser.part.header.search (field_name_transfer_encoding)
			assert ("Field has Transfer-Encoding", parser.part.header.found)
			assert_equal ("Content of field Transfer-Encoding", "chunked", parser.part.header.found_item.value)
			body := parser.part.body.as_plain_text
			assert_equal ("First character is T.", 'T', body.item (1))
			assert_equal ("Last character is \n.", ('%N').code, body.item (body.count).code)
			assert_equal ("Second to last character is 0.", ('0').code, body.item (body.count - 1).code)
			file.close

			-- Test case where the header + chunk size fits  into our buffer.
			-- The chunk is read on the next `fill'.


			-- Test chunk with extra headers after chunk

			-- Another failure, caused class invariant violation
			create file.open_read ("chunk5.msg")
			create parser.make_from_file (file)
			parser.parse
			assert ("chunk5.msg parsed ok", not parser.syntax_error)
		end

	test_characters_after_content_length is
			-- Test if characters after content length are ignored.
		local
			file: STDC_TEXT_FILE
			parser: EPX_MIME_PARSER
		do
			create file.open_read ("http1.msg")
			create parser.make_from_file (file)
			parser.parse
			assert ("http1.msg parsed ok", not parser.syntax_error)
			assert_integers_equal ("Message length ok", 1209, parser.part.as_string.count)
			assert_integers_equal ("Body length ok", 1070, parser.part.text_body.as_string.count)
		end


feature {NONE} -- Helpers

	print_body (body: EPX_MIME_BODY) is
		require
			not_multipart: not body.is_multipart
		local
			s: STRING
		do
			s := body.as_plain_text
			print ("==========begin==========%N")
			print (s)
			print ("==========end==========%N")
		end


feature {NONE} -- Examples from RFC 2047

	rfc2047_example_1: STRING is "%
	%From: =?US-ASCII?Q?Keith_Moore?= <moore@cs.utk.edu>%R%N%
	%To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>%R%N%
	%CC: =?ISO-8859-1?Q?Andr=E9?= Pirard <PIRARD@vm1.ulg.ac.be>%R%N%
	%Subject: =?ISO-8859-1?B?SWYgeW91IGNhbiByZWFkIHRoaXMgeW8=?=%R%N%
	% =?ISO-8859-2?B?dSB1bmRlcnN0YW5kIHRoZSBleGFtcGxlLg==?=%R%N%R%N"

	rfc2047_example_2: STRING is "%
	%From: =?ISO-8859-1?Q?Olle_J=E4rnefors?= <ojarnef@admin.kth.se>%R%N%
	%To: ietf-822@dimacs.rutgers.edu, ojarnef@admin.kth.se%R%N%
	%Subject: Time for ISO 10646?%R%N%R%N"

	rfc2047_example_3: STRING is "%
	%To: Dave Crocker <dcrocker@mordor.stanford.edu>%R%N%
	%Cc: ietf-822@dimacs.rutgers.edu, paf@comsol.se%R%N%
	%From: =?ISO-8859-1?Q?Patrik_F=E4ltstr=F6m?= <paf@nada.kth.se>%R%N%
	%Subject: Re: RFC-HDR care and feeding%R%N%R%N"

	rfc2047_example_4: STRING is "%
	%From: Nathaniel Borenstein <nsb@thumper.bellcore.com>%R%N%
	%      (=?iso-8859-8?b?7eXs+SDv4SDp7Oj08A==?=)%R%N%
	%To: Greg Vaudreuil <gvaudre@NRI.Reston.VA.US>, Ned Freed%R%N%
	%   <ned@innosoft.com>, Keith Moore <moore@cs.utk.edu>%R%N%
	%Subject: Test of new header generator%R%N%
	%MIME-Version: 1.0%R%N%
	%Content-type: text/plain; charset=ISO-8859-1%R%N%R%N"

end
