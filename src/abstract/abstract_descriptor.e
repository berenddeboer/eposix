indexing

	description: "Base class that covers all generic descriptor routines."

	idea: "Functions here are also available under Windows more or less.%
	%This also means that an abstract descriptor cannot be converted to a%
	%stream, because Windows doesn't support that."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"


deferred class

	ABSTRACT_DESCRIPTOR


inherit

	HASHABLE

	STDC_HANDLE_BASED_IO_STREAM [INTEGER]
		rename
			handle as fd,
			read_to_buffer as non_blocking_read_to_buffer,
			read_character as non_blocking_read_character,
			read_string as non_blocking_read_string,
			read_to_string as non_blocking_read_to_string
		redefine
			do_close,
			is_open,
			non_blocking_read_to_buffer,
			non_blocking_read_to_string,
			valid_unread_character
		end

	EPX_POINTER_HELPER
		export
			{NONE} all
		end


feature -- Initialization

	make is
		do
			do_make
		end


feature {NONE} -- Initialization

	do_make is
		require
			closed: not is_open
		do
			make_path
			clear_handle
		ensure
			fd_unassigned: fd = unassigned_value
		end


feature -- Special creation

	attach_to_descriptor (a_fd: INTEGER; a_become_owner: BOOLEAN) is
			-- Create descriptor with value `a_fd'. Descriptor will close
			-- it when `a_become_owner'.
		require
			closed: not is_open
			valid_file_descriptor: a_fd >= 0
		do
			do_make
			capacity := 1
			attach_to_handle (a_fd, a_become_owner)
			is_open_read := True
			is_open_write := True
		ensure
			open: is_open
			readable_and_writable: is_open_read and is_open_write
			owner_set: a_become_owner = is_owner
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end

	make_as_duplicate (another: ABSTRACT_DESCRIPTOR) is
			-- On creation, create a duplicate from another descriptor.
			-- As normal call, closes its own descriptor first (if open) and
			-- duplicates next.
		require
			another_file_descriptor_not_void: another /= Void
			another_open: another.is_open
		local
			old_fd,
			a_fd: INTEGER
		do
			make_path
			if is_open then
				old_fd := fd
				detach
				a_fd := abstract_dup2 (another.value, old_fd)
			else
				a_fd := abstract_dup (another.value)
			end
			if a_fd = -1 then
				raise_posix_error
			else
				capacity := 1
				set_handle (a_fd, True)
				is_open_read := True
				is_open_write := True
			end
		ensure
			open: raise_exception_on_error implies is_open
			own_descriptor: is_open implies is_owner
			open_files_increased_if_closed:
				memory.collecting or else
				(old (not is_open) implies
					security.files.open_files = old security.files.open_files + 1)
			open_files_not_increased_if_open:
				memory.collecting or else
				((old is_open and then old is_owner) implies
					security.files.open_files = old security.files.open_files)
		end


