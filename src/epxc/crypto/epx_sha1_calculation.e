indexing

	description:

		"SHA1 implementation."

	library: "eposix library"
	standards: "Based on method one from RFC 3174"
	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2008, Berend de Boer"
	license: "MIT License (see LICENSE)"
	date: "$Date$"
	revision: "$Revision$"


class

	EPX_SHA1_CALCULATION


inherit

	EPX_HASH_CALCULATION
		rename
			binary_checksum as H
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
			create H.allocate (hash_output_length)
			init_H
			create block.allocate_and_clear (W_count)
		end


feature -- Access

	checksum: STRING is
		local
			i: INTEGER
			hi: INTEGER
		do
			if my_checksum = Void then
				create my_checksum.make (hash_output_length * 2)
				from
				until
					i = hash_output_length // 4
				loop
					hi := h.peek_uint32_big_endian (i*4)
					append_zeros (my_checksum, hi)
					append_hexadecimal_integer (hi, my_checksum, False)
					i := i + 1
				end
			end
			Result := my_checksum
		end

	hash_output_length: INTEGER is 20
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
			message_length.poke_int64_big_endian (0, message_bits)
			put_buffer (message_length, 0, 7)
				check
					all_processed: block_index = 0
				end
			-- Checksum now in H
			is_checksum_available := True
		end

	secure_wipe_out is
		local
			i: INTEGER
		do
			precursor
			from
			until
				i = block_index
			loop
				block.poke_uint8 (i, 0)
				i := i + 1
			end
		end

	wipe_out is
			-- Start a new calculation.
		do
			precursor
			my_checksum := Void
			block_index := 0
			create H.allocate (hash_output_length)
			init_H
			number_of_bits := 0
		ensure then
			empty: number_of_bits = 0
		end


feature {NONE} -- Implementation

	block_length: INTEGER is 64
			-- Length of a single block

	W_count: INTEGER is 320
			-- Room for 80 32-bit words

	block_index: INTEGER

	block: STDC_BUFFER
			-- We process one block at a time

	init_H is
		do
			H.poke_int32_big_endian (0, 0x67452301)
			H.poke_int32_big_endian (4, 0xEFCDAB89)
			H.poke_int32_big_endian (8, 0x98BADCFE)
			H.poke_int32_big_endian (12, 0x10325476)
			H.poke_int32_big_endian (16, 0xC3D2E1F0)
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
		require
			buffer_full: block_index = block_length
		local
			t: INTEGER
			temp: INTEGER
			h0, h1, h2, h3, h4: INTEGER
			a, b, c, d, e: INTEGER
			f: INTEGER
		do
			debug ("sha1")
				from
					t := 0
				until
					t = 16
				loop
					print ("msg[" + t.out + "]=")
					temp := block.peek_uint32_big_endian (t * 4)
					print (to_hexadecimal_integer (temp))
					print ("%N")
					t := t + 1
				end
			end

			-- Step b.
			debug ("sha1")
				print ("Starting block at word 0%N")
				from
					t := 0
				until
					t = 16
				loop
					print ("W[" + t.out + "]=")
					temp := block.peek_uint32_big_endian (t * 4)
					print (to_hexadecimal_integer (temp))
					print ("%N")
					t := t + 1
				end
			end
			from
				t := 16
			variant
				80 - t
			until
				t = 80
			loop
