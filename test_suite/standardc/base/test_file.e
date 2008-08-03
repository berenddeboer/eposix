indexing

	description: "Test Standard C file class."

	Bugs: "1. Assumes 8 bit characters."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"

deferred class

	TEST_FILE


inherit

	TS_TEST_CASE
		rename
			exceptions as test_exceptions
		redefine
			tear_down
		end

	STDC_FILE_SYSTEM


feature -- Setup

	tear_down is
		do
			remove_file ("test.berend")
		end


feature -- Tests

	sample_text: STRING is "hello world"

	test_create_and_append is
			-- Test create routines.
		local
			file: STDC_BINARY_FILE
		do
			create file.create_read_write ("test.berend")
			file.close

			create file.open_append ("test.berend")
			file.close
		end

	test_create_write is
			-- Create a file for reading and writing.
		local
			file: STDC_BINARY_FILE
		do
			create file.create_read_write ("test.berend")
			file.write_string (sample_text)
			assert ("No error.", not file.error)
			file.clearerr
			file.flush
			file.close
		end

	test_readonly_access is
			-- Open existing file with read-only access.
		local
			file: STDC_BINARY_FILE
		do
			create file.create_read_write ("test.berend")
			file.close
			create file.open_read ("test.berend")
			file.close
		end

	test_writing is
			-- Create a file for writing
		local
			file: STDC_BINARY_FILE
		do
			create file.create_read_write ("test.berend")
			assert ("Binary mode", file.is_binary_mode_specification (file.mode))
			assert ("Not text mode", not file.is_text_mode_specification (file.mode))
			file.write_string (sample_text)
			file.write_boolean (True)
			file.write_character ('Y')
			file.write_double (123.4)
			file.write_character (' ')
			file.write_integer (1234)
			file.write_character (' ')
			file.write_real (123.4)
			file.put (sample_text)
			file.close
		end

	test_reading is
		-- Test file reading, depends on `test_writing'.
		local
			file: STDC_BINARY_FILE
		do
			test_writing
			create file.open_read ("test.berend")
			file.read_string (sample_text.count)
			assert_equal ("Read exactly what written.", sample_text, file.last_string)
			file.read_boolean
			assert_equal ("Read exactly what written.", True, file.last_boolean)
			file.read_character
			assert_equal ("Read exactly what written.", 'Y', file.last_character)
			file.read_double
			assert ("Read almost (DOUBLE) what written.", (file.last_double - 123.4) < 0.01)
			-- skip space
			file.read_character
			file.read_integer
			assert_integers_equal ("Read exactly what written.", 1234, file.last_integer)
			file.read_character
			assert_equal ("Skip space.", ' ', file.last_character)
			file.read_real
			assert ("Read almost (REAL) what written.", (file.last_real - 123.4) < 0.01)
			file.close
		end

	test_temporary_file is
			-- Create a temporary file.
		local
			tmpfile: STDC_TEMPORARY_FILE
		do
			create tmpfile.make
			tmpfile.puts ("hello%N")
			tmpfile.close
		end

	test_reading_and_writing_bytes is
			-- Test writing and reading bytes.
		local
			file: STDC_BINARY_FILE
		do
			create file.create_read_write ("test.berend")
			file.getc
			assert ("Read something from an empty file gives eof.", file.eof)
			file.putc (65)
			file.rewind
			file.getc
			assert_integers_equal ("Read written byte.", 65, file.last_byte)
			-- Reopen the same file.
			file.reopen ("test.berend", "w")
			file.close
		end

	test_ungetc is
		local
			file: STDC_BINARY_FILE
		do
			create file.create_read_write ("test.berend")
			file.ungetc (65)
			file.getc
			assert_integers_equal ("Read written byte.", 65, file.last_byte)
			file.close
		end

	test_file_positioning is
		local
			textfile: STDC_TEXT_FILE
			pos: STDC_FILE_POSITION
		do
			create textfile.create_read_write ("test.berend")
			assert ("Not binary mode", not textfile.is_binary_mode_specification (textfile.mode))
			textfile.write_string ("hello")
			pos := textfile.get_position
			textfile.write_string ("world")
			textfile.set_position (pos)
			textfile.read_string (128)
			assert_equal ("Got correct string.", "world", textfile.last_string)
			textfile.close
		end

	test_buffering is
		local
			file: STDC_BINARY_FILE
			buf: STDC_BUFFER
		do
			test_create_write
			create file.open ("test.berend", "r")
			create buf.allocate (1024)
			file.setbuf (buf.ptr)
			file.set_full_buffering (buf.ptr, buf.capacity)
			file.set_line_buffering (buf.ptr, buf.capacity)
			file.set_no_buffering
			file.close
		end

	test_random_access is
		local
			file: STDC_BINARY_FILE
		do
			create file.create_read_write ("test.berend")
			file.write_string ("10")
			file.write_string ("20")
			file.write_string ("30")
			assert_integers_equal ("Current position.", 6, file.tell)
			file.seek (2)
			file.read_string (2)
			assert_equal ("Got correct string.", "20", file.last_string)
			file.seek_from_current (-2)
			file.read_string (2)
			assert_equal ("Got correct string.", "20", file.last_string)
			assert_integers_equal ("Current position.", 4, file.tell)
			file.seek_from_end (-4)
			file.read_string (2)
			assert_equal ("Got correct string.", "20", file.last_string)
			assert_integers_equal ("Current position.", 4, file.tell)
			file.close
		end


end