feature -- Read and write to memory block

	last_blocked: BOOLEAN
			-- Would last call to `read' or `write' block?

	read (buf: POINTER; offset, nbytes: INTEGER) is
			-- Read data into `buf' at `offset' for `nbytes' bytes.
			-- The number of bytes actually read, is available in `last_read'.
		require
			open_read: is_open_read
			valid_buf: buf /= default_pointer
			valid_size: nbytes >= 0
			-- `nbytes' < SSIZE_MAX (POSIX value?)
		local
			temp_buffer: STDC_BUFFER
			remaining_bytes: INTEGER
		do
				check
					internal_consistency_check: line_buffer /= Void implies (line_buffer_must_be_refilled or else buf /= line_buffer.ptr)
				end
			if line_buffer = Void or else line_buffer_must_be_refilled then
				do_read (buf, offset, nbytes)
			else
				end_of_input := False
				last_blocked := False
				last_read := 0
				errno.clear
				create temp_buffer.make_from_pointer (buf + offset, nbytes, False)
				remaining_bytes := line_buffer.count - line_buffer_index
				if remaining_bytes >= nbytes then
					last_read := nbytes
				else
					last_read := remaining_bytes
				end
				temp_buffer.copy_from (line_buffer, line_buffer_index, 0, last_read)
				line_buffer_index := line_buffer_index + last_read
			end
		ensure
			read_no_more_than_requested: last_read <= nbytes
			end_of_input_only_when_nothing_read: end_of_input implies last_read = 0
			blocked_only_when_nothing_read: last_blocked implies last_read = 0
			end_of_input_and_blocked_are_exclusive:
				(end_of_input implies not last_blocked) and (last_blocked implies not end_of_input)
		end

	write (buf: POINTER; offset, nbytes: INTEGER) is
			-- Write given data from `buf' at `offset', for `nbytes'
			-- bytes. Number of actually written bytes are in
			-- `last_written'. `last_written' can be unequal to `nbytes'
			-- if i/o is non-blocking or some error has occurred.
		require
			can_write: is_open
			valid_buf: buf /= default_pointer
			valid_size: nbytes >= 0
		local
			ptr: POINTER
			nwritten,
			nleft: INTEGER
			e: INTEGER
		do
			last_written := 0
			last_blocked := False
			errno.clear
			if nbytes > 0 then
				from
					nwritten := 0
					nleft := nbytes
				invariant
					nleft = 0 or else nbytes = nleft + last_written
-- `nleft' doesn't do, can remain unchanged in a loop.
-- Therefore no guarantee that this loop terminates...
-- 				variant
-- 					nleft
				until
					nleft = 0
				loop
					ptr := buf + (offset + last_written)
					nwritten := abstract_write (fd, ptr, nleft)
					if nwritten = -1 then
						if errno.value = abstract_EWOULDBLOCK then
							-- Blocked
							errno.clear -- this is not an error
							nleft := 0 -- loop variant + exit loop
							last_blocked := True
						elseif errno.value = abstract_EINTR then -- test if interrupted
							errno.clear -- this is not an error
							nwritten := 0 -- call write() again
							-- And here why the loop variant does not work.
							-- We cannot decrement `nleft'.
						else
							e := errno.value -- debug help
							raise_posix_error
							-- In case exceptions disabled, exit loop.
							nleft := 0
						end
					else
						nleft := nleft - nwritten
						last_written := last_written + nwritten
					end
				end
			end
		ensure
			wrote_no_more_than_requested: last_written <= nbytes
		end


feature {NONE} -- Raw read

	do_read (buf: POINTER; offset, nbytes: INTEGER) is
			-- Read data into `buf' at `offset' for `nbytes' bytes.
			-- The number of bytes actually read are available in `last_read'.
			-- Don't mix this routine with `read_string' or `read_character'!
		require
			open_read: is_open_read
			valid_buf: buf /= default_pointer
			valid_size: nbytes >= 0
			-- `nbytes' < SSIZE_MAX (POSIX value?)
		local
			ptr: POINTER
			nread,
			nleft: INTEGER
		do
			end_of_input := False
			last_blocked := False
			last_read := 0
			errno.clear
			if nbytes > 0 then
				from
					nread := 0
					nleft := nbytes
				invariant
					nleft = 0 or else nbytes = nleft + last_read
-- Same as in `write', no guarantee this loop terminates.
-- 				variant
-- 					nleft
				until
					nleft = 0 or else last_blocked
				loop
					ptr := buf + (offset + last_read)
					nread := abstract_read (fd, ptr, nleft)
					if nread = -1 then -- test if error occurred
						if errno.value = abstract_EWOULDBLOCK then
							-- Blocked
							errno.clear -- this is not an error
							-- Satisfy loop invariant, finish loop.
							nleft := 0
							-- Set blocked only if nothing read, else return
							-- with data just read.
							last_blocked := last_read = 0
							-- This is not an error
						elseif errno.value = abstract_EINTR then -- test if interrupted
							errno.clear -- this is not an error
							nread := 0 -- call read() again
							-- And here is the non-terminating loop problem.
							-- `nleft' is not decremented, and we might be
							-- interrupted at every `abstract_read'.
						else
							raise_posix_error
							-- In case exceptions are disabled, exit loop.
							nleft := 0
						end
					else
						-- FreeBSD sets errno to EWOULDBLOCK if we cannot
						-- read all data, even for blocking i/o. So we have
						-- to reset it here, else our error detection is wrecked.
						errno.clear
						if nread = 0 then
							-- Set end_of_input only when nothing read the first time.
							end_of_input := nleft = nbytes
							-- Satisfy loop invariant, finish loop.
							nleft := 0
						else
							last_read := last_read + nread
							-- Do not read more than what is available,
							-- else application might block.
							nleft := 0
						end
					end
				end
			end
		ensure
			read_no_more_than_requested: last_read <= nbytes
			end_of_input_only_when_nothing_read: end_of_input implies last_read = 0
			blocked_only_when_nothing_read: last_blocked implies last_read = 0
			end_of_input_and_blocked_are_exclusive:
				(end_of_input implies not last_blocked) and (last_blocked implies not end_of_input)
			last_blocked_can_only_be_set_when_enabled: last_blocked implies not is_blocking_io
		end