-- 				print ("W[t-3]="  + to_hexadecimal_integer (block.peek_uint32_big_endian ((t-3)*4)) + "%N")
-- 				print ("W[t-8]="  + to_hexadecimal_integer (block.peek_uint32_big_endian ((t-8)*4)) + "%N")
-- 				print ("W[t-14]="  + to_hexadecimal_integer (block.peek_uint32_big_endian ((t-14)*4)) + "%N")
-- 				print ("W[t-16]="  + to_hexadecimal_integer (block.peek_uint32_big_endian ((t-16)*4)) + "%N")
-- 				a := block.peek_uint32_big_endian ((t-3)*4)
-- 				b := block.peek_uint32_big_endian ((t-8)*4)
-- 				c := block.peek_uint32_big_endian ((t-14)*4)
-- 				d := block.peek_uint32_big_endian ((t-16)*4)
-- 				print ("rotate "  + to_hexadecimal_integer (a.bit_xor (b.bit_xor (c.bit_xor (d)))) + "%N")
				temp := bit_rotate_left (block.peek_uint32_big_endian ((t-3)*4).bit_xor (block.peek_uint32_big_endian ((t-8)*4).bit_xor (block.peek_uint32_big_endian ((t-14)*4).bit_xor (block.peek_uint32_big_endian ((t-16)*4)))), 1)
				block.poke_int32_big_endian (t*4, temp)
				debug ("sha1")
					temp := block.peek_uint32_big_endian (t * 4)
					print ("W[" + t.out + "]=")
					print (to_hexadecimal_integer (temp))
					print ("%N")
				end
				t := t + 1
			end

			-- Step c.
			h0 := h.peek_uint32_big_endian (0)
			h1 := h.peek_uint32_big_endian (4)
			h2 := h.peek_uint32_big_endian (8)
			h3:= h.peek_uint32_big_endian (12)
			h4 := h.peek_uint32_big_endian (16)
			a := h0
			b := h1
			c := h2
			d := h3
			e := h4
			debug ("sha1")
				print ("A=" + to_hexadecimal_integer (a) + " B=" + to_hexadecimal_integer (b) + " C=" + to_hexadecimal_integer (c) + " D=" + to_hexadecimal_integer (d) + " E=" + to_hexadecimal_integer (e) + "%N")
			end

			-- Step d.
			-- Assumes Eiffel integer overflow detection is disabled...
			from
				t := 0
			variant
				80 - t + 1
			until
				t = 20
			loop
				f := (b & c) | (b.bit_not & d)
				temp := bit_rotate_left (a, 5) + f + e + block.peek_int32_big_endian (t*4) + 0x5A827999
				e := d
				d := c
				c := bit_rotate_left (b, 30)
				b := a
				a := temp
				debug ("sha1")
					print ("i=" + t.out + " A=" + to_hexadecimal_integer (a) + " B=" + to_hexadecimal_integer (b) + " C=" + to_hexadecimal_integer (c) + " D=" + to_hexadecimal_integer (d) + " E=" + to_hexadecimal_integer (e) + "%N")
				end
				t := t + 1
			end
			from
			variant
				80 - t + 1
			until
				t = 40
			loop
				f := b.bit_xor (c.bit_xor (d))
				temp := bit_rotate_left (a, 5) + f + e + block.peek_int32_big_endian (t*4) + 0x6ED9EBA1
				e := d
				d := c
				c := bit_rotate_left (b, 30)
				b := a
				a := temp
				debug ("sha1")
					print ("i=" + t.out + " A=" + to_hexadecimal_integer (a) + " B=" + to_hexadecimal_integer (b) + " C=" + to_hexadecimal_integer (c) + " D=" + to_hexadecimal_integer (d) + " E=" + to_hexadecimal_integer (e) + "%N")
				end
				t := t + 1
			end
			from
			variant
				80 - t + 1
			until
				t = 60
			loop
				f := (b & c) | (b & d) | (c & d)
				temp := bit_rotate_left (a, 5) + f + e + block.peek_int32_big_endian (t*4) + 0x8F1BBCDC
				e := d
				d := c
				c := bit_rotate_left (b, 30)
				b := a
				a := temp
				debug ("sha1")
					print ("i=" + t.out + " A=" + to_hexadecimal_integer (a) + " B=" + to_hexadecimal_integer (b) + " C=" + to_hexadecimal_integer (c) + " D=" + to_hexadecimal_integer (d) + " E=" + to_hexadecimal_integer (e) + "%N")
				end
				t := t + 1
			end
			from
			variant
				80 - t + 1
			until
				t = 80
			loop
				f := b.bit_xor (c.bit_xor (d))
				temp := bit_rotate_left (a, 5) + f + e + block.peek_int32_big_endian (t*4) + 0xCA62C1D6
				e := d
				d := c
				c := bit_rotate_left (b, 30)
				b := a
				a := temp
				debug ("sha1")
					print ("i=" + t.out + " A=" + to_hexadecimal_integer (a) + " B=" + to_hexadecimal_integer (b) + " C=" + to_hexadecimal_integer (c) + " D=" + to_hexadecimal_integer (d) + " E=" + to_hexadecimal_integer (e) + "%N")
				end
				t := t + 1
			end

			-- Step e.
			H.poke_int32_big_endian (0, h0 + a)
			H.poke_int32_big_endian (4, h1 + b)
			H.poke_int32_big_endian (8, h2 + c)
			H.poke_int32_big_endian (12, h3 + d)
			H.poke_int32_big_endian (16, h4 + e)
			debug ("sha1")
				print ("H0=" + to_hexadecimal_integer (h.peek_int32_big_endian (0)) + " B=" + to_hexadecimal_integer (h.peek_int32_big_endian (4)) + " C=" + to_hexadecimal_integer (c) + " D=" + to_hexadecimal_integer (d) + " E=" + to_hexadecimal_integer (e) + "%N")
			end
		end


invariant

	H_not_void: H /= Void
	H_has_five_elements: H.capacity = hash_output_length -- 5 * sizeOf(uint32)
	block_not_void: block /= Void
	block_has_correct_length: block.capacity = W_count
	valid_block_index: block_index >= 0 and then block_index <= block_length
	block_never_full: block_index /= block_length

end
