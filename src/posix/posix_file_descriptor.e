note

	description: "Class that covers Posix file descriptor routines."

	author: "Berend de Boer"


class

	POSIX_FILE_DESCRIPTOR

inherit

	EPX_FILE_DESCRIPTOR
		export
			{ANY} file_status_flags
		redefine
			do_close,
			my_status,
			status
		end

	PAPI_STDIO
		export
			{NONE} all
		end


create

	open,
	open_read,
	open_write,
	open_read_write,
	open_truncate,
	create_read_write,
	create_write,
	create_with_mode,
	make_as_duplicate,
	make_from_file,
	attach_to_fd


feature -- Initialization

	make_from_file (file: STDC_FILE)
			-- Create file descriptor from given stream
			-- The stream is leading, so this file descriptor will
			-- never close itself, unless it is made an owner.
		require
			closed: not is_open
			valid_file: file /= Void and then file.is_open
		local
			a_fd: INTEGER
		do
			do_make
			a_fd := posix_fileno (file.stream)
			if a_fd = -1 then
				raise_posix_error
			else
				capacity := 1
				set_handle (a_fd, False)
				is_open_read := True
				is_open_write:= True
			end
		ensure
			opened:
				raise_exception_on_error implies
					is_open
			can_read:
				raise_exception_on_error implies
					is_open_read
			can_write:
				raise_exception_on_error implies
					is_open_write
			not_owner: not is_owner
			open_files_unchanged:
				security.files.open_files = old security.files.open_files
		end


feature -- Status

	is_closed_on_execute: BOOLEAN
			-- Is this descriptor closed when the process executes or
			-- spawns a child process?
		require
			open: is_open
		do
			Result := test_bits (file_descriptor_flags, FD_CLOEXEC)
		end


feature -- Close

	close_on_execute
			-- Close this descriptor in the child process after a spawn
			-- or execute has happened. Important if you don't
			-- inadvertedly want to leak important sockets to a client.
		require
			open: is_open
		local
			new_flags: INTEGER
		do
			new_flags := flip_bits (file_descriptor_flags, FD_CLOEXEC, True)
			safe_call (posix_fcntl_arg (value, F_SETFD, new_flags))
		ensure
			closed_on_execute: is_closed_on_execute
		end


feature -- Synchronisation

	supports_file_synchronization: BOOLEAN
			-- Do we support synchronization?
		local
			psystem: POSIX_SYSTEM
		once
			create psystem
			Result := psystem.supports_file_synchronization
		end

	supports_data_synchronization: BOOLEAN
			-- Do we support synchronization of data without metadata?
		local
			psystem: POSIX_SYSTEM
		once
			create psystem
			Result := psystem.supports_synchronized_io
		end

	synchronize
			-- Synchronize the state of a file (includes synchronize_data).
		require
			synchronize_valid: supports_file_synchronization
		do
			safe_call (posix_fsync (value))
		end

	fsync
		obsolete "Use synchronize instead."
		do
			synchronize
		end

	synchronize_data
			-- Synchronize the data of a file. Cheaper than
			-- `synchronize', but not always supported.
		require
			synchronize_valid: supports_data_synchronization
		do
			safe_call (posix_fdatasync (value))
		end

	fdatasync
		obsolete "Use synchronize_data instead."
		do
			synchronize_data
		end


feature -- Locking

	get_lock (lock_to_test: POSIX_LOCK): detachable POSIX_LOCK
			-- Lock information about given lock
		do
			create Result.make
			Result.buf.copy_from (lock_to_test.buf, 0, 0, lock_to_test.buf.capacity)
			safe_call (posix_fcntl_lock (value, F_GETLK, Result.buf.ptr))
			if Result.allow_all then
				Result := Void
			end
		end

	set_lock_failed: BOOLEAN
			-- Did set_lock obtain a lock?

	attempt_lock (a_lock: POSIX_LOCK)
			-- Attempt to set lock, if not possible, set
			-- `set_lock_failed'.
		local
			r: INTEGER
		do
			r := posix_fcntl_lock (value, F_SETLK, a_lock.buf.ptr)
			set_lock_failed := r = EAGAIN
			if r = -1 then
				if not set_lock_failed then
					raise_posix_error
				end
			end
		end

	set_lock (a_lock: POSIX_LOCK)
			-- Attempt to set lock, wait if necessary.
		do
			safe_call (posix_fcntl_lock (value, F_SETLKW, a_lock.buf.ptr))
		end


feature -- Access

	file_descriptor_flags: INTEGER
			-- All file descriptor bits associated with this handle.
		do
			Result := posix_fcntl (value, F_GETFD)
		end

	status: POSIX_STATUS
			-- The status for this file descriptor. Cached value,
			-- refreshed only when file reopened.
		do
			if attached my_status as ms then
				Result := ms
			else
				Result := new_status
				my_status := Result
			end
		end

	terminal: POSIX_TERMIOS
			-- Terminal settings.
		require
			valid_file_descriptor: is_attached_to_terminal
		do
			if attached my_termios as t then
				Result := t
			else
				create Result.make (Current)
				my_termios := Result
			end
		ensure
			valid_result: Result /= Void
		end

	ttyname: STRING
			-- Terminal path name, or empty if this file descriptor does
			-- not refer to a terminal
		do
			Result := sh.pointer_to_string (posix_ttyname (value))
		end


feature {NONE} -- Low level handle functions

	do_close: BOOLEAN
			-- Close resource. Return False if an error occurred. Error
			-- value should be in `errno'. This routine may never call
			-- another object, else it cannot be used safely in
			-- `dispose'.
			-- This routine is usely redefined to actually close or
			-- deallocate the resource in addition of resetting `handle'.
		do
			Result := precursor
			my_termios := Void
		end


feature {NONE} -- Implementation

	my_status: detachable POSIX_STATUS
			-- cached status object

	my_termios: detachable POSIX_TERMIOS
			-- lazy build access to terminal setttings


end