feature -- Read/write to/from STDC_BUFFER

	read_buffer (buf: STDC_BUFFER; offset, nbytes: INTEGER) is
			-- Read data into `buf' at `offset' for `nbytes' bytes.
			-- Number of bytes actually read are available in `last_read'.
			-- This is a more safe version of `read' in case you have a
			-- STDC_BUFFER object.
		do
			read (buf.ptr, offset, nbytes)
		end

	put_buffer, write_buffer (buf: STDC_BUFFER; offset, nbytes: INTEGER) is
			-- More safe version of `write' in case you have a
			-- STDC_BUFFER object.
		do
			write (buf.ptr, offset, nbytes)
		end


feature -- Eiffel like output

	put (a: ANY) is
			-- Write any Eiffel object as string using its `out' value.
		do
			if a /= Void then
				put_string (a.out)
			end
		end

	put_character (c: CHARACTER) is
			-- Write a character.
		do
			temp_character := c
			write ($temp_character, 0, 1)
		end

	write_character (c: CHARACTER) is
			-- Write a character.
		require
			is_open_write: is_open_write
		do
			put_character (c)
		end

	write_string, puts (a_string: STRING) is
			-- Write `a_string' to output stream.
		require
			is_open_write: is_open_write
			a_string_not_void: a_string /= Void
		do
			put_string (a_string)
		end

	put_string (a_string: STRING) is
			-- Write `a_string' to output stream.
		local
			p: POINTER
			uc: UC_STRING
		do
			uc ?= a_string
			if uc /= Void then
				p := sh.uc_string_to_pointer (uc)
				write (p, 0, uc.byte_count)
			else
				p := sh.string_to_pointer (a_string)
				write (p, 0, a_string.count)
			end
			sh.unfreeze_all
		end


