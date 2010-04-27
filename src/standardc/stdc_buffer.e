indexing

	description: "Standard C linear piece of memory, starting with index 0. Memory is dynamically allocated. Size should be at least 1 byte%
	%large. 0 size memory is not supported."

	remark: "If you treat this as an array, it is zero based."
	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #12 $"


class

	STDC_BUFFER

inherit

	STDC_HANDLE [POINTER]
		rename
			close as deallocate,
			handle as ptr,
			is_open as is_allocated
		redefine
			copy,
			do_close,
			is_equal
		end

	STDC_SYSTEM
		export
			{NONE} all
		undefine
			copy,
			is_equal
		end

	CAPI_STDLIB
		export
			{NONE} all
		undefine
			copy,
			is_equal
		end

	CAPI_STRING
		export
			{NONE} all
		undefine
			copy,
			is_equal
		end

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		undefine
			copy,
			is_equal
		end


create

	allocate,
	allocate_and_clear,
	make_from_pointer


feature -- Allocation

	allocate (a_capacity: INTEGER) is
			-- Allocate memory of `a_capacity' bytes.
			-- If `is_owner' then the buffer is first deallocated.
		require
			valid_capacity: a_capacity > 0
			allocation_of_capacity_allowed: security.memory.is_allowed_allocation (a_capacity)
			memory_bounds_not_exceeded: security.memory.is_within_maximum (a_capacity)
		local
			new_ptr: POINTER
		do
			security.memory.check_allocation (a_capacity)
			if is_owner then
				deallocate
			elseif is_allocated then
				detach
			end
			new_ptr := posix_malloc (a_capacity)
			if new_ptr = default_pointer then
				raise_posix_error
			else
				set_capacity (a_capacity)
				set_handle (new_ptr, True)
			end
		ensure
			allocated: is_allocated
			owner: is_owner
			capacity_set: capacity = a_capacity
			tracked_memory_increased:
				security.memory.is_allocated_memory_increased (is_owner, old security.memory.allocated_memory, capacity)
		end

	allocate_and_clear (a_capacity: INTEGER) is
			-- Allocate memory of `a_capacity' bytes, make sure it's zeroed out.
			-- If `is_owner' then the buffer is first deallocated.
		require
			valid_capacity: a_capacity > 0
			allowed: security.memory.is_allowed_allocation (a_capacity)
			memory_bounds_not_exceeded: security.memory.is_within_maximum (a_capacity)
		local
			new_ptr: POINTER
		do
			security.memory.check_allocation (a_capacity)
			if is_owner then
				deallocate
			elseif is_allocated then
				detach
			end
			new_ptr := posix_calloc (a_capacity, 1)
			if new_ptr = default_pointer then
				raise_posix_error
			else
				set_capacity (a_capacity)
				set_handle (new_ptr, True)
			end
		ensure
			allocated: is_allocated
			owner: is_owner
			capacity_set: capacity = a_capacity
			tracked_memory_increased:
				not old is_owner implies security.memory.is_allocated_memory_increased (is_owner, old security.memory.allocated_memory, capacity)
		end

	make_from_pointer (
			a_pointer: POINTER; a_capacity: INTEGER;
			a_become_owner: BOOLEAN) is
			-- Attach a pointer to this object. If `a_become_owner' is
			-- True, it will deallocate the pointer when `close' is
			-- called, or when this object is garbage collected.
		require
			valid_capacity: a_capacity > 0
			valid_pointer: a_pointer /= default_pointer
			allowed: a_become_owner implies security.memory.is_allowed_allocation (a_capacity)
		do
			if a_become_owner then
				security.memory.check_allocation (a_capacity)
			end
			if is_owner then
				deallocate
			elseif is_allocated then
				detach
			end
			set_capacity (a_capacity)
			attach_to_handle (a_pointer, a_become_owner)
		ensure
			allocated: is_allocated
			pointer_set: ptr = a_pointer
			capacity_set: capacity = a_capacity
			owner_set: a_become_owner = is_owner
			resource_accounted_for:
				security.memory.is_allocated_memory_increased (is_owner, old security.memory.allocated_memory, capacity)
		end


