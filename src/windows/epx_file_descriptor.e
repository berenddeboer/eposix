indexing

	description: "Class that makes it appear if Windows supports file %
	%descriptors. Windows doesn't. The few functions it has are not compatible%
	%with the rest of the system, therefore this class really is a wrapper%
	%for Windows HANDLE code.%
	%This is also why you can't switch from STDC_FILE to a %
	%EPX_FILE_DESCRIPTOR for example like you can with POSIX."

	bugs: "Basic calls raise exception, should be done by higher level calls."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #11 $"

class

	EPX_FILE_DESCRIPTOR


inherit

	EPX_DESCRIPTOR
		rename
			attach_to_descriptor as attach_to_fd
		undefine
			raise_posix_error,
			rewind,
			do_close
		end

	ABSTRACT_FILE_DESCRIPTOR
		undefine
			raise_posix_error
		end

	WINDOWS_BASE

	WAPI_IO


create

	make,
	open,
	open_read,
	open_write,
	open_read_write,
	open_truncate,
	create_read_write,
	create_write,
	create_with_mode,
	make_as_duplicate,
	attach_to_fd


feature {NONE} -- Implementation

	make_status is
		do
			create {WINDOWS_STATUS_FILDES} my_status.make (Current)
		end


feature {NONE} -- Abstract API binding

	abstract_create (a_path: POINTER; oflag, mode: INTEGER): INTEGER is
			-- Creates a new file or rewrites an existing one.
		local
			flags: INTEGER
		do
			-- Adding this flag would make creation of files in the
			-- temporary directory, at least on my machine, fail in a
			-- cygwin shell.
			--flags := FILE_FLAG_POSIX_SEMANTICS
			if test_bits (mode, FILE_ATTRIBUTE_READONLY) then
				flags := flip_bits (flags, FILE_ATTRIBUTE_READONLY, True)
			end
			Result := posix_createfile (a_path, GENERIC_WRITE, 0, default_pointer, CREATE_ALWAYS, flags, 0)
			if Result =  INVALID_HANDLE_VALUE then
				raise_windows_error
			end
		end

	abstract_lseek (fildes: INTEGER; offset, whence: INTEGER): INTEGER is
			-- Repositions read/write file offset
		local
			r: INTEGER
		do
			r := posix_setfilepointer (fildes, offset, default_pointer, whence)
			if r = -1 then
				errno.set_value (posix_getlasterror)
			end
		end

	abstract_open (a_path: POINTER; oflag: INTEGER): INTEGER is
			-- Opens a file
		local
			desired_access: INTEGER
		do
			if test_bits (oflag, GENERIC_READ) then
				desired_access := desired_access + GENERIC_READ
			end
			if test_bits (oflag, GENERIC_WRITE) then
				desired_access := desired_access + GENERIC_WRITE
			end
			--Result := posix_createfile (a_path, desired_access, 0, default_pointer, OPEN_EXISTING, FILE_FLAG_POSIX_SEMANTICS, 0)
			Result := posix_createfile (a_path, desired_access, 0, default_pointer, OPEN_EXISTING, 0, 0)
			if Result =  INVALID_HANDLE_VALUE then
				raise_windows_error
			end
		end


feature {NONE} -- open constants

	abstract_O_APPEND: INTEGER is
			-- Set the file offset to the end-of-file prior to each write
		do
			Result := O_APPEND
		end

	abstract_O_CREAT: INTEGER is
			-- If the file does not exist, allow it to be created. This
			-- flag indicates that the mode argument is present in the
			-- call to open.
		do
			Result := CREATE_NEW
		end

	abstract_O_RDONLY: INTEGER is
			-- Open for reading only
		do
			Result := GENERIC_READ
		end

	abstract_O_RDWR: INTEGER is
			-- Open fo reading and writing
		do
			Result := GENERIC_READ + GENERIC_WRITE
		end

	abstract_O_TRUNC: INTEGER is
			-- Use only on ordinary files opened for writing. It causes
			-- the file to be truncated to zero length.
		do
			Result := TRUNCATE_EXISTING
		end

	abstract_O_WRONLY: INTEGER is
			-- Open for writing only
		do
			Result := GENERIC_WRITE
		end


feature {NONE} -- permission constants

	abstract_S_IREAD: INTEGER is
		do
			Result := S_IREAD
		end

	abstract_S_IWRITE: INTEGER is
		do
			Result := S_IWRITE
		end


end