feature -- Buffered input

	non_blocking_read_to_buffer (a_buffer: KI_BUFFER [CHARACTER]; pos, nb: INTEGER): INTEGER is
			-- Fill `a_buffer', starting at position `pos', with
			-- at most `nb' items read from input stream.
			-- Return the number of items actually read.
		local
			blocking_disabled: BOOLEAN
		do
			blocking_disabled := not is_blocking_io
			if blocking_disabled then
				set_blocking_io (True)
			end
			Result := precursor (a_buffer, pos, nb)
			if blocking_disabled then
				blocking_disabled := False
				set_blocking_io (False)
			end
		rescue
			if blocking_disabled then
				set_blocking_io (False)
			end
		end

	non_blocking_read_character is
			-- Read the next item in input stream.
			-- Make the result available in `last_item'.
		local
			blocking_disabled: BOOLEAN
		do
			blocking_disabled := not is_blocking_io
			if blocking_disabled then
				set_blocking_io (True)
			end
			read_character
			if blocking_disabled then
				blocking_disabled := False
				set_blocking_io (False)
			end
		rescue
			if blocking_disabled then
				set_blocking_io (False)
			end
		end

	non_blocking_read_string (nb: INTEGER) is
			-- Read at most `nb' characters from input stream.
			-- Make the characters that have actually been read
			-- available in `last_string'.
		local
			blocking_disabled: BOOLEAN
		do
			blocking_disabled := not is_blocking_io
			if blocking_disabled then
				set_blocking_io (True)
			end
			read_string (nb)
			if blocking_disabled then
				blocking_disabled := False
				set_blocking_io (False)
			end
		rescue
			if blocking_disabled then
				set_blocking_io (False)
			end
		end

	non_blocking_read_to_string (a_string: STRING; pos, nb: INTEGER): INTEGER is
			-- Fill `a_string', starting at position `pos', with
			-- at most `nb' characters read from input stream.
			-- Return the number of characters actually read.
		local
			blocking_disabled: BOOLEAN
		do
			blocking_disabled := not is_blocking_io
			if blocking_disabled then
				set_blocking_io (True)
			end
			Result := precursor (a_string, pos, nb)
			if blocking_disabled then
				blocking_disabled := False
				set_blocking_io (False)
			end
		rescue
			if blocking_disabled then
				set_blocking_io (False)
			end
		end

	read_character is
			-- Sets `last_character'.
			-- If this routine blocks, `last_character' has the value
			-- '%U'. Therefore, if non-blocking is enabled, always check
			-- `last_blocked' to see if the value make sense.
		require
			is_open_read: is_open_read
			not_end_of_input: not end_of_input
		do
			assert_have_line_buffer
			if line_buffer_must_be_refilled then
				read_buffer (line_buffer, 0, line_buffer.capacity)
				line_buffer.set_count (last_read)
				line_buffer_index := 0
			end
			if line_buffer_index < line_buffer.count then
				last_character := line_buffer.peek_character (line_buffer_index)
				line_buffer_index := line_buffer_index + 1
			else
				last_character := '%U'
			end
		ensure
			last_character_reset_on_end_of_input: end_of_input implies last_character = '%U'
			zero_character_on_block: last_blocked implies last_character = '%U'
		end

	read_line is
			-- Read characters from input stream until a line separator
			-- or end of file is reached. Make the characters that have
			-- been read available in `last_string' and discard the line
			-- separator characters from the input stream.
			-- Zero characters will be read when non-blocking i/o
			-- is enabled, and `read_line' would block at the first character.
			-- If a character has been read, `read_line' will block until
			-- a %N has been read or `end_of_input' occurs.
		local
			was_blocking_io: BOOLEAN
		do
			-- Make sure last_string has at least `nb' capacity.
			if last_string = Void then
				create last_string.make (1024)
			else
				STRING_.wipe_out (last_string)
			end

			-- Read up to newline or eof, whatever comes first.
			-- Routine probably can be improved somewhat by reading from
			-- line buffer directly and copying data in blocks instead of
			-- character by character.
			read_character
			if
				not last_blocked and then
				errno.is_ok and then
				not end_of_input
			then
				was_blocking_io := is_blocking_io
				if not was_blocking_io then
					set_blocking_io (True)
				end
				from
				until
					errno.is_not_ok or else
					end_of_input or else
					last_character = '%N'
				loop
					last_string.append_character (last_character)
					read_character
				end
				if not was_blocking_io then
					set_blocking_io (False)
				end
			end

			-- Have to remove %R character?
			if last_character = '%N' then
				-- We've read at least one character, so don't return `end_of_input'.
				-- Note that `last_string' might be empty, because we
				-- remove the end-of-line character.
				end_of_input := False
				if last_string.count > 0 and then last_string.item (last_string.count) = '%R' then
					last_string.remove (last_string.count)
				end
			else
				-- Line is empty or line does not end with end-of-line
				-- character. If read something, don't return end_of_input.
				if end_of_input and then not last_string.is_empty then
					end_of_input := False
				end
			end
		ensure then
			empty_if_blocked: last_blocked implies last_string.is_empty
		end

	read_new_line is
			-- Read a line separator from input file.
			-- Make the characters making up the recognized
			-- line separator available in `last_string',
			-- or make `last_string' empty and leave the
			-- input file unchanged if no line separator
			-- was found.
		do
			-- Not supported, so we never find a new line.
			STRING_.wipe_out (last_string)
		end

	read_string (nb: INTEGER) is
			-- Read at most `nb' characters from input stream.
			-- Make the characters that have actually been read
			-- available in `last_string'.
			-- Zero characters will be read when non-blocking i/o
			-- is enabled, and `read' would block.
		require
			is_open_read: is_open_read
			not_end_of_input: not end_of_input
			nb_large_enough: nb > 0
		local
			i: INTEGER
		do
			-- Make sure our buffer has at least `nb' capacity.
			assert_string_buffer_has_capacity (nb + 1)

			-- Read up to `nb' or `end_of_input', whatever comes first.
			read_buffer (string_buffer, 0, nb)
			if last_read = 0 then
				if last_string = Void then
					create last_string.make_empty
				else
					STRING_.wipe_out (last_string)
				end
			else
				-- Set end-of-string character.
				string_buffer.poke_character (last_read, '%U')
				-- Problem here is that an early occurrence of '%U' truncates
				-- the string.
				last_string := sh.pointer_to_string (string_buffer.ptr)
				-- If that occurs, we fix that here.
				if last_string.count < last_read then
					from
						i := last_string.count
					until
						i = last_read
					loop
						last_string.append_character (string_buffer.peek_character (i))
						i := i + 1
					end
				end
			end
			-- Note that `last_string' can be empty in case there was an
			-- error in `read' and exceptions are disabled.

			-- BdB: can I actually hit this code? Don't think so.