feature -- Other allocation commands

	resize (new_capacity: INTEGER) is
			-- Resize memory to `new_capacity' bytes. Expanded memory is not
			-- guaranteed to be zeroed out.
		require
			valid_capacity: new_capacity > 0
			allocated: is_allocated
			may_resize: is_owner
			allowed: security.memory.is_allowed_allocation (new_capacity)
			memory_bounds_not_exceeded: new_capacity > capacity implies security.memory.is_within_maximum (new_capacity - capacity)
		local
			new_ptr: POINTER
		do
			security.memory.check_allocation (new_capacity)
			new_ptr := posix_realloc (ptr, new_capacity)
			if new_ptr = default_pointer then
				raise_posix_error
			else
				clear_handle
				set_capacity (new_capacity)
				set_handle (new_ptr, True)
			end
		ensure
			successfull_allocation: is_allocated
			capacity_set: raise_exception_on_error implies capacity >= new_capacity
			tracked_memory_changed:
				memory.collecting or else
				(raise_exception_on_error implies
					(security.memory.allocated_memory = (old security.memory.allocated_memory - old capacity) + new_capacity))
		end


feature -- Element change

	copy (other: like Current) is
			-- Reinitialize by copying the characters of `other'.
			-- (This is also used by `twin'.)
		do
			if other /= Current then
				if other.is_owner then
					allocate (other.capacity)
					memory_copy (other.ptr, 0, 0, other.capacity)
				else
					make_from_pointer (other.ptr, other.capacity, False)
				end
			end
		ensure then
			same_capacity: capacity = other.capacity
			owner_status_unchanged: is_owner = other.is_owner
			different_pointer_if_owner: other.is_owner = (ptr /= other.ptr)
		end


feature -- Comparison

	is_equal (other: like Current): BOOLEAN is
			-- Is `other' attached to an object considered equal to
			-- current object ?
		local
			i: INTEGER
		do
			if other = Current or else other.ptr = Current.ptr then
				Result := True
			else
				if capacity = other.capacity then
					from
					until
						i = capacity or else
						peek_character (i) /= other.peek_character (i)
					loop
						i := i + 1
					end
					Result := i = capacity
				else
					Result := False
				end
			end
		end


feature -- Access

	resource_usage_can_be_increased: BOOLEAN is
			-- Can the number of allocated resources increased with `capacity'?
		do
			Result := security.memory.is_within_maximum (capacity)
		end


feature -- Copy data internally or externally

	copy_from (source: STDC_BUFFER; src_offset, dest_offset, bytes: INTEGER) is
			-- Move data from another buffer into ourselves.
			-- Start at offset `src_offset', into
			-- offset `dest_offset', moving `bytes' bytes
			-- Memory may overlap.
		require
			valid_source: source /= Void
			valid_source_offset: src_offset >= 0 and
										src_offset + bytes <= source.capacity
			valid_dest_offset: dest_offset >= 0 and
									 dest_offset + bytes <= capacity
			valid_bytes_to_move: bytes >= 0
		do
			if source.ptr = Current.ptr then
				move (src_offset, dest_offset, bytes)
			else
				memory_move (source.ptr, src_offset, dest_offset, bytes)
			end
		end

	memory_copy (source: POINTER; src_offset: INTEGER; dest_offset, bytes: INTEGER) is
			-- Copy data from `source', offset `src_offset', to location
			-- `dest_offset' in this buffer, for `bytes' bytes.
			-- Memory may not overlap, use `move' to copy within buffer
			-- or `memory_move' to copy from potentially overlapping buffer.
		require
			my_memory_does_not_overlap: True
			I_know_what_I_am_doing: True
			valid_source: source /= default_pointer
			dest_offset_not_negative: dest_offset >= 0
			data_should_fit: dest_offset + bytes <= capacity
			valid_bytes_to_move: bytes >= 0
		local
			src,
			dest: POINTER
		do
			src := source + src_offset
			dest := ptr + dest_offset
			posix_memcpy (dest, src, bytes)
		end

	memory_move (source: POINTER; src_offset: INTEGER; dest_offset, bytes: INTEGER) is
			-- Copy data from `source', offset `src_offset', to location
			-- `dest_offset' in this buffer, for `bytes' bytes.
			-- Memory may overlap.
		require
			valid_source: source /= default_pointer
			data_should_fit: dest_offset + bytes <= capacity
			valid_bytes_to_move: bytes >= 0
		local
			src,
			dest: POINTER
		do
			src := source + src_offset
			dest := ptr + dest_offset
			posix_memmove (dest, src, bytes)
		end

	move (src_offset, dest_offset: INTEGER; bytes: INTEGER) is
			-- Move data around in buffer itself from offset `src_offset' to
			-- offset `dest_offset', moving `bytes' bytes.
			-- Memory may overlap.
		require
			valid_source_offset: src_offset >= 0 and src_offset + bytes <= capacity
			valid_dest_offset: dest_offset >= 0 and dest_offset + bytes <= capacity
		local
			src,
			dest: POINTER
		do
			src := ptr + src_offset
			dest := ptr + dest_offset
			posix_memmove (dest, src, bytes)
		end


feature -- Access

	handle: POINTER is
			-- Alias for `ptr'
		do
			Result := ptr
		ensure
			definition: Result = ptr
		end


feature -- Set/get bytes (8-bit data)

	peek_uint8, infix "@" (index: INTEGER): INTEGER is
			-- consider memory an array of 8 bit values.
		require
			valid_index: is_valid_index (index)
		do
			Result := posix_peek_uint8 (ptr, index)
		ensure
			possible_values: Result >= 0 and Result < 256
		end

	poke_uint8 (index, value: INTEGER) is
		require
			valid_index: is_valid_index (index)
			valid_byte: value >= 0 and value < 256
		do
			posix_poke_uint8 (ptr, index, value)
		ensure
			consistent: peek_uint8 (index) = value
		end

	peek_int8 (index: INTEGER): INTEGER is
			-- consider memory an array of 8 bit values.
		require
			valid_index: is_valid_index (index)
		local
			byte_value: INTEGER
		do
			byte_value := posix_peek_uint8 (ptr, index)
			if byte_value > 127 then
				Result := byte_value - 256
			else
				Result := byte_value
			end
		ensure
			possible_values: Result >= -128 and Result <= 127
		end

	poke_int8 (index, value: INTEGER) is
		require
			valid_index: is_valid_index (index)
			valid_tinyin: value >= -128 and value <= 127
		local
			byte_value: INTEGER
		do
			if value < 0 then
				byte_value := 256 + value
			else
				byte_value := value
			end
			posix_poke_uint8 (ptr, index, byte_value)
		ensure
			consistent: peek_int8 (index) = value
		end


feature -- Set/get integers (16-bit data)

	peek_int16, peek_int16_native (index: INTEGER): INTEGER is
			-- Read signed 16 bit value at offset `index' in native
			-- endian format.
		require
			valid_index: is_valid_range (index, index + 1)
		do
			Result := posix_peek_int16_native (ptr, index)
		ensure
			valid_result: Result >= -32768 and Result <= 32767
		end

	peek_uint16, peek_uint16_native (index: INTEGER): INTEGER is
			-- Read unsigned 16 bit value at offset `index' in native format.
		require
			valid_index: is_valid_range (index, index + 1)
		do
			Result := posix_peek_uint16_native (ptr, index)
		ensure
			valid_result: Result >= 0 and Result <= 65535
		end

	peek_int16_big_endian (index: INTEGER): INTEGER is
			-- Read 16 bit value at offset `index' in big endian format.
		require
			valid_index: is_valid_range (index, index + 1)
		local
			i: INTEGER
		do
			i := posix_peek_int16_native (ptr, index)
			if is_little_endian then
				i := posix_swap16 (i)
			end
			Result := i
		ensure
			valid_result: Result >= -32768 and Result <= 32767
		end

	peek_uint16_big_endian (index: INTEGER): INTEGER is
			-- Read 16 bit value at offset `index' in big endian format.
		require
			valid_index: is_valid_range (index, index + 1)
		local
			i: INTEGER
		do
			i := posix_peek_uint16_native (ptr, index)
			if is_little_endian then
				i := posix_swap16 (i)
			end
			Result := i
		ensure
			valid_result: Result >= 0 and Result <= 65535
		end

	peek_int16_little_endian (index: INTEGER): INTEGER is
			-- Read 16 bit value at offset `index' in little endian format.
		require
			valid_index: is_valid_range (index, index + 1)
		local
			i: INTEGER
		do
			i := posix_peek_int16_native (ptr, index)
			if is_big_endian then
				i := posix_swap16 (i)
			end
			Result := i
		ensure
			valid_result: Result >= -32768 and Result <= 32767
		end

	peek_uint16_little_endian (index: INTEGER): INTEGER is
			-- Read 16 bit value at offset `index' in little endian format.
		require
			valid_index: is_valid_range (index, index + 1)
		local
			i: INTEGER
		do
			i := posix_peek_uint16_native (ptr, index)
			if is_big_endian then
				i := posix_swap16 (i)
			end
			Result := i
		ensure
			valid_result: Result >= 0 and Result <= 65535
		end

	poke_int16, poke_int16_native (index: INTEGER; value: INTEGER) is
			-- Write 16 bit value at offset `index', in native endian format.
		require
			valid_index: is_valid_range (index, index + 1)
			valid_value: value >= -32768 and value <= 32767
		do
			posix_poke_int16_native (ptr, index, value)
		ensure
			consistent: peek_int16_native (index) = value
		end

	poke_int16_big_endian (index: INTEGER; value: INTEGER) is
			-- Write 16 bit value at offset `index', in big endian format.
		require
			valid_index: is_valid_range (index, index + 1)
			valid_value: value >= -32768 and value <= 32767
		local
			i: INTEGER
		do
			if is_little_endian then
				i := posix_swap16 (value)
			else
				i := value
			end
			posix_poke_int16_native (ptr, index, i)
		ensure
			consistent: peek_int16_big_endian (index) = value
		end

	poke_int16_little_endian (index: INTEGER; value: INTEGER) is
			-- Write 16 bit value at offset `index', in little endian format.
		require
			valid_index: is_valid_range (index, index + 1)
			valid_value: value >= -32768 and value <= 32767
		local
			i: INTEGER
		do
			if is_big_endian then
				i := posix_swap16 (value)
			else
				i := value
			end
			posix_poke_int16_native (ptr, index, i)
		ensure
			consistent: peek_int16_little_endian (index) = value
		end


feature -- Set/get integers (32-bit data)

	peek_int32_native, peek_integer (index: INTEGER): INTEGER is
			-- Read 32 bit value at offset `index', assume its byte order
			-- is native, and return it.
		require
			valid_index: is_valid_range (index, index + 3)
		do
			Result := posix_peek_int32_native (ptr, index)
		end

	peek_int32_big_endian (index: INTEGER): INTEGER is
			-- Read 32 bit value at offset `index', assume its byte order
			-- is big endian, and return it in native format.
		require
			valid_index: is_valid_range (index, index + 3)
		local
			i: INTEGER
		do
			i := posix_peek_int32_native (ptr, index)
			if is_little_endian then
				i := posix_swap32 (i)
			end
			Result := i
		end

	peek_int32_little_endian (index: INTEGER): INTEGER is
			-- Read 32 bit value at offset `index', assume its byte order
			-- is little endian, and return it in native format.
		require
			valid_index: is_valid_range (index, index + 3)
		local
			i: INTEGER
		do
			i := posix_peek_int32_native (ptr, index)
			if is_big_endian then
				i := posix_swap32 (i)
			end
			Result := i
		end

	peek_uint32_native (index: INTEGER): INTEGER is
			-- Read 32 bit unsigned int at offset `index', assume native
			-- byte order.
		require
			valid_index: is_valid_range (index, index + 3)
		do
			Result := posix_peek_uint32_native (ptr, index)
		end

	peek_uint32_big_endian (index: INTEGER): INTEGER is
			-- Read 32 bit unsigned int at offset `index', assume its
			-- byte order is big endian, and return it in native format.
		require
			valid_index: is_valid_range (index, index + 3)
		local
			i: INTEGER
		do
			i := posix_peek_uint32_native (ptr, index)
			if is_little_endian then
				i := posix_swap32 (i)
			end
			Result := i
		end

	peek_uint32_little_endian (index: INTEGER): INTEGER is
			-- Read 32 bit unsigned int at offset `index', assume its
			-- byte order is big endian, and return it in native format.
		require
			valid_index: is_valid_range (index, index + 3)
		local
			i: INTEGER
		do
			i := posix_peek_uint32_native (ptr, index)
			if is_big_endian then
				i := posix_swap32 (i)
			end
			Result := i
		end

	poke_integer, poke_int32_native (index: INTEGER; value: INTEGER) is
			-- Write 32 bit value at offset `index', in native endian format.
		require
			valid_index: is_valid_range (index, index + 3)
		do
			posix_poke_int32_native (ptr, index, value)
		ensure
			consistent: peek_integer (index) = value
		end

	poke_int32_big_endian (index: INTEGER; value: INTEGER) is
			-- Write 32 bit value at offset `index', in big endian format.
		require
			valid_index: is_valid_range (index, index + 3)
		local
			i: INTEGER
		do
			if is_little_endian then
				i := posix_swap32 (value)
			else
				i := value
			end
			posix_poke_int32_native (ptr, index, i)
		ensure
			consistent: peek_int32_big_endian (index) = value
		end

	poke_int32_little_endian (index: INTEGER; value: INTEGER) is
			-- Write 32 bit value at offset `index', in little endian format.
		require
			valid_index: is_valid_range (index, index + 3)
		local
			i: INTEGER
		do
			if is_big_endian then
				i := posix_swap32 (value)
			else
				i := value
			end
			posix_poke_int32_native (ptr, index, i)
		ensure
			consistent: peek_int32_little_endian (index) = value
		end


feature -- Set/get integers (64-bit data)

	peek_int64_native, peek_integer_64 (index: INTEGER): INTEGER_64 is
			-- Read 64 bit value at offset `index', assume its byte order
			-- is native, and return it.
		require
			valid_index: is_valid_range (index, index + 7)
		do
			Result := posix_peek_int64_native (ptr, index)
		end

	peek_int64_big_endian (index: INTEGER): INTEGER_64 is
			-- Read 64 bit int at offset `index', assume its
			-- byte order is big endian, and return it in native format.
		require
			valid_index: is_valid_range (index, index + 7)
		local
			i: INTEGER_64
		do
			i := posix_peek_int64_native (ptr, index)
			if is_little_endian then
				i := posix_swap64 (i)
			end
			Result := i
		end

	peek_int64_little_endian (index: INTEGER): INTEGER_64 is
			-- Read 64 bit int at offset `index', assume its
			-- byte order is little endian, and return it in native format.
		require
			valid_index: is_valid_range (index, index + 7)
		local
			i: INTEGER_64
		do
			i := posix_peek_int64_native (ptr, index)
			if is_big_endian then
				i := posix_swap64 (i)
			end
			Result := i
		end

	poke_integer_64, poke_int64_native (index: INTEGER; value: INTEGER_64) is
			-- Write 64 bit value at offset `index', in native endian format.
		require
			valid_index: is_valid_range (index, index + 7)
		do
			posix_poke_int64_native (ptr, index, value)
		ensure
			consistent: peek_integer_64 (index) = value
		end

	poke_int64_big_endian (index: INTEGER; value: INTEGER_64) is
			-- Write 64 bit value at offset `index', in big endian format.
		require
			valid_index: is_valid_range (index, index + 7)
		local
			i: INTEGER_64
		do
			if is_little_endian then
				i := posix_swap64 (value)
			else
				i := value
			end
			posix_poke_int64_native (ptr, index, i)
		ensure
			consistent: peek_int64_big_endian (index) = value
		end

	poke_int64_little_endian (index: INTEGER; value: INTEGER_64) is
			-- Write 64 bit value at offset `index', in little endian format.
		require
			valid_index: is_valid_range (index, index + 7)
		local
			i: INTEGER_64
		do
			if is_big_endian then
				i := posix_swap64 (value)
			else
				i := value
			end
			posix_poke_int64_native (ptr, index, i)
		ensure
			consistent: peek_int64_little_endian (index) = value
		end


feature -- Set/get characters

	append_to_string (dest: STRING; start_index, end_index: INTEGER) is
			-- Append all characters from `start_index' to `end_index'
			-- inclusive to `dest'.
		require
			dest_not_void: dest /= Void
			valid_range: is_valid_range (start_index, end_index)
		local
			i: INTEGER
		do
			from
				i := start_index
			until
				i > end_index
			loop
				dest.append_character (posix_peek_character (ptr, i))
				i := i + 1
			end
		ensure
			dest_count_as_asked: dest.count = old dest.count + (end_index - start_index + 1)
		end

	peek_character (index: INTEGER): CHARACTER is
			-- Return value at `index' as an 8-bit character.
		require
			valid_index: is_valid_index (index)
		do
			Result := posix_peek_character (ptr, index)
		end

	poke_character (index: INTEGER; value: CHARACTER) is
			-- Set character at `index' index to `value'.
		require
			valid_index: is_valid_index (index)
		do
			posix_poke_character (ptr, index, value)
		ensure
			consistent: peek_character (index) = value
		end

	put_character (c: CHARACTER; index: INTEGER) is
			-- Set character at `index' index to `value'.
			-- Same as `peek_character' with more Eiffel like parameter order.
		require
			valid_index: is_valid_index (index)
		do
			posix_poke_character (ptr, index, c)
		ensure
			consistent: peek_character (index) = c
		end

	put_string (s: STRING; a_start_index, an_end_index: INTEGER) is
			-- Put `s' starting at index `start_index'. `s' is written up
			-- to `end_index' or when there are no more characters in
			-- `s'.
		require
			s_not_void: s /= Void
			valid_index: is_valid_range (a_start_index, an_end_index)
		local
			end_index: INTEGER
			i, j: INTEGER
		do
			from
				i := a_start_index
				j := 1
				end_index := an_end_index.min (a_start_index + s.count - 1)
			invariant
				j >= 1 and (j <= s.count or i > end_index)
				i <= an_end_index + 1
			variant
				(end_index - i) + 1
			until
				i > end_index
			loop
				poke_character (i, s.item (j))
				j := j + 1
				i := i + 1
			end
		end

	put_to_string (dest: STRING; pos, start_index, end_index: INTEGER) is
			-- Put characters from `start_index' to `end_index' inclusive
			-- in `dest' starting at position `pos'.
			-- Useful for Gobo character buffers.
		require
			dest_not_void: dest /= Void
			valid_index: is_valid_range (start_index, end_index)
			valid_start_position: dest.valid_index (pos)
			valid_end_position: dest.valid_index (pos + (end_index - start_index))
		local
			i, j: INTEGER
		do
			from
				i := start_index
				j := pos
			until
				i > end_index
			loop
				-- I expect inlined C to be even faster, perhaps
				-- experiment with moving this entire loop to C?
				dest.put (posix_peek_character (ptr, i), j)
				i := i + 1
				j := j + 1
			end
		end

	c_substring_with_string (dest: STRING; start_index, end_index: INTEGER) is
			-- As `c_substring' but used `dest' as the destination.
		require
			have_destination: dest /= Void
			valid_index: is_valid_range (start_index, end_index)
		local
			i: INTEGER
			c: CHARACTER
		do
			if dest.count > 0 then
				STRING_.wipe_out (dest)
			end
			from
				i := start_index
				c := posix_peek_character (ptr, i)
			variant
				(end_index + 1) - i
			until
				c = '%U' or else i > end_index
			loop
				dest.append_character (c)
				i := i + 1
				c := posix_peek_character (ptr, i)
			end
		ensure
			dest_count_as_asked: dest.count <= end_index - start_index + 1
		end

	c_substring (start_index, end_index: INTEGER): STRING is
			-- Create a substring containing all characters from
			-- `start_index' up to encountering a %U or when `end_index' is
			-- reached, whatever happens first.
		require
			valid_index: is_valid_range (start_index, end_index)
		local
			count: INTEGER
		do
			count := end_index - start_index + 1
			create Result.make (count)
			c_substring_with_string (Result, start_index, end_index)
		ensure
			substring_not_void: Result /= Void
			substring_count_as_asked: Result.count <= end_index - start_index + 1
		end

	substring (start_index, end_index: INTEGER): STRING is
			-- Create a substring containing all characters
			-- from start_index to end_index inclusive.
		require
			valid_index: is_valid_range (start_index, end_index)
		local
			count: INTEGER
			i: INTEGER
		do
			count := end_index - start_index + 1
			create Result.make (count)
			from
				i := start_index
			until
				i > end_index
			loop
				Result.append_character (posix_peek_character (ptr, i))
				i := i + 1
			end
		ensure
			substring_not_void: Result /= Void
			substring_count_as_asked: Result.count = end_index - start_index + 1
		end


feature -- Fill

	fill_at (start_index, a_count: INTEGER; byte: INTEGER) is
			-- Starting at position `start_index', write `byte' for `a_count' bytes
		require
			valid_range: is_valid_range (start_index, start_index + a_count-1)
			valid_byte: byte >= 0 and byte <= 255
		local
			p: POINTER
		do
			--p := posix_pointer_add (ptr, start_index)
			p := ptr + start_index
			posix_memset (p, byte, a_count)
		end


feature -- Searching

	locate_character (other: CHARACTER; start_index: INTEGER): INTEGER is
			-- Return index of `other' in buffer, or -1.
			-- Search begins at `start_index'.
		require
			valid_start_index: is_valid_index (start_index)
		local
			i: INTEGER
			Found: BOOLEAN
		do
			from
				i := start_index
			until
				Found or else i > capacity
			loop
				Found := posix_peek_character (ptr, i) = other
				i := i + 1
			end
			if Found then
				Result := i - 1
			else
				Result := -1
			end
		ensure
			result_in_range: Result >= -1 and Result < capacity
			result_after_start_index: Result >= start_index
		end

	locate_string (other: STRING; start_index: INTEGER): INTEGER is
			-- Does buffer contain 'other'?
			-- Returns index where `other' is found.
			-- Returns -1 if not found
			-- searching starts at position `start_index'
		require
			other_not_empty: other /= Void and then not other.is_empty
			valid_index: is_valid_index (start_index)
		local
			stop: BOOLEAN
			i1, i2, i3: INTEGER
			index: INTEGER
		do
			if capacity >= other.count then
				-- the following smart search algorithm shamelessly
				-- copied from SE
				from
					index := -1
					i1 := start_index
					i3 := other.count
					i2 := i1 + i3 - 1
				invariant
					i3 = i2 - i1 + 1
				variant
					(capacity + 1) - i1
				until
					index >= 0
				loop
					if i2 >= capacity then
						index := capacity
					else
						from
							stop := False
							-- invariant
							--    i3 = i2 - i1 + 1
							-- variant
							--    (i3 + i2 + 1)
						until
							stop
						loop
							if other.item (i3) /= posix_peek_character (ptr, i2) then
								stop := True
							else
								i3 := i3 - 1
								if i3 = 0 then
									stop := True
									index := i1
								else
									i2 := i2 - 1
								end
							end
						end
					end
					i1 := i1 + 1
					i3 := other.count
					i2 := i1 + i3 - 1
				end
				if index < capacity then
					Result := index
				else
					Result := -1
				end
			else
				Result := -1
			end
		ensure
			false_if_too_small: capacity < other.count implies Result = -1
			valid_result: Result >= -1 and Result < capacity
		end


feature -- Status

	is_valid_index (index: INTEGER): BOOLEAN is
		do
			Result := index >= 0 and index < capacity
		end

	is_valid_range (from_index, to_index: INTEGER): BOOLEAN is
			-- Is `from_index'..`to_index' a valid and meaningfull range?
		do
			Result :=
				from_index >= 0 and from_index < capacity and
				to_index >= from_index and to_index < capacity
		end


feature {NONE} -- Low level handle functions

	do_close: BOOLEAN is
			-- Close resource, return error if any, or zero on
			-- success. This routine may never call another object, else
			-- it cannot be used safely in `dispose'.
		do
			posix_free (ptr)
			clear_handle
			Result := True
		end

	set_capacity (a_capacity: INTEGER) is
			-- Only routine that modifies `capacity'.
		require
			capacity_valid: a_capacity >= 0
		do
			capacity := a_capacity
		ensure
			capacity_changed: capacity = a_capacity
		end

	frozen unassigned_value: POINTER is
			-- The value that indicates that `handle' is unassigned.
		do
			Result := default_pointer
		end


feature {NONE} -- Counting of allocated resource

	decrease_allocated_memory (amount: INTEGER) is
			-- Decrease our idea of allocated memory. Does not call any
			-- object, so can be called from `dispose'.
		require
			amount_not_negative: amount >= 0
		external "C"
		alias "posix_decrease_allocated_memory"
		end

	decrease_resource_count is
			-- Decrease number of allocated resource by `capacity'.
			-- Due to limitations of certain Eiffel implementations, this
			-- routine may not call any other object. Calling C code is safe.
		do
			decrease_allocated_memory (capacity)
		end

	increase_resource_count is
			-- Increase number of allocated resources by `capacity'.
		do
			security.memory.increase_memory_allocation (capacity)
		end

	resource_count: INTEGER is
			-- Currently allocated number of resources. It's a global
			-- number, counting the `capacity' of all owned resources of
			-- this type.
		do
			Result := security.memory.allocated_memory
		end


feature {NONE} -- POSIX C interface

	posix_peek_character (p: POINTER; index: INTEGER): CHARACTER is
			-- Read character at position `index'.
		require
			valid_memory: p /= default_pointer
		external "C inline"
		alias "[
*((EIF_CHARACTER*)(((char*)$p) + $index))
]"
		end

	posix_peek_int16_native (p: POINTER; index: INTEGER): INTEGER is
			-- Read word at position `index'.
		require
			valid_memory: p /= default_pointer
		external "C"
		end

	posix_peek_int32_native (p: POINTER; index: INTEGER): INTEGER is
			-- Read integer at position `index'.
		require
			valid_memory: p /= default_pointer
		external "C inline"
		alias "[
