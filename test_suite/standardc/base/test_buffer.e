indexing

	description: "Test Standard C buffer class."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


deferred class

	TEST_BUFFER


inherit

	TS_TEST_CASE

	STDC_BASE


feature

	test_environment is
		local
			buf,
			buf2: STDC_BUFFER
			byte: INTEGER
			c: CHARACTER
			i: INTEGER
			b1, b2: INTEGER
		do
			create buf.allocate (100)
			buf.deallocate

			create buf.allocate_and_clear (100)
			assert_integers_equal ("Expect zero.", 0, buf.peek_integer (50))
			buf.resize (256)

			buf.poke_uint8 (0, 16)
			byte := buf.peek_uint8 (0)
			assert_integers_equal ("Byte poked.", 16, byte)

			buf.poke_int8 (1, -1)
			byte := buf.peek_uint8 (1)
			assert_integers_equal ("Byte poked.", 255,  byte)

			buf.poke_int8 (1, -127)
			byte := buf.peek_uint8 (1)
			assert_integers_equal ("Poked unsigned byte.", 129, byte)

			buf.poke_int8 (255, -128)
			byte := buf.peek_uint8 (255)
			assert_integers_equal ("Byte poked.", 128, byte)

			buf.poke_int8 (1, 1)
			byte := buf.peek_int8 (1)
			assert_integers_equal ("Signed byte poked", 1, byte)

			buf.move (0, 1, 1)
			byte := buf.peek_uint8 (1)
			assert_integers_equal ("Byte moved.", 16, byte)

			c := '%/141/';
			buf.poke_character (0, c)
			byte := buf.peek_uint8 (0)
			assert_integers_equal ("Character poked.", 141, byte)

			buf.poke_int32_little_endian (0, 16909060) -- 0x01020304
			i := buf.peek_int32_big_endian (0)
			assert_integers_equal ("Big endian byte peeked.",  67305985, i)
			i := buf.peek_int32_little_endian (0)
			assert_integers_equal ("Little endian byte peeked.", 16909060, i) -- 0x04030201

			buf.poke_int32_big_endian (6, 16909060) -- 0x01020304
			i := buf.peek_int32_big_endian (6)
			assert_integers_equal ("Big endian peekded.", 16909060, i) -- 0x04030201
			i := buf.peek_int32_little_endian (6)
			assert_integers_equal ("Little endian peeked.",  67305985, i) -- 0x04030201

			buf.poke_int16_little_endian (6, 258) -- 0x0102
			buf.poke_int16_big_endian (6, 258) -- 0x0102
			i := buf.peek_int16_big_endian (6)
			assert_integers_equal ("16 bit big endian peeked." , 258, i)
			i := buf.peek_int16_little_endian (6)
			assert_integers_equal ("16 bit little endian peeked.", 513, i) -- 0x0201

			buf.poke_int16_native (15, -1)
			i := buf.peek_uint16_native (15)
			assert_integers_equal ("16 bit native unsigned int peeked.", 65535, i)

			-- test copy_from
			create buf2.allocate_and_clear (100)
			buf2.copy_from (buf, 0, 50, 4)
			i := buf2.peek_int32_little_endian (50)
			assert_integers_equal ("32 bit little endian peeked.", 16909060, i) -- 0x04030201

			-- test memset
			buf2.fill_at (10, 5, 55)
			b1 := buf2.peek_uint8 (10)
			b2 := buf2.peek_uint8 (14)
			assert_integers_equal ("First byte read.", 55, b1)
			assert_integers_equal ("Second byte read.", 55, b2)

			-- Deallocate the memory.
			buf.deallocate
		end

	test_make_from_pointer is
		local
			buf1,
			buf2: STDC_BUFFER
		do
			create buf1.allocate (100)
			create buf2.make_from_pointer (buf1.ptr, buf1.capacity, False)
			buf2.make_from_pointer (buf1.ptr, buf1.capacity, False)
			buf2.become_owner
			buf1.unown
			buf2.deallocate
		end

	test_locate is
		local
			buf: STDC_BUFFER
			i: INTEGER
		do
			create buf.make_from_pointer (sh.string_to_pointer (hello), hello.count, False)
			i := buf.locate_character ('!', 5)
			assert_integers_equal ("Correct position.", 11, i)
			i := buf.locate_string ("Hello", 0)
			assert_integers_equal ("Correct position.", 0, i)
			i := buf.locate_string ("Hello", 1)
			assert_integers_equal ("Not found.", -1, i)
			i := buf.locate_string ("ld!", 0)
			assert_integers_equal ("Correct position.", 9, i)
			i := buf.locate_string ("ld!", 9)
			assert_integers_equal ("Correct position.", 9, i)
			i := buf.locate_string ("ld!", 10)
			assert_integers_equal ("Not found.", -1, i)
		end


feature {NONE} -- Implementation

	hello: STRING is "Hello World!"


end