-- 			if end_of_input and then not last_string.is_empty then
-- 				end_of_input := False
-- 			end
		ensure
			last_string_not_void: not end_of_input implies last_string /= Void
			last_string_count_small_enough: not end_of_input implies last_string.count <= nb
			string_length_correct: not end_of_input implies (last_string.count = last_read)
			end_of_input_only_when_nothing_read:
				raise_exception_on_error implies
					(not last_blocked implies (last_string.is_empty = end_of_input))
			empty_only_when_blocked:
				raise_exception_on_error implies
					(not end_of_input implies (last_blocked = last_string.is_empty))
		end


	-- This is the naive implementation that will *not* work for sockets
	-- because it tries to read up to `nb' characters before returning.
	-- The best way is to read a block and return immediately after
	-- that block has been read.

-- 	read_string (nb: INTEGER) is
-- 			-- Read at most `nb' characters from input stream.
-- 			-- Make the characters that have actually been read
-- 			-- available in `last_string'.
-- 			-- Zero characters will be read when non-blocking i/o
-- 			-- is enabled, and `read' would block.
-- 		require
-- 			is_open_read: is_open_read
-- 			not_end_of_input: not end_of_input
-- 			nb_large_enough: nb > 0
-- 		do
-- 			-- Make sure last_string has at least `nb' capacity.
-- 			if last_string = Void then
-- 				if nb > 1024 then
-- 					create last_string.make ( nb)
-- 				else
-- 					create last_string.make (1024)
-- 				end
-- 			else
-- 				last_string.wipe_out
-- 			end

-- 			-- Read up to newline or `nb' or end_of_input, whatever comes first.
-- 			-- Routine probably can be improved somewhat by reading from
-- 			-- line buffer directly and copying data in blocks instead of
-- 			-- character by character.
-- 			from
-- 			until
-- 				last_string.count = nb or else end_of_input or else last_blocked
-- 			loop
-- 				read_character
-- 				if not end_of_input and then not last_blocked then
-- 					last_string.append_character (last_character)
-- 				end
-- 			end