*((EIF_INTEGER*)(((char*)$p) + $index))
]"
		end

	posix_peek_int64_native (p: POINTER; index: INTEGER): INTEGER_64 is
			-- Read integer at position `index'.
		require
			valid_memory: p /= default_pointer
		external "C inline"
		alias "[
*((EIF_INTEGER_64*)(((char*)$p) + $index))
]"
		end

	posix_peek_uint8 (p: POINTER; index: INTEGER): INTEGER is
			-- Read unsigned 8 bit value at position `index'.
		require
			valid_memory: p /= default_pointer
		external "C"
		end

	posix_peek_uint16_native (p: POINTER; index: INTEGER): INTEGER is
			-- Read unsigned 16 bit value at position `index'.
		require
			valid_memory: p /= default_pointer
		external "C"
		end

	posix_peek_uint32_native (p: POINTER; index: INTEGER): INTEGER is
			-- Read unsigned 32 bit value at position `index'.
		require
			valid_memory: p /= default_pointer
		external "C"
		end

	posix_poke_uint8 (p: POINTER; index: INTEGER; value: INTEGER) is
			-- Set byte at position `index'.
		require
			valid_memory: p /= default_pointer
		external "C"
		end

	posix_poke_character (p: POINTER; offset: INTEGER; value: CHARACTER) is
			-- Set character at position `index'.
		require
			valid_memory: p /= default_pointer
		external "C inline"
		alias "[
