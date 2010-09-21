indexing

	description:

		"Class that covers the Standard C streams. Usually they're high performance, buffered and possibly memory mapped."

	idea: "Mimicks an existing file. Tries to maintain that file exists%
	%during life of object by keeping it open from creation to%
	%destruction of the object. But you may close it earlier."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #19 $"


deferred class

	STDC_FILE


inherit

	STDC_HANDLE_BASED_IO_STREAM [POINTER]
		rename
			handle as stream
		redefine
			do_close,
			put_boolean,
			put_integer,
			rewind
		end

	KL_IMPORTED_INTEGER_ROUTINES
		export
			{NONE} all
		end

	EPX_POINTER_HELPER
		export
			{NONE} all
		end

	CAPI_STDIO
		export
			{NONE} all
		end


feature {NONE} -- Initialisation

	make (a_path: STRING) is
		require
			path_not_empty: a_path /= Void and then not a_path.is_empty
		do
			do_make
			set_portable_path (a_path)
		end


feature -- Initialization

	create_read_write (path: STRING) is
			-- Open file for update (reading and writing). If the file
			-- already exists, it is truncated to zero length.
			-- So permissions seem to remain.
		require
			closed: not is_open
		do
			do_make
			do_open (path, "w+")
			if is_open then
				is_open_read := True
				is_open_write := True
			end
		ensure
			file_is_open: raise_exception_on_error implies is_open
			owner_set: is_open implies is_owner
			readable: is_open implies is_open_read
			writable: is_open implies is_open_write
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end

	create_write (path: STRING) is
			-- Create new file for writing. If the file already exists,
			-- it is truncated to zero length.
			-- So permissions seem to remain.
		require
			closed: not is_open
			path_not_empty: path /= Void and then not path.is_empty
		do
			do_make
			do_open (path, "w")
			if is_open then
				is_open_write := True
			end
		ensure
			file_is_open: raise_exception_on_error implies is_open
			owner_set: is_open implies is_owner
			not_readable: is_open implies not is_open_read
			writable: is_open implies is_open_write
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end

	open (path, a_mode: STRING) is
			-- Open file in given `a_mode'.
		require
			closed: not is_open
			path_not_empty: path /= Void and then not path.is_empty
			mode_not_empty: a_mode /= Void and then not a_mode.is_empty
		do
			do_make
			do_open (path, a_mode)
			if is_open then
				is_open_read := True
				is_open_write := True
			end
		ensure
			file_is_open: raise_exception_on_error implies is_open
			owner_set: is_open implies is_owner
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end

	open_append (path: STRING) is
			-- Append to exiting file or create file if it does not exist.
		require
			closed: not is_open
			path_not_empty: path /= Void and then not path.is_empty
		do
			do_make
			do_open (path, "a")
			if is_open then
				is_open_write := True
			end
		ensure
			file_is_open: raise_exception_on_error implies is_open
			owner_set: is_open implies is_owner
			not_readable: is_open implies not is_open_read
			writable: is_open implies is_open_write
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end

	open_read (path: STRING) is
			-- Open file for reading.
		require
			closed: not is_open
			path_not_empty: path /= Void and then not path.is_empty
		do
			do_make
			do_open (path, "r")
			if is_open then
				is_open_read := True
			end
		ensure
			file_is_open: raise_exception_on_error implies is_open
			owner_set: is_open implies is_owner
			readable: is_open implies is_open_read
			not_writable: is_open implies not is_open_write
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end

	open_read_write (path: STRING) is
			-- Open file for reading and writing.
		require
			closed: not is_open
			path_not_empty: path /= Void and then not path.is_empty
		do
			do_make
			open (path, "r+")
		ensure
			file_is_open: raise_exception_on_error implies is_open
			owner_set: is_open implies is_owner
			readable: is_open implies is_open_read
			writable: is_open implies is_open_write
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end

	open_write (path: STRING) is
			-- Open file for writing.
		require
			closed: not is_open
			path_not_empty: path /= Void and then not path.is_empty
		do
			do_make
			do_open (path, "w")
			if is_open then
				is_open_write := True
			end
		ensure
			file_is_open: raise_exception_on_error implies is_open
			owner_set: is_open implies is_owner
			not_readable: is_open implies not is_open_read
			writable: is_open implies is_open_write
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end


feature -- Work with existing streams

	attach_to_stream (a_stream: POINTER; a_mode: STRING) is
			-- Attach to `a_stream'. Does not become owner of stream so
			-- it will not close on `close' or when garbage collected.
		require
			closed: not is_open
			valid_stream: a_stream /= default_pointer
			mode_not_empty: a_mode /= Void and then not a_mode.is_empty
			-- `a_stream' is open
			-- `a_mode' is compatible with `a_stream'
		do
			do_make
			set_mode (a_mode)
			capacity := 1
			attach_to_handle (a_stream, False)
			if is_open then
				is_open_read := True
				is_open_write:= True
			end
		ensure
			opened: is_open
			can_read: is_open_read
			can_write: is_open_write
			not_owner: not is_owner
			open_files_unchanged:
				security.files.is_open_files_increased (False, old security.files.open_files)
		end


