indexing

	description:

		"MD5 implementation."

	thanks: "Nenie's CRYPT_MD5"
	library: "eposix library"
	standards: "Based on RFC 1321"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2008, Berend de Boer"
	license: "MIT License (see LICENSE)"
	date: "$Date$"
	revision: "$Revision$"


class

	EPX_MD5_CALCULATION


inherit

	EPX_HASH_CALCULATION
		rename
			binary_checksum as ABCD
		redefine
			put_string,
			secure_wipe_out,
			wipe_out
		end


create

	make


feature {NONE} -- Initialization

	make is
			-- Initialize.
		do
			create ABCD.allocate (hash_output_length)
			init_ABCD
			create block.allocate_and_clear (16 * 4)
		end


feature -- Access

	checksum: STRING is
		local
			j: INTEGER
			hi: INTEGER
		do
			if my_checksum = Void then
				create my_checksum.make (hash_output_length * 2)
				from
				until
					j = hash_output_length // 4
				loop
					hi := ABCD.peek_uint32_big_endian (j*4)
					append_zeros (my_checksum, hi)
					append_hexadecimal_integer (hi, my_checksum, False)
					j := j + 1
				end
			end
			Result := my_checksum
		end

	hash_output_length: INTEGER is 16
			-- Byte length of the hash output function


feature -- Operations

	put_buffer (buf: STDC_BUFFER; start, stop: INTEGER) is
		local
			j: INTEGER
		do
			from
				j := start
			variant
				stop - j + 1
			until
				j > stop
			loop
				from
				variant
					block_length - block_index + 1
				until
					block_index = block_length or else
					j > stop
				loop
					block.put_character (buf.peek_character (j), block_index)
					j := j + 1
					block_index := block_index + 1
				end
				if block_index = block_length then
					process_block
					block_index := 0
				end
			end
			number_of_bits := number_of_bits + (stop - start + 1) * 8
		ensure then
			number_of_bits_increased: number_of_bits = old number_of_bits + (stop - start + 1) * 8
			block_index_increased: block_index = (old block_index + (stop - start + 1)) \\ 64
		end

	put_character (c: CHARACTER) is
		do
			block.put_character (c, block_index)
			block_index := block_index + 1
			if block_index = block_length then
				process_block
				block_index := 0
			end
			number_of_bits := number_of_bits + 8
		ensure then
			number_of_bits_increased_by_eight: number_of_bits = old number_of_bits + 8
			block_index_increased_by_one: block_index = (old block_index + 1) \\ 64
		end

	put_string (s: STRING) is
		do
			precursor (s)
		ensure then
			number_of_bits_increased: number_of_bits = old number_of_bits + s.count * 8
			block_index_increased: block_index = (old block_index + s.count) \\ 64
		end

	put_substring (s: STRING; start, stop: INTEGER) is
		local
			j: INTEGER
		do
			from
				j := start
			variant
				stop - j + 1
			until
				j > stop
			loop
				from
				variant
					block_length - block_index + 1
				until
					block_index = block_length or else
					j > stop
				loop
					block.put_character (s.item (j), block_index)
					j := j + 1
					block_index := block_index + 1
				end
				if block_index = block_length then
					process_block
					block_index := 0
				end
			end
			number_of_bits := number_of_bits + (stop - start + 1) * 8
		ensure then
			number_of_bits_increased: number_of_bits = old number_of_bits + (stop - start + 1) * 8
			block_index_increased: block_index = (old block_index + (stop - start + 1)) \\ 64
		end

	finalize is
			-- Calculate checksum.
		local
			padding_length: INTEGER
			message_bits: INTEGER_64
		do
			message_bits := number_of_bits
			-- Pad out to 56 mod 64.
			if block_index < 56  then
				padding_length := 56 - block_index
			else
				padding_length := 120 - block_index
			end
			put_substring (padding, 1, padding_length)
				check
					room_for_length: block_index = block_length - 8
				end

			-- Append length of message before padding
			message_length.poke_int64_little_endian (0, message_bits)
			put_buffer (message_length, 0, 7)
				check
					all_processed: block_index = 0
				end
			-- Checksum now in H
			is_checksum_available := True
		end

	secure_wipe_out is
		local
			j: INTEGER
		do
			precursor
			from
			until
				j = block_index
			loop
				block.poke_uint8 (j, 0)
				j := j + 1
			end
		end

	wipe_out is
			-- Start a new calculation.
		do
			precursor
			my_checksum := Void
			block_index := 0
			create ABCD.allocate (hash_output_length)
			init_ABCD
			number_of_bits := 0
		ensure then
			empty: number_of_bits = 0
		end