-- 			if end_of_input and then not last_string.is_empty then
-- 				end_of_input := False
-- 			end
-- 		ensure
-- 			last_string_not_void: not end_of_input implies last_string /= Void
-- 			last_string_count_small_enough: last_string.count <= nb
-- 			end_of_input_only_when_nothing_read:
-- 				not last_blocked implies last_string.is_empty = end_of_input
-- 			empty_only_when_blocked:
-- 				not end_of_input implies last_blocked = last_string.is_empty
-- 		end


feature {NONE} -- Buffered reading support

	line_buffer: EPX_PARTIAL_BUFFER
			-- Buffer used in `read_character' and `read_line'

	string_buffer: STDC_BUFFER
			-- Buffer used in `read_string'

	line_buffer_index: INTEGER
			-- Offset to unread content in `line_buffer'

	line_buffer_must_be_refilled: BOOLEAN is
			-- Does `line_buffer_index' indicate that the end of
			-- `line_buffer' is reached?
		require
			have_line_buffer: line_buffer /= Void
		do
			Result := line_buffer_index >= line_buffer.count
		end

	assert_have_line_buffer is
			-- Make sure `line_buffer' is created.
		do
			if line_buffer = Void then
				create line_buffer.allocate (1024)
			end
		ensure
			line_buffer_not_void: line_buffer /= Void
		end

	assert_string_buffer_has_capacity (a_size: INTEGER) is
			-- Make sure `string_buffer' is created.
		require
			size_positive: a_size > 0
		do
			if string_buffer = Void then
				create string_buffer.allocate (a_size)
			elseif string_buffer.capacity < a_size then
				string_buffer.resize (a_size)
			end
		ensure
			string_buffer_exists: string_buffer /= Void
			string_buffer_has_capacity: string_buffer.capacity >= a_size
		end


feature -- Unreading

	valid_unread_character (a_character: CHARACTER): BOOLEAN is
			-- Can `a_character' be put back in input stream?
		do
			-- Unreading not supported.
			Result := False
		end


feature {NONE} -- Unreading

	unread_character (an_item: CHARACTER) is
		do
			-- ignore, not supported.
			-- We can support it, and should, else the implementation of
			-- `read_new_line' is incorrect. Just stuff things in `line_buffer'.
		end