*((EIF_CHARACTER*)(((char*)$p) + $offset)) = $value;
]"
		end

	posix_poke_int16_native (p: POINTER; offset: INTEGER; value: INTEGER) is
			-- Put a 16 bit integer at offset `offset'.
		require
			valid_memory: p /= default_pointer
		external "C"
		end

	posix_poke_int32_native (p: POINTER; offset: INTEGER; value: INTEGER) is
			-- Put a signed 32 bit integer at offset `offset'.
		require
			valid_memory: p /= default_pointer
		external "C inline"
		alias "[
*((EIF_INTEGER*)(((char*)$p) + $offset)) = $value;
]"
		end

	posix_poke_int64_native (p: POINTER; offset: INTEGER; value: INTEGER_64) is
			-- Put a signed 32 bit integer at offset `offset'.
		require
			valid_memory: p /= default_pointer
		external "C inline"
		alias "[
*((EIF_INTEGER_64*)(((char*)$p) + $offset)) = $value;
]"
		end


feature {NONE} -- Endian operations

	posix_swap16 (i: INTEGER): INTEGER is
			-- Reverse byte order for lower 2 bytes, upper 2 bytes are
			-- zeroed out.
		external "C"
		end

	posix_swap32 (i: INTEGER): INTEGER is
			-- Reverse byte order.
		external "C"
		end

	posix_swap64 (i: INTEGER_64): INTEGER_64 is
			-- Reverse byte order.
		external "C"
		end


end