feature {NONE} -- Implementation

	block_length: INTEGER is 64
			-- Length of a single block

	block_index: INTEGER

	block: STDC_BUFFER
			-- We process one block at a time

	init_ABCD is
		do
			ABCD.poke_int32_little_endian (0, 0x67452301)
			ABCD.poke_int32_little_endian (4, 0xefcdab89)
			ABCD.poke_int32_little_endian (8, 0x98badcfe)
			ABCD.poke_int32_little_endian (12, 0x10325476)
		end

	message_length: STDC_BUFFER is
			-- Temporary scratch buffer
		once
			create Result.allocate (8)
		ensure
			not_void: Result /= Void
			holds_64_bit: Result.capacity = 8
		end

	my_checksum: STRING
			-- Cached copy of `checksum'

	number_of_bits: INTEGER_64
			-- Number of bits in message

	padding: STRING is
		once
			create Result.make_filled ('%U', 64)
			Result.put ('%/128/', 1)
		ensure
			not_void: Result /= Void
			correct_length: Result.count = 64
		end

	process_block is
			-- Process a single block.
		require
			buffer_full: block_index = block_length
		local
			A, B, C, D,
			AA, BB, CC, DD: INTEGER
			block_0, block_1, block_2, block_3,
			block_4, block_5, block_6, block_7,
			block_8, block_9, block_10, block_11,
			block_12, block_13, block_14, block_15: INTEGER
		do
			-- Save A as AA, B as BB, C as CC, and D as DD
			A := ABCD.peek_uint32_little_endian (0)
			B := ABCD.peek_uint32_little_endian (4)
			C := ABCD.peek_uint32_little_endian (8)
			D := ABCD.peek_uint32_little_endian (12)
			AA := A
			BB := B
			CC := C
			DD := D

			debug ("md5")
				print ("MD5Transform.begin A: " + to_hexadecimal_integer (A) + "%N")
				print ("MD5Transform.begin B: " + to_hexadecimal_integer (B) + "%N")
				print ("MD5Transform.begin C: " + to_hexadecimal_integer (C) + "%N")
				print ("MD5Transform.begin D: " + to_hexadecimal_integer (D) + "%N")
			end

			block_0 := block.peek_uint32_little_endian (0)
			block_1 := block.peek_uint32_little_endian (4)
			block_2 := block.peek_uint32_little_endian (8)
			block_3 := block.peek_uint32_little_endian (12)
			block_4 := block.peek_uint32_little_endian (16)
			block_5 := block.peek_uint32_little_endian (20)
			block_6 := block.peek_uint32_little_endian (24)
			block_7 := block.peek_uint32_little_endian (28)
			block_8 := block.peek_uint32_little_endian (32)
			block_9 := block.peek_uint32_little_endian (36)
			block_10 := block.peek_uint32_little_endian (40)
			block_11 := block.peek_uint32_little_endian (44)
			block_12 := block.peek_uint32_little_endian (48)
			block_13 := block.peek_uint32_little_endian (52)
			block_14 := block.peek_uint32_little_endian (56)
			block_15 := block.peek_uint32_little_endian (60)

			debug ("md5")
				print ("MD5Transform.block  0: " + to_hexadecimal_integer (block_0) + "%N")
				print ("MD5Transform.block  1: " + to_hexadecimal_integer (block_1) + "%N")
				print ("MD5Transform.block  2: " + to_hexadecimal_integer (block_2) + "%N")
				print ("MD5Transform.block  3: " + to_hexadecimal_integer (block_3) + "%N")
				print ("MD5Transform.block  4: " + to_hexadecimal_integer (block_4) + "%N")
				print ("MD5Transform.block  5: " + to_hexadecimal_integer (block_5) + "%N")
				print ("MD5Transform.block  6: " + to_hexadecimal_integer (block_6) + "%N")
				print ("MD5Transform.block  7: " + to_hexadecimal_integer (block_7) + "%N")
				print ("MD5Transform.block  8: " + to_hexadecimal_integer (block_8) + "%N")
				print ("MD5Transform.block  9: " + to_hexadecimal_integer (block_9) + "%N")
				print ("MD5Transform.block 10: " + to_hexadecimal_integer (block_10) + "%N")
				print ("MD5Transform.block 11: " + to_hexadecimal_integer (block_11) + "%N")
				print ("MD5Transform.block 12: " + to_hexadecimal_integer (block_12) + "%N")
				print ("MD5Transform.block 13: " + to_hexadecimal_integer (block_13) + "%N")
				print ("MD5Transform.block 14: " + to_hexadecimal_integer (block_14) + "%N")
				print ("MD5Transform.block 15: " + to_hexadecimal_integer (block_15) + "%N")
			end

			-- Round 1
			A := FF (A, B, C, D, block_0, 7, sin_01)
			D := FF (D, A, B, C, block_1, 12, sin_02)
			C := FF (C, D, A, B, block_2, 17, sin_03)
			B := FF (B, C, D, A, block_3, 22, sin_04)
			A := FF (A, B, C, D, block_4, 7, sin_05)
			D := FF (D, A, B, C, block_5, 12, sin_06)
			C := FF (C, D, A, B, block_6, 17, sin_07)
			B := FF (B, C, D, A, block_7, 22, sin_08)
			A := FF (A, B, C, D, block_8, 7, sin_09)
			D := FF (D, A, B, C, block_9, 12, sin_10)
			C := FF (C, D, A, B, block_10, 17, sin_11)
			B := FF (B, C, D, A, block_11, 22, sin_12)
			A := FF (A, B, C, D, block_12, 7, sin_13)
			D := FF (D, A, B, C, block_13, 12, sin_14)
			C := FF (C, D, A, B, block_14, 17, sin_15)
			B := FF (B, C, D, A, block_15, 22, sin_16)

			-- Round 2
			A := GG (A, B, C, D, block_1, 5, sin_17)
			D := GG (D, A, B, C, block_6, 9, sin_18)
			C := GG (C, D, A, B, block_11, 14, sin_19)
			B := GG (B, C, D, A, block_0, 20, sin_20)
			A := GG (A, B, C, D, block_5, 5, sin_21)
			D := GG (D, A, B, C, block_10, 9, sin_22)
			C := GG (C, D, A, B, block_15, 14, sin_23)
			B := GG (B, C, D, A, block_4, 20, sin_24)
			A := GG (A, B, C, D, block_9, 5, sin_25)
			D := GG (D, A, B, C, block_14, 9, sin_26)
			C := GG (C, D, A, B, block_3, 14, sin_27)
			B := GG (B, C, D, A, block_8, 20, sin_28)
			A := GG (A, B, C, D, block_13, 5, sin_29)
			D := GG (D, A, B, C, block_2, 9, sin_30)
			C := GG (C, D, A, B, block_7, 14, sin_31)
			B := GG (B, C, D, A, block_12, 20, sin_32)

			-- Round 3
			A := HH (A, B, C, D, block_5, 4, sin_33)
			D := HH (D, A, B, C, block_8, 11, sin_34)
			C := HH (C, D, A, B, block_11, 16, sin_35)
			B := HH (B, C, D, A, block_14, 23, sin_36)
			A := HH (A, B, C, D, block_1, 4, sin_37)
			D := HH (D, A, B, C, block_4, 11, sin_38)
			C := HH (C, D, A, B, block_7, 16, sin_39)
			B := HH (B, C, D, A, block_10, 23, sin_40)
			A := HH (A, B, C, D, block_13, 4, sin_41)
			D := HH (D, A, B, C, block_0, 11, sin_42)
			C := HH (C, D, A, B, block_3, 16, sin_43)
			B := HH (B, C, D, A, block_6, 23, sin_44)
			A := HH (A, B, C, D, block_9, 4, sin_45)
			D := HH (D, A, B, C, block_12, 11, sin_46)
			C := HH (C, D, A, B, block_15, 16, sin_47)
			B := HH (B, C, D, A, block_2, 23, sin_48)

			-- Round 4
			A := II (A, B, C, D, block_0, 6, sin_49)
			D := II (D, A, B, C, block_7, 10, sin_50)
			C := II (C, D, A, B, block_14, 15, sin_51)
			B := II (B, C, D, A, block_5, 21, sin_52)
			A := II (A, B, C, D, block_12, 6, sin_53)
			D := II (D, A, B, C, block_3, 10, sin_54)
			C := II (C, D, A, B, block_10, 15, sin_55)
			B := II (B, C, D, A, block_1, 21, sin_56)
			A := II (A, B, C, D, block_8, 6, sin_57)
			D := II (D, A, B, C, block_15, 10, sin_58)
			C := II (C, D, A, B, block_6, 15, sin_59)
			B := II (B, C, D, A, block_13, 21, sin_60)
			A := II (A, B, C, D, block_4, 6, sin_61)
			D := II (D, A, B, C, block_11, 10, sin_62)
			C := II (C, D, A, B, block_2, 15, sin_63)
			B := II (B, C, D, A, block_9, 21, sin_64)

			debug ("md5")
				print ("MD5Transform.new A: " + to_hexadecimal_integer (A) + "%N")
				print ("MD5Transform.new B: " + to_hexadecimal_integer (B) + "%N")
				print ("MD5Transform.new C: " + to_hexadecimal_integer (C) + "%N")
				print ("MD5Transform.new D: " + to_hexadecimal_integer (D) + "%N")
			end

			-- Increment each of the four registers by the value it had
			-- before this block was started.
			ABCD.poke_int32_little_endian (0, AA + A)
			ABCD.poke_int32_little_endian (4, BB + B)
			ABCD.poke_int32_little_endian (8, CC + C)
			ABCD.poke_int32_little_endian (12, DD + D)
		end


feature {NONE} -- MD5 functions

	FF (aa, bb, cc, dd, x: INTEGER; s: INTEGER_8; ac: INTEGER): INTEGER is
			-- Let [abcd x s i] denote the operation
			-- f() = b + ((a + F(b,c,d) + x + T[i]) unsigned_rotate_left s)
		require
			shift_positive: s > 0
		do
			Result := aa + F (bb, cc, dd) + x + ac
			Result := bit_rotate_left (Result, s)
			Result := Result + bb
		end

	GG (aa, bb, cc, dd, x: INTEGER; s: INTEGER_8; ac: INTEGER): INTEGER is
			-- Let [abcd k s i] denote the operation
			-- f() = b + ((a + G(b,c,d) + x + T[i]) unsigned_rotate_left s)
		require
			shift_positive: s > 0
		do
			Result := aa + G (bb, cc, dd) + x + ac
			Result := bit_rotate_left (Result, s)
			Result := Result + bb
		end

	HH (aa, bb, cc, dd, x: INTEGER; s: INTEGER_8; ac: INTEGER): INTEGER is
			-- Let [abcd k s i] denote the operation
			-- f() = b + ((a + H(b,c,d) + x + T[i]) unsigned_rotate_left s)
		require
			shift_positive: s > 0
		do
			Result := aa + H (bb, cc, dd) + x + ac
			Result := bit_rotate_left (Result, s)
			Result := Result + bb
		end

	II (aa, bb, cc, dd, x: INTEGER; s: INTEGER_8; ac: INTEGER): INTEGER is
			-- Let [abcd k s i] denote the operation
			-- f() = b + ((a + I(b,c,d) + x + T[i]) unsigned_rotate_left s)
		require
			shift_positive: s > 0
		do
			Result := aa + I (bb, cc, dd) + x + ac
			Result := bit_rotate_left (Result, s)
			Result := Result + bb
		end


feature {NONE} -- MD5 primitives

	F (xx, yy, zz: INTEGER): INTEGER is
			-- F(X,Y,Z) = XY v not(X) Z.
		do
			Result := (xx & yy) | (xx.bit_not & zz)
		end

	G (xx, yy, zz: INTEGER): INTEGER is
			-- G(X,Y,Z) = XZ v Y not(Z).
		do
			Result := (xx & zz) | (yy & zz.bit_not)
		end

	H (xx, yy, zz: INTEGER): INTEGER is
			-- H(X,Y,Z) = X xor Y xor Z.
		do
			Result := xx.bit_xor (yy.bit_xor (zz))
		end

	I (xx, yy, zz: INTEGER): INTEGER is
			-- I(X,Y,Z) = Y xor (X | not(Z))
		do
			Result := yy.bit_xor (xx | zz.bit_not)
		end


feature {NONE} -- MD5 sin table: T[i] = int part of 4294967296 * (abs(sin(i)))

	sin_01: INTEGER is -680876936
	sin_02: INTEGER is -389564586
	sin_03: INTEGER is 606105819
	sin_04: INTEGER is -1044525330
	sin_05: INTEGER is -176418897
	sin_06: INTEGER is 1200080426
	sin_07: INTEGER is -1473231341
	sin_08: INTEGER is -45705983
	sin_09: INTEGER is 1770035416
	sin_10: INTEGER is -1958414417
	sin_11: INTEGER is -42063
	sin_12: INTEGER is -1990404162
	sin_13: INTEGER is 1804603682
	sin_14: INTEGER is -40341101
	sin_15: INTEGER is -1502002290
	sin_16: INTEGER is 1236535329
	sin_17: INTEGER is -165796510
	sin_18: INTEGER is -1069501632
	sin_19: INTEGER is 643717713
	sin_20: INTEGER is -373897302
	sin_21: INTEGER is -701558691
	sin_22: INTEGER is 38016083
	sin_23: INTEGER is -660478335
	sin_24: INTEGER is -405537848
	sin_25: INTEGER is 568446438
	sin_26: INTEGER is -1019803690
	sin_27: INTEGER is -187363961
	sin_28: INTEGER is 1163531501
	sin_29: INTEGER is -1444681467
	sin_30: INTEGER is -51403784
	sin_31: INTEGER is 1735328473
	sin_32: INTEGER is -1926607734
	sin_33: INTEGER is -378558
	sin_34: INTEGER is -2022574463
	sin_35: INTEGER is 1839030562
	sin_36: INTEGER is -35309556
	sin_37: INTEGER is -1530992060
	sin_38: INTEGER is 1272893353
	sin_39: INTEGER is -155497632
	sin_40: INTEGER is -1094730640
	sin_41: INTEGER is 681279174
	sin_42: INTEGER is -358537222
	sin_43: INTEGER is -722521979
	sin_44: INTEGER is 76029189
	sin_45: INTEGER is -640364487
	sin_46: INTEGER is -421815835
	sin_47: INTEGER is 530742520
	sin_48: INTEGER is -995338651
	sin_49: INTEGER is -198630844
	sin_50: INTEGER is 1126891415
	sin_51: INTEGER is -1416354905
	sin_52: INTEGER is -57434055
	sin_53: INTEGER is 1700485571
	sin_54: INTEGER is -1894986606
	sin_55: INTEGER is -1051523
	sin_56: INTEGER is -2054922799
	sin_57: INTEGER is 1873313359
	sin_58: INTEGER is -30611744
	sin_59: INTEGER is -1560198380
	sin_60: INTEGER is 1309151649
	sin_61: INTEGER is -145523070
	sin_62: INTEGER is -1120210379
	sin_63: INTEGER is 718787259
	sin_64: INTEGER is -343485551


invariant

	H_not_void: ABCD /= Void
	H_has_five_elements: ABCD.capacity = hash_output_length -- 4 * sizeOf(uint32)
	block_not_void: block /= Void
	block_has_correct_length: block.capacity = 64 -- 16 * 4
	valid_block_index: block_index >= 0 and then block_index <= block_length
	block_never_full: block_index /= block_length

end