feature -- Reopen

	reopen (a_path, a_mode: STRING) is
			-- Closes and then opens a stream.
		require
			open: is_open
			mode_not_empty: a_mode /= Void and then not a_mode.is_empty
		local
			cpath: POINTER
			cmode: POINTER
		do
			set_portable_path (a_path)
			cpath := sh.string_to_pointer (name)
			set_mode (a_mode)
			cmode := sh.string_to_pointer (mode)
			stream := posix_freopen (cpath, cmode, stream)
			sh.unfreeze_all
			if not is_open then
				raise_posix_error
			end
		ensure
			file_stays_open: is_open
			open_files_unchanged:
				security.files.is_open_files_increased (False, old security.files.open_files)
		end


feature -- Control over buffering

	flush is
			-- Updates this stream
		local
			i: INTEGER
		do
			i := posix_fflush (stream)
			if i /= 0 then
				raise_posix_error
			end
		end

	setbuf, set_buffer (buffer: POINTER) is
			-- Determines how the stream will be buffered
			-- gives you a fully buffered input and output.
			-- Not sure: buffer should have at least BUFSIZ bytes?
			-- No operation should yet been performed on this file
			-- `buffer' = default_pointer: default buffer will be allocated
			-- `buffer' /= default_pointer implies buffer size = BUFSIZ
		require
			open: is_open
		do
			posix_setbuf (stream, buffer)
		end

	set_full_buffering (buffer: POINTER; size: INTEGER) is
			-- Determines buffering for a stream.
			-- If `buffer' is `default_pointer', a buffer of `size' bytes
			-- will be allocated by this routine.
		require
			open: is_open
		local
			r: INTEGER
		do
			r := posix_setvbuf (stream, buffer, IOFBF, size)
			if r /= 0 then
				raise_posix_error
			end
		end

	set_line_buffering (buffer: POINTER; size: INTEGER) is
			-- Determines buffering for a stream.
			-- If `buffer' is `default_pointer, a buffer of `size' bytes
			-- will be allocated by this routine.
		require
			open: is_open
		local
			r: INTEGER
		do
			r := posix_setvbuf (stream, buffer, IOLBF, size)
			if r /= 0 then
				raise_posix_error
			end
		end

	set_no_buffering is
			-- Turn buffering off.
		require
			open: is_open
		local
			r: INTEGER
		do
			r := posix_setvbuf (stream, default_pointer, IONBF, 0)
			if r /= 0 then
				raise_posix_error
			end
		end


feature -- read, C like

	last_byte: INTEGER
			-- Last read character of `get_character'.
			-- Can be negative, so is more a last_shortint or so!

	getc, get_character is
			-- Reads a C unsigned char and converts it to an integer,
			-- the result is left in `last_byte'.
			-- This function probably can be used to read a single
			-- byte.
		require
			open: is_open_read
		do
			assert_input_ok
			last_byte := posix_fgetc (stream)
			eof_read := last_byte = const_EOF
		ensure
			eof_set: last_byte = const_EOF implies end_of_input
		end

	read (buf: POINTER; offset, bytes: INTEGER) is
			-- Read chunk, set `last_read'. `offset' determines how far
			-- in `buf' you want to start writing.
		require
			open: is_open_read
			valid_buf: buf /= default_pointer
			valid_bytes: bytes >= 0
		local
			ptr: POINTER
		do
			assert_input_ok
			ptr := buf + offset
			last_read := posix_fread (ptr, 1, bytes, stream)
			if end_of_input then
				if last_read > 0 then
					-- We don't want the eof to be True when bytes are read.
					-- User has to call read again to make eof True, fits
					-- better with Eiffel loops.
					clear_error
				end
-- 			else
				-- Not eof, but not all requested bytes read?? Stop!
				-- Well, that's what you would expect. But doesn't work on QNX.
				-- So we have to assume this is not an error condition,
				-- and somehow ok.
-- 				if  last_read /= bytes then
-- 					raise_posix_error
-- 				end
			end
		ensure
			successfull_read:
				raise_exception_on_error implies
					(not end_of_input implies
						((bytes = last_read) or else (last_read > 0)))
			read_consistent: last_read <= bytes
			end_of_input_implies_nothing_read: end_of_input implies last_read = 0
		end


feature {NONE} -- `gets' private state

	eof_read: BOOLEAN
			-- Is end-of-file encountered?
			-- Set by `getc', `gets' and sometimes `read', signals EOF
			-- read, even when `feof' says nothing.

	gets_buf: STDC_BUFFER
			-- Buffer used by `gets'

	assert_buf_has_room (needed_size: INTEGER) is
			-- Make sure `gets_buf' has enough room.
		require
			needed_size_positive: needed_size > 0
		do
			if gets_buf.capacity < needed_size then
				gets_buf.resize (needed_size)
			end
		ensure
			has_capacity: gets_buf.capacity >= needed_size
		end


feature -- Write, C like

	putc (c: INTEGER) is
			-- Write a single character.
		require
			open: is_open_write
			valid_character: c >= -128 and then c <= 256
		local
			r: INTEGER
		do
			r := posix_fputc (c, stream)
			if r = const_EOF then
				raise_posix_error
			end
			need_flush := True
		ensure
			need_flush_set: need_flush
		end

	write (buf: POINTER; offset, bytes: INTEGER) is
			-- write `bytes' bytes from `buf' at offset `offset'
			-- we do not really care if offset is positive or negative...
		require
			open: is_open_write
			valid_buf: buf /= default_pointer
			valid_bytes: bytes >= 0
		local
			ptr: POINTER
		do
			--ptr := posix_pointer_add (buf, offset)
			ptr := buf + offset
			last_written := posix_fwrite (ptr, 1, bytes, stream)
			if last_written /= bytes then
				raise_posix_error
			end
			need_flush := True
		ensure
			successfull_write: last_written = bytes
			need_flush_set: need_flush
		end


feature -- Access

	last_boolean: BOOLEAN
			-- last boolean read by `read_boolean'

	last_double: DOUBLE
			-- last double lread by `read_double'

	last_integer: INTEGER

	last_real: REAL
			-- last real read by `read_real'

	max_line_length: INTEGER is
			-- Maximum line length used in `read_line'
		do
			Result := 8192
		ensure
			max_line_length_positive: Result >= 1
		end

	mode: STRING
			-- Mode in which the file is opened/created.

	frozen filename: STRING is
		obsolete "2006-11-29: please use `name' instead"
		do
			Result := name
		end