feature -- Status report

	end_of_input: BOOLEAN
			-- Has end-of-file been reached?

	isatty: BOOLEAN is
		obsolete "Use is_attached_to_terminal instead."
		do
			Result := is_attached_to_terminal
		end

	is_attached_to_terminal: BOOLEAN is
			-- Is the handle associated with character device?
		require
			open: is_open
		do
			Result := abstract_isatty (fd)
		end

	is_open: BOOLEAN is
			-- Does `handle' contain an open handle?
		do
			-- Also return False of name = Void. When object is
			-- just created, handle = 0, so is_open would return True.
			Result :=
				fd /= unassigned_value and then
				name /= Void
		end

	resource_usage_can_be_increased: BOOLEAN is
			-- Is it allowed to open another file?
		do
			Result := security.files.open_files <= security.files.max_open_files
		end


feature -- Access

	hash_code: INTEGER is
			-- Hash code value
		do
			if fd >= 0 then
				Result := fd
			else
				-- Not a very good hash value I'm afraid.
				Result := 2147483647
			end
		end

	value: INTEGER is
			-- The actual file descriptor value
		require
			valid_file_descriptor: is_open
		do
			Result := fd
		end


feature -- non-blocking i/o

	is_blocking_io: BOOLEAN is
			-- Is blocking i/o enabled?
			-- Blocking i/o is the default.
			-- If false, calls like `read' and `write' will never wait
			-- for input, if there is no input.
		require
			open: is_open_read
		do
			Result := True
		end

	set_blocking_io (enable: BOOLEAN) is
			-- Set `is_blocking_io'.
		require
			supports_nonblocking_io: not enable implies supports_nonblocking_io
			open: is_open
		do
			-- do nothing
		ensure
			blocking_set: enable = is_blocking_io
		end

	supports_nonblocking_io: BOOLEAN is
			-- Does this descriptor support non-blocking input/output?
			-- On POSIX systems, any descriptor does.
			-- On Windows, sockets and pipes do.
		do
			Result := False
		end


feature -- Gobo stream specifics

	flush is
		do
			-- no meaning
		end


feature {NONE} -- Implementation

	reset_eof is
			-- Reset notion that end of file has been reached.
		do
			end_of_input := False
		ensure
			not_end_of_line: not end_of_input
		end

	temp_character: CHARACTER
			-- Needed by SmartEiffel to be able to pass a pointer to it.


feature {NONE} -- Low level handle functions

	do_close: BOOLEAN is
			-- Close resource. Return False if an error occurred. Error
			-- value should be in `errno'. This routine may never call
			-- another object, else it cannot be used safely in
			-- `dispose'.
			-- This routine is usely redefined to actually close or
			-- deallocate the resource in addition of resetting `handle'.
		local
			r: INTEGER
		do
			r := abstract_close (fd)
			Result := r /= -1
			clear_handle
			is_open_read := False
			is_open_write := False
		end

	unassigned_value: INTEGER is
			-- The value that indicates that `handle' is unassigned.
		do
			Result := -1
		end


feature {NONE} -- Counting of allocated resource

	decrease_open_files is
			-- Decreate the number of open files, does not access any
			-- other object, so can be called from `dispose' if one
			-- inherits from this class.
		external "C"
		alias "posix_decrease_open_files"
		end

	decrease_resource_count is
			-- Decrease number of allocated resource by `capacity'.
			-- Due to limitations of certain Eiffel implementations, this
			-- routine may not call any other object. Calling C code is safe.
		do
			decrease_open_files
		end

	increase_resource_count is
			-- Increase number of allocated resources by `capacity'.
		do
			security.files.increase_open_files
		end

	resource_count: INTEGER is
			-- Currently allocated number of resources. It's a global
			-- number, counting the `capacity' of all owned resources of
			-- this type.
		do
			Result := security.files.open_files
		end


feature {NONE} -- Abstract API binding

	abstract_close (fildes: INTEGER): INTEGER is
			-- Closes a a file. Returns -1 on error.
		deferred
		end

	abstract_dup (fildes: INTEGER): INTEGER is
			-- Duplicates an open file descriptor.
		deferred
		ensure
			-- Result = -1 implies errno.value is set
		end

	abstract_dup2 (fildes, fildes2: INTEGER): INTEGER is
			-- Duplicates an open file descriptor.
			-- fildes is the file descriptor to duplicate, fildes2 is the
			-- desired new file descriptor.
		deferred
		end

	abstract_isatty (fildes: INTEGER): BOOLEAN is
			-- Determines if a file descriptor is associated with a terminal.
		deferred
		end

	abstract_read (fildes: INTEGER; buf: POINTER; nbyte: INTEGER): INTEGER is
			-- Read from a file.
		require
			valid_fildes: fildes /= unassigned_value
			valid_buf: buf /= default_pointer
			valid_bytes: nbyte >= 0
		deferred
		ensure
			-- Result = -1 implies errno.value is set
		end

	abstract_write (fildes: INTEGER; buf: POINTER; nbyte: INTEGER): INTEGER is
			-- Write to a file.
		require
			valid_fildes: fildes /= unassigned_value
			valid_buf: buf /= default_pointer
			valid_bytes: nbyte >= 0
		deferred
		ensure
			-- Result = -1 implies errno.value is set
		end


feature {NONE} -- Error codes

	abstract_EWOULDBLOCK: INTEGER is
			-- The process would be delayed in the I/O operation.
		deferred
		end

	abstract_EINTR: INTEGER is
			-- Read/write was interrupted.
		deferred
		end


invariant

	line_buffer_index_offset_ok: line_buffer /= Void implies line_buffer_index <= line_buffer.count

end
