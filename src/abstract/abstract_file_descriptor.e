indexing

	description: "Base class that covers certain file descriptor routines."

	idea: "Functions here are also available under Windows more or less.%
	%This also means that an abstract file descriptor cannot be converted to a%
	%stream, because Windows doesn't support that."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #17 $"


deferred class

	ABSTRACT_FILE_DESCRIPTOR


inherit

	ABSTRACT_DESCRIPTOR
		rename
			attach_to_descriptor as attach_to_fd
		redefine
			do_close,
			rewind
		end


feature -- Initialization

	open (a_path: STRING; a_flags: INTEGER) is
			-- Open given file with access given by `flags'.
		require
			closed: not is_open
			a_path_not_empty: a_path /= Void and then not a_path.is_empty
		do
			do_make
			do_open (a_path, a_flags)
			if is_open then
				is_open_read := True
				is_open_write:= True
			end
		ensure
			is_opened: raise_exception_on_error implies is_open
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end

	open_read (a_path: STRING) is
			-- Open given file with access given by `flags'.
		require
			closed: not is_open
			a_path_not_empty: a_path /= Void and then not a_path.is_empty
		do
			open (a_path, abstract_O_RDONLY)
			if is_open then
				is_open_write := False
			end
		ensure
			is_opened: raise_exception_on_error implies is_open
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end

	open_write (a_path: STRING) is
		require
			closed: not is_open
			a_path_not_empty: a_path /= Void and then not a_path.is_empty
		do
			open (a_path, abstract_O_WRONLY)
			if is_open then
				is_open_read := False
			end
		ensure
			is_opened: raise_exception_on_error implies is_open
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end

	open_read_write (a_path: STRING) is
		require
			closed: not is_open
			a_path_not_empty: a_path /= Void and then not a_path.is_empty
		do
			open (a_path, abstract_O_RDWR)
		ensure
			is_opened: raise_exception_on_error implies is_open
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end

	open_truncate (a_path: STRING) is
			-- Open file, if it exists, truncate it first.
		require
			closed: not is_open
			a_path_not_empty: a_path /= Void and then not a_path.is_empty
		do
			open (a_path, abstract_O_TRUNC)
			if is_open then
				is_open_read := False
			end
		ensure
			is_opened: raise_exception_on_error implies is_open
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end

	create_read_write (a_path: STRING) is
			-- Always create a file, existing or not.
			-- Give read/write permissions to user only.
		require
			closed: not is_open
			a_path_not_empty: a_path /= Void and then not a_path.is_empty
		do
			create_with_mode (
				a_path,
				abstract_O_CREAT + abstract_O_TRUNC + abstract_O_RDWR,
				abstract_S_IREAD + abstract_S_IWRITE)
		ensure
			is_opened: raise_exception_on_error implies is_open
			only_owner_has_read_write_permissions: True
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end

	create_write (a_path: STRING) is
			-- Always create a file, existing or not.
			-- Give read/write permissions to user only.
		require
			closed: not is_open
			a_path_not_empty: a_path /= Void and then not a_path.is_empty
		do
			create_with_mode (
				a_path,
				abstract_O_CREAT + abstract_O_TRUNC + abstract_O_WRONLY,
				abstract_S_IREAD + abstract_S_IWRITE)
			if is_open then
				is_open_read := False
			end
		ensure
			is_opened: raise_exception_on_error implies is_open
			only_owner_has_read_write_permissions: True
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end

	create_with_mode (a_path: STRING; flags, mode: INTEGER) is
			-- Create a file according to `flags' and with `mode' access
			-- permissions. Make sure you have th O_CREAT flag in flags
			-- if you really want to create something!
		require
			closed: not is_open
			a_path_not_empty: a_path /= Void and then not a_path.is_empty
		do
			do_make
			do_create (a_path, flags, mode)
			if is_open then
				is_open_read := True
				is_open_write := True
			end
		ensure
			is_opened: raise_exception_on_error implies is_open
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end