feature -- Input

	read_boolean is
			-- Attempt to read back a boolean written by `write_boolean'.
		require
			open: is_open_read
		do
			read_character
			inspect last_character
			when 't', 'T' then
				read_string (3)
				if last_string.is_equal ("rue") then
					last_boolean := true
				else
					-- other ideas?
					raise_posix_error
				end
			when 'f', 'F' then
				read_string (4)
				if last_string.is_equal ("alse") then
					last_boolean := false
				else
					-- set errno here??
					raise_posix_error
				end
			else
				-- set errno here??
				raise_posix_error
			end
		end

	read_buffer (buf: STDC_BUFFER; offset, bytes: INTEGER) is
			-- More safe version of `read' in case you have a
			-- STDC_BUFFER object. Read starts at `offset' bytes in `buf'.
			-- Check `last_read' for number of bytes actually read.
		do
			read (buf.ptr, offset, bytes)
		end

	read_double is
		require
			open: is_open_read
		do
			assert_input_ok
			check_fscanf (posix_fscanf_double (stream, $last_double))
		end

	read_character is
			-- Read a single character and set `last_character'.
			-- If end-of-file encountered, `eof' is True.
		do
			get_character
			if not end_of_input then
				last_character := INTEGER_.to_character (last_byte)
				last_read := 1
			else
				last_character := '%U'
				last_read := 0
			end
		end

	read_integer is
		require
			open: is_open_read
		do
			assert_input_ok
			check_fscanf (posix_fscanf_integer (stream, $last_integer))
		end

	read_line is
			-- Read characters from input stream until a line separator
			-- or end of file is reached. Make the characters that have
			-- been read available in `last_string' and discard the line
			-- separator characters from the input stream.
			-- Reads a maximum of `max_line_length' characters per line.
			-- The line should not have a '%U' character in it, because
			-- that is treated as end-of-file.
		local
			p: POINTER
		do
			assert_input_ok
			assert_buf_has_room (max_line_length)
			p := posix_fgets (gets_buf.ptr, gets_buf.capacity, stream)
			if p = default_pointer then
				eof_read := posix_feof (stream)
				if eof_read then
					STRING_.wipe_out (last_string)
				else
					raise_posix_error
				end
			else
				sh.set_string_from_pointer (last_string, gets_buf.ptr)
				if end_of_input then
					-- We don't want the `end_of_input' to be True here,
					-- user has to call gets again to make `end_of_input'
					-- True, fits better with Eiffel loops.
					clear_error
				end
			end
			-- `last_read' includes the end-of-line characters
			last_read := last_string.count

			-- Remove end-of-line characters
			if last_string.count > 0 and then
				last_string.item (last_string.count) = '%N' then
				last_string.remove (last_string.count)
				if last_string.count > 0 and then
					last_string.item (last_string.count) = '%R' then
					last_string.remove (last_string.count)
				end
			end
		end

	read_new_line is
			-- Read a line separator from input file.
			-- Make the characters making up the recognized
			-- line separator available in `last_string',
			-- or make `last_string' empty and leave the
			-- input file unchanged if no line separator
			-- was found.
		do
			if last_string = Void then
				create last_string.make (256)
			else
				STRING_.wipe_out (last_string)
			end
			read_character
			if not end_of_input then
				if last_character = '%N' then
					last_string.append_character ('%N')
				else
					-- Put character back to input file.
					unread_character (last_character)
				end
			end
			-- Is setting `eof_read' good enough?
			eof_read := False
		end

	read_real is
		require
			open: is_open_read
		do
			assert_input_ok
			check_fscanf (posix_fscanf_real (stream, $last_real))
		end

	read_string (nb: INTEGER) is
			-- Read at most `nb' characters from input stream.
			-- Make the characters that have actually been read
			-- available in `last_string'.
			-- The input stream should not contain '%U' characters.
		local
			i: INTEGER
		do
			assert_input_ok
			assert_buf_has_room (nb + 1)
			read (gets_buf.ptr, 0, nb)
			if last_read = 0 then
				STRING_.wipe_out (last_string)
			else
				-- Set end-of-string character.
				gets_buf.poke_character (last_read, '%U')
				-- Problem here is that an early occurrence of '%U' truncates
				-- the string.
				last_string := sh.pointer_to_string (gets_buf.ptr)
				-- If that occurs, we fix that here
				if last_string.count < last_read then
					from
						i := last_string.count
					until
						i = last_read
					loop
						last_string.append_character (gets_buf.peek_character (i))
						i := i + 1
					end
				end
			end
		ensure then
			string_length_correct: last_string.count = last_read
		end


feature -- write, Eiffel like

	put (any: ANY) is
			-- Write object as string.
		require
			open: is_open_write
		do
			if any /= Void then
				write_string (any.out)
			end
		ensure
			successfull_write: last_written = any.out.count
			need_flush_set: need_flush
		end

	put_buffer, write_buffer (buf: STDC_BUFFER; offset, bytes: INTEGER) is
			-- more safe version of `write' in case you have a
			-- STDC_BUFFER object
			-- Check `last_written' for number of bytes actually written,
			-- if you use asynchronous writing.
		do
			write (buf.ptr, offset, bytes)
		ensure then
			successfull_write: last_written = bytes
			need_flush_set: need_flush
		end

	put_boolean (b: BOOLEAN) is
			-- Write "True" to output stream if
			-- `b' is true, "False" otherwise.
		do
			precursor (b)
		ensure then
			successfull_write: last_written = b.out.count
			need_flush_set: need_flush
		end

	write_boolean (b: BOOLEAN) is
		require
			is_open_write: is_open_write
		do
			put_boolean (b)
		ensure
			successfull_write: last_written = b.out.count
			need_flush_set: need_flush
		end

	put_character (c: CHARACTER) is
			-- Write a single character.
		do
			putc (c.code)
			last_written := 1
		ensure then
			successfull_write: last_written = 1
			need_flush_set: need_flush
		end

	write_character (c: CHARACTER) is
			-- Write a single character.
		do
			put_character (c)
		ensure
			successfull_write: last_written = 1
			need_flush_set: need_flush
		end

	put_double (d: DOUBLE) is
			-- Write a double in Standard C %f format.
		require
			open: is_open_write
		do
			check_fprintf (posix_fprintf_double (stream, d))
		ensure
			need_flush_set: need_flush
		end

	write_double (d: DOUBLE) is
			-- Write a double in Standard C %f format.
		require
			open: is_open_write
		do
			put_double (d)
		ensure
			need_flush_set: need_flush
		end

	put_integer (i: INTEGER) is
			-- Write an integer in Standard C %d format.
		do
			check_fprintf (posix_fprintf_int (stream, i))
		ensure then
			need_flush_set: need_flush
		end

	write_integer (i: INTEGER) is
			-- Write an integer in Standard C %d format.
		require
			open: is_open_write
		do
			put_integer (i)
		ensure
			need_flush_set: need_flush
		end

	put_real (r: REAL) is
			-- Write a real in Standard C %f format.
		require
			open: is_open_write
		do
			check_fprintf (posix_fprintf_real (stream, r))
		ensure
			need_flush_set: need_flush
		end

	write_real (r: REAL) is
			-- Write a real in Standard C %f format.
		require
			open: is_open_write
		do
			put_real (r)
		ensure
			need_flush_set: need_flush
		end

	put_string (a_string: STRING) is
			-- Write `a_string' to stream.
			-- Because the way this feature is written (it supports
			-- writing the NULL byte), it is probably a very good idea to
			-- turn on buffering, see `set_full_buffering' or
			-- `set_line_buffering'.
		local
			r: INTEGER
		do
			r := ioh.stream_put_string (stream, a_string)
			if r = const_EOF then
				raise_posix_error
			end
			last_written := r
			need_flush := True
		ensure then
			successful_write: last_written >= a_string.count
			-- (in case of UC_STRING really should look at byte_count)
			need_flush_set: need_flush
		end

	write_string, puts (s: STRING) is
		require
			open_write: is_open_write
			s_not_void: s /= Void
			no_null_character: not s.has ('%U')
		do
			put_string (s)
		ensure
			successfull_write: last_written = s.count
			need_flush_set: need_flush
		end


feature -- Unreading

	ungetc (c: INTEGER) is
			-- Pushes `c' back to the stream. Only one push back is guaranteed.
			-- Note that file positioning functions discard any
			-- pushed-back characters.
		require
			open: is_open_read
			valid_character: c >= -128 and then c <= 256
		local
			r: INTEGER
		do
			-- and that's why we make sure position is not needed anymore
			assert_input_ok
			r := posix_ungetc (c, stream)
			if r = const_EOF then
				raise_posix_error
			end
		end

	unread_character (an_item: CHARACTER) is
			-- Put `an_item' back in input stream. Only one push back is
			-- guaranteed.
			-- This item will be read first by the next
			-- call to a read routine.
			-- Note that file positioning functions discard any
			-- pushed-back characters.
		do
			ungetc (an_item.code)
		end


feature -- File position

	frozen getpos: STDC_FILE_POSITION is
		obsolete "Use get_position instead."
		do
			Result := get_position
		end

	get_position: STDC_FILE_POSITION is
			-- Get the current position. Use `set_position' to return to
			-- this saved position
		require
			open: is_open
		do
			create Result.make
			if posix_fgetpos (stream, Result.buf.ptr) /= 0 then
				raise_posix_error
			end
		ensure
			got_position: raise_exception_on_error implies Result /= Void
		end

	rewind is
			-- Sets the file position to the beginning of the file.
		do
			posix_rewind (stream)
			eof_read := False
			need_flush := False
		ensure then
			no_need_to_flush: not need_flush
		end

	seek (offset: INTEGER) is
			-- Set file position to given absolute `offset'.
		require
			open: is_open
			valid_offset: offset >= 0
		do
			if posix_fseek (stream, offset, SEEK_SET) /= 0 then
				raise_posix_error
			end
			eof_read := False
			need_flush := False
		ensure
			not_end_of_input: not end_of_input
			no_need_to_flush: not need_flush
		end

	seek_from_current (offset: INTEGER) is
			-- Set file position relative to current position.
		require
			open: is_open
		do
			if posix_fseek (stream, offset, SEEK_CUR) /= 0 then
				raise_posix_error
			end
			eof_read := False
			need_flush := False
		ensure
			not_end_of_input: not end_of_input
			no_need_to_flush: not need_flush
		end

	seek_from_end (offset: INTEGER) is
			-- Set file position relative to end of file.
		require
			open: is_open
			valid_offset: offset <= 0
		do
			if posix_fseek (stream, offset, SEEK_END) /= 0 then
				raise_posix_error
			end
			eof_read := False
			need_flush := False
		ensure
			not_end_of_input: not end_of_input
			no_need_to_flush: not need_flush
		end

	frozen setpos (a_position: STDC_FILE_POSITION) is
		obsolete "Use set_position instead."
		do
			set_position (a_position)
		end

	set_position (a_position: STDC_FILE_POSITION) is
			-- Set the current file position.
		require
			open: is_open
			valid_position: a_position /= Void
		do
			if posix_fsetpos (stream, a_position.buf.ptr) /= 0 then
				raise_posix_error
			end
			eof_read := False
			need_flush := False
		ensure
			not_end_of_input: not end_of_input
			no_need_to_flush: not need_flush
		end

	tell: INTEGER is
			-- The current position
		require
			open: is_open
		do
			Result := posix_ftell (stream)
		end


feature -- Other

	clearerr, clear_error is
			-- Clears end-of-file and error indicators for a stream.
		require
			open: is_open
		do
			posix_clearerr (stream)
			eof_read := False
		ensure
			end_of_input_not_set: not end_of_input
		end


feature -- Status

	end_of_input: BOOLEAN is
			-- Is end-of-file encountered by getc or is the end-of-file indicator
			-- is set?
		do
			Result := eof_read or else posix_feof (stream)
		end

	error: BOOLEAN is
			-- Is the error indicator is set?
		require
			open: is_open
		do
			Result := posix_ferror (stream)
		end

	is_binary_mode_specification (a_mode: STRING): BOOLEAN is
			-- Is the last character of a_mode equal to 'b'?
		local
			last: CHARACTER
		do
			if a_mode.count > 0 then
				last := a_mode.item (a_mode.count)
				Result :=
					last = 'b' or else last = 'B'
			end
		end

	is_text_mode_specification (a_mode: STRING): BOOLEAN is
			-- Is the last character of a_mode equal to 't'?
		local
			last: CHARACTER
		do
			-- Note that if `a_mode' doesn't end with a `t' it is still a
			-- text mode as not all OSes seem to recognize this flag.
			-- Absence of this flag means it is text mode.
			if a_mode.count > 0 then
				last := a_mode.item (a_mode.count)
				Result :=
					last = 't' or else last = 'T'
			end
		end

	is_valid_mode (a_mode: STRING): BOOLEAN is
			-- Is `a_mode' a valid mode specification for `Current'?
		deferred
		ensure
			not_empty: Result implies a_mode /= Void and then not a_mode.is_empty
		end

	resource_usage_can_be_increased: BOOLEAN is
			-- Is it allowed to open another file?
		do
			Result := security.files.open_files <= security.files.max_open_files
		end


