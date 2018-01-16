note

	description: "Class that implements the portable file descriptor routines in POSIX."

	author: "Berend de Boer"


class

	EPX_FILE_DESCRIPTOR


inherit

	EPX_DESCRIPTOR
		rename
			attach_to_descriptor as attach_to_fd,
			status_flags as file_status_flags
		undefine
			rewind,
			do_close
		end

	ABSTRACT_FILE_DESCRIPTOR
		undefine
			is_blocking_io,
			set_blocking_io,
			supports_nonblocking_io
		end

	PAPI_UNISTD

	PAPI_FCNTL


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

	new_status: like status
		do
			create {POSIX_STATUS_FILDES} Result.make (Current)
		end


feature {NONE} -- Abstract API binding

	abstract_create (a_path: POINTER; oflag, mode: INTEGER): INTEGER
			-- Creates a new file or rewrites an existing one
			-- does not call `creat' but `open'!
		do
			Result := posix_create (a_path, oflag, mode)
		end

	abstract_lseek (fildes: INTEGER; offset, whence: INTEGER): INTEGER
			-- Repositions read/write file offset
		do
			Result := posix_lseek (fildes, offset, whence)
		end

	abstract_open (a_path: POINTER; oflag: INTEGER): INTEGER
			-- Opens a file
		do
			Result := posix_open (a_path, oflag)
		end


feature {NONE} -- open constants

	abstract_O_APPEND: INTEGER
			-- Set the file offset to the end-of-file prior to each write
		do
			Result := O_APPEND
		end

	abstract_O_CREAT: INTEGER
			-- If the file does not exist, allow it to be created. This
			-- flag indicates that the mode argument is present in the
			-- call to open.
		do
			Result := O_CREAT
		end

	abstract_O_RDONLY: INTEGER
			-- Open for reading only
		do
			Result := O_RDONLY
		end

	abstract_O_RDWR: INTEGER
			-- Open fo reading and writing
		do
			Result := O_RDWR
		end

	abstract_O_TRUNC: INTEGER
			-- Use only on ordinary files opened for writing. It causes
			-- the file to be truncated to zero length.
		do
			Result := O_TRUNC
		end

	abstract_O_WRONLY: INTEGER
			-- Open for writing only
		do
			Result := O_WRONLY
		end


feature {NONE} -- permission constants

	abstract_S_IREAD: INTEGER
		do
			Result := S_IREAD
		end

	abstract_S_IWRITE: INTEGER
		do
			Result := S_IWRITE
		end


end