feature {NONE} -- Open

	do_open (a_path: STRING; flags: INTEGER) is
			-- Low level open of an existing file. `flags' should not
			-- contain the O_CREAT flag.
		require
			closed: not is_open
			a_path_not_empty: a_path /= Void and then not a_path.is_empty
			-- no_create_flag: flags && O_CREAT = 0
		local
			cpath: POINTER
			a_fd: INTEGER
		do
			set_portable_path (a_path)
			cpath := sh.string_to_pointer (name)
			a_fd := abstract_open (cpath, flags)
			sh.unfreeze_all
			if a_fd = -1 then
				raise_posix_error
			else
				capacity := 1
				set_handle (a_fd, True)
			end
		ensure
			is_opened: raise_exception_on_error implies is_open
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end

	do_create (a_path: STRING; flags, mode: INTEGER) is
			-- Low level create of the file in `a_path'.
		require
			closed: not is_open
			a_path_not_empty: a_path /= Void and then not a_path.is_empty
		local
			cpath: POINTER
			a_fd: INTEGER
		do
			set_portable_path (a_path)
			cpath := sh.string_to_pointer (name)
			a_fd := abstract_create (cpath, flags, mode)
			sh.unfreeze_all
			if a_fd = -1 then
				raise_posix_error
			else
				capacity := 1
				set_handle (a_fd, True)
			end
		ensure
			is_opened: raise_exception_on_error implies is_open
			open_files_increased_by_one:
				security.files.is_open_files_increased (is_owner, old security.files.open_files)
		end


feature -- File position

	rewind is
			-- Move input positionto the beginning of stream.
		do
			seek (0)
		ensure then
			not_end_of_file: not end_of_input
		end

	seek (offset: INTEGER) is
			-- Set file position to given absolute `offset'.
		require
			valid_offset: offset >= 0
		do
			safe_call (abstract_lseek (fd, offset, SEEK_SET))
			reset_eof
		ensure
			not_end_of_file: not end_of_input
		end

	seek_from_current (offset: INTEGER) is
			-- Set file position relative to current position.
		do
			safe_call (abstract_lseek (fd, offset, SEEK_CUR))
			reset_eof
		ensure
			not_end_of_file: not end_of_input
		end

	seek_from_end (offset: INTEGER) is
			-- Set file position relative to end of file.
		require
			valid_offset: offset <= 0
		do
			safe_call (abstract_lseek (fd, offset, SEEK_END))
			reset_eof
		ensure
			not_end_of_file: not end_of_input
		end


feature -- Access

	path: STRING is
		obsolete "2006-11-29: please use `name' instead"
		do
			Result := name
		end

	status: EPX_STATUS is
			-- The status for this file descriptor;
			-- Value is cached, recreated only when file reopened.
			-- Call `status'.`refresh' to get updated values.
		require
			open: is_open
		do
			if my_status = Void then
				make_status
			end
			Result := my_status
		ensure
			status_not_void: status /= Void
		end


feature {NONE} -- Implementation

	my_status: EPX_STATUS
			-- Cached status object.

	make_status is
			-- Give `my_status' a proper value.
		require
			open: is_open
		deferred
		ensure
			status_is_set: my_status /= Void
		end


feature {NONE} -- Low level handle functions

	do_close: BOOLEAN is
		do
			Result := precursor
			my_status := Void
		end


feature {NONE} -- Abstract API binding

	abstract_create (a_path: POINTER; oflag, mode: INTEGER): INTEGER is
			-- Creates a new file or rewrites an existing one
			-- does not call `creat' but `open'!
		deferred
		end

	abstract_lseek (fildes: INTEGER; offset, whence: INTEGER): INTEGER is
			-- Repositions read/write file offset.
		deferred
		end

	abstract_open (a_path: POINTER; oflag: INTEGER): INTEGER is
			-- Open a file.
		require
			a_path_not_null: a_path /= default_pointer
		deferred
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


feature {NONE} -- Open constants

	abstract_O_APPEND: INTEGER is
			-- Set the file offset to the end-of-file prior to each write.
		deferred
		end

	abstract_O_CREAT: INTEGER is
			-- If the file does not exist, allow it to be created. This
			-- flag indicates that the mode argument is present in the
			-- call to open.
		deferred
		end

	abstract_O_RDONLY: INTEGER is
			-- Open for reading only.
		deferred
		end

	abstract_O_RDWR: INTEGER is
			-- Open for reading and writing.
		deferred
		end

	abstract_O_TRUNC: INTEGER is
			-- Use only on ordinary files opened for writing. It causes
			-- the file to be truncated to zero length.
		deferred
		end

	abstract_O_WRONLY: INTEGER is
			-- Open for writing only.
		deferred
		end


feature {NONE} -- Permission constants

	abstract_S_IREAD: INTEGER is
		deferred
		end

	abstract_S_IWRITE: INTEGER is
		deferred
		end


invariant

	valid_status: not is_open implies my_status = Void


end
