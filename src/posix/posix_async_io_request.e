note

	description: "Class that covers a single Posix asynchronous i/o request."

	Known_bugs:
		"1. After a cancel request I get a SIGSEGV when trying to write more.%
	%2. A synchronize request behaves as a cancel request on Linux.%
	%3. Garbage collection can take place while buffer is still in use."

	author: "Berend de Boer"


class

	POSIX_ASYNC_IO_REQUEST


inherit

	POSIX_BASE

	PAPI_AIO

	PAPI_SIGNAL


create

	make


feature -- creation

	make (a_fd: POSIX_FILE_DESCRIPTOR)
		require
			valid_fd: a_fd /= Void and then a_fd.is_open
		do
			fd := a_fd
			create aiocb.allocate_and_clear (posix_aiocb_size)
			posix_set_aiocb_aio_fildes (aiocb.ptr, a_fd.value)
			-- no signalling
			posix_set_sigevent_sigev_notify (posix_aiocb_aio_sigevent (aiocb.ptr), SIGEV_NONE)
		end


feature -- request properties

	raw_pointer: POINTER
			-- Location for read or written data, usually `buffer' is a
			-- better idea.
		do
			Result := posix_aiocb_aio_buf (aiocb.ptr)
		end

	count: INTEGER
			-- number of bytes to read/write
		do
			Result := posix_aiocb_aio_nbytes (aiocb.ptr)
		end

	offset: INTEGER
			-- file offset
		do
			Result := posix_aiocb_aio_offset (aiocb.ptr)
		end


feature -- set request properties

	set_buffer (a_buffer: STDC_BUFFER)
			-- set memory location to read/write from.
		require
			nothing_pending: not is_pending
			valid_buffer: a_buffer /= Void
		do
			buffer := a_buffer
			posix_set_aiocb_aio_buf (aiocb.ptr, buffer.ptr)
		ensure
			buffer_set: buffer = a_buffer
			raw_pointer_set: raw_pointer = a_buffer.ptr
		end

	set_count (a_count: INTEGER)
			-- set number of bytes to read/write
		require
			nothing_pending: not is_pending
		do
			posix_set_aiocb_aio_nbytes (aiocb.ptr, a_count)
		end

	set_offset (a_offset: INTEGER)
		require
			nothing_pending: not is_pending
		do
			posix_set_aiocb_aio_offset (aiocb.ptr, a_offset)
		end

	set_raw_pointer (a_pointer: POINTER)
			-- set memory location to read/write from. Make sure you have
			-- called `set_count' first!
		require
			nothing_pending: not is_pending
			need_count: count > 0
			valid_pointer: a_pointer /= default_pointer
		do
			posix_set_aiocb_aio_buf (aiocb.ptr, a_pointer)
			create buffer.make_from_pointer (a_pointer, count, False)
		ensure
			buffer_set: buffer.ptr = a_pointer
			raw_pointer_set: raw_pointer = a_pointer
		end


feature -- basic read/write requests

	read
			-- execute async read request
		require
			is_open: fd.is_open
			nothing_pending: not is_pending
			has_buffer: raw_pointer /= default_pointer and buffer /= Void
			has_capacity: buffer.capacity >= count
		do
			status_retrieved := False
			safe_call (posix_aio_read (aiocb.ptr))
		end

	write
			-- execute async write request
		require
			is_open: fd.is_open
			nothing_pending: not is_pending
			has_buffer: raw_pointer /= default_pointer and buffer /= Void
			has_capacity: buffer.capacity >= count
		do
			status_retrieved := False
			safe_call (posix_aio_write (aiocb.ptr))
		end


feature -- Eiffel friendly reads and writes

	last_string: STRING
			-- attempt to return buffer as an Eiffel string
			-- buffer should have a terminating byte!
		require
			nothing_pending: not is_pending
		do
			Result := sh.pointer_to_string (buffer.ptr)
		end

	read_string
		require
			is_open: fd.is_open
			nothing_pending: not is_pending
		do
			last_string.wipe_out
			-- read from own buffer, just to be sure
			-- also make sure there is a zero byte at the end
			create buffer.allocate (count + 1)
			buffer.poke_uint8 (count, 0)
			set_buffer (buffer)
			read
		end

	put_string, write_string (text: STRING)
		require
			is_open: fd.is_open
			nothing_pending: not is_pending
		local
			uc: UC_STRING
		do
			if text /= Void and then not text.is_empty then
				set_count (text.count)
				-- Copy string to own buffer, just to be sure.
				uc ?= text
				if uc /= Void then
					create buffer.allocate (uc.byte_count)
					buffer.memory_copy (sh.uc_string_to_pointer (uc), 0, 0, uc.byte_count)
				else
					create buffer.allocate (text.count)
					buffer.memory_copy (sh.string_to_pointer (text), 0, 0, text.count)
				end
				sh.unfreeze_all
				set_buffer (buffer)
				write
			end
		end


feature -- other operations

	cancel_failed: BOOLEAN
			-- set by cancel, True if cancel request failed, probably
			-- because operation was already performed

	cancel
			-- cancel request
		local
			r: INTEGER
		do
			r := posix_aio_cancel (fd.value, aiocb.ptr)
			if r = -1 then
				raise_posix_error
			end
			cancel_failed := r = AIO_NOTCANCELED
		end

	synchronize
			-- force all i/o operations queued for the file descriptor
			-- associated with this request to the synchronous state.
			-- Function returns when the request has been initiated or
			-- queued to the file or device (even when the data cannot be
			-- synchronized immediately)
		do
			safe_call (posix_aio_fsync (O_SYNC, aiocb.ptr))
		end

	synchronize_data
			-- force all i/o operations queued for the file descriptor
			-- associated with this request to the synchronous state.
			-- Function returns when the request has been initiated or
			-- queued to the file or device (even when the data cannot be
			-- synchronized immediately)
		do
			safe_call (posix_aio_fsync (O_DSYNC, aiocb.ptr))
		end

	wait_for
			-- suspend process, until request completed
		local
			list: ARRAY [POINTER]
		do
			create list.make (0, 1)
			list.put (aiocb.ptr, 0)
			safe_call (posix_aio_suspend (ah.pointer_array_to_pointer (list), 1, default_pointer))
			ah.unfreeze_all
		end


feature -- Access

	buffer: STDC_BUFFER
			-- Buffer where data that is being read/write comes from,
			-- unless set_pointer has been called

	fd: POSIX_FILE_DESCRIPTOR

	is_pending: BOOLEAN
			-- Is io request still pending?
		do
			Result := posix_aio_error (aiocb.ptr) = EINPROGRESS
		end

	return_status: INTEGER
			-- Return status of asynchronous i/o operation, equal to what
			-- the synchronous read, write of fsync would have returned
		require
			nothing_pending: not is_pending
		do
			if not status_retrieved then
				saved_status  := posix_aio_return (aiocb.ptr)
				status_retrieved := True
			end
			Result := saved_status
		end


feature {NONE} -- private state

	aiocb: POSIX_BUFFER
			-- aio control block

	status_retrieved: BOOLEAN

	saved_status: INTEGER


invariant

	valid_aiocb: aiocb /= Void
	synced_buffer_and_raw_pointer: buffer /= Void implies buffer.ptr = raw_pointer


end