feature {NONE} -- Implementation

	check_fprintf (res: INTEGER) is
			-- Make sure the result of a fprintf is correctly handled.
		do
			if res < 0 then
				raise_posix_error
			end
			need_flush := True
			last_written := res
		end

	check_fscanf (res: INTEGER) is
			-- Make sure the result of a fscanf is correctly handled.
		do
			if res < 0 then
				raise_posix_error
			end
		end

	do_make is
			-- Make sure invariants are satisfied.
		do
			make_path
			if last_string = Void then
				create last_string.make (256)
			end
			if gets_buf = Void then
				create gets_buf.allocate_and_clear (256)
			end
		end

	do_open (a_path, a_mode: STRING) is
			-- Internal open of stream, main entry point for all routines
			-- that actually open the stream.
		require
			valid_mode: a_mode /= Void and then not a_mode.is_empty
		local
			cpath: POINTER
			cmode: POINTER
			a_stream: like stream
		do
			set_portable_path (a_path)
			cpath := sh.string_to_pointer (name)
			set_mode (a_mode)
			cmode := sh.string_to_pointer (mode)
			a_stream := posix_fopen (cpath, cmode)
			sh.unfreeze_all
			if a_stream = default_pointer then
				raise_posix_error
			else
				capacity := 1
				set_handle (a_stream, True)
			end
		ensure
			file_is_open: raise_exception_on_error implies is_open
			owner_set: is_open implies is_owner
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end

	need_flush: BOOLEAN
			-- Need to be set after any write operation and
			-- reset after any flush operation.

	assert_input_ok is
			-- ANSI C requires that after a write, a file positioning function
			-- or flush is performed.
		require
			open: need_flush implies is_open
		do
			if need_flush then
				seek_from_current (0)
			end
		ensure
			no_need_to_flush: not need_flush
		end

	set_mode (a_mode: STRING) is
			-- Use this routine to set the mode variable. It takes care
			-- of adding the binary or text flag in its descendents.
		require
			mode_not_empty: a_mode /= Void and then not a_mode.is_empty
		deferred
		ensure
			valid_mode: is_valid_mode (mode)
		end


feature {NONE} -- Low level handle functions

	do_close: BOOLEAN is
			-- Close resource. Return False if an error occurred. Error
			-- value should be in `errno'. This routine may never call
			-- another object, else it cannot be used safely in
			-- `dispose'.
		local
			r: INTEGER
		do
			r := posix_fclose (stream)
			Result := r = 0
			clear_handle
			is_open_read := False
			is_open_write := False
		end

	frozen unassigned_value: POINTER is
			-- The value that indicates that `handle' is unassigned.
		do
			Result := default_pointer
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


invariant

	last_string_valid: last_string /= Void
	gets_buf_valid: gets_buf /= Void

end
