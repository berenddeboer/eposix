note

	description: "Class that implements the portable descriptor routines in POSIX."

	author: "Berend de Boer"


class

	EPX_DESCRIPTOR


inherit

	ABSTRACT_DESCRIPTOR
		redefine
			is_blocking_io,
			set_blocking_io,
			supports_nonblocking_io
		end

	POSIX_BASE

	PAPI_UNISTD

	PAPI_FCNTL


create

	make,
	make_as_duplicate,
	attach_to_descriptor


feature -- non-blocking i/o

	is_blocking_io: BOOLEAN
			-- Is blocking i/o enabled (default)?
		do
			Result := not test_bits (status_flags, O_NONBLOCK)
		end

	set_blocking_io (enable: BOOLEAN)
			-- Set `is_blocking_io'.
		local
			new_flags: INTEGER
		do
			new_flags := flip_bits (status_flags, O_NONBLOCK, not enable)
			safe_call (posix_fcntl_arg (value, F_SETFL, new_flags))
		end

	supports_nonblocking_io: BOOLEAN = True


feature {NONE} -- Access

	status_flags: INTEGER
			-- All status bits associated with this handle
		require
			open: is_open
		do
			Result := posix_fcntl (value, F_GETFL)
		end


feature {NONE} -- Abstract API binding

	abstract_close (fildes: INTEGER): INTEGER
			-- Closes a a file
		do
			Result := posix_close (fildes)
		end

	abstract_dup (fildes: INTEGER): INTEGER
			-- Duplicates an open file descriptor
		do
			Result := posix_dup (fildes)
		end

	abstract_dup2 (fildes, fildes2: INTEGER): INTEGER
			-- Duplicates an open file descriptor
			-- fildes is the file descriptor to duplicate, fildes2 is the
			-- desired new file descriptor.
		do
			Result := posix_dup2 (fildes, fildes2)
		end

	abstract_isatty (fildes: INTEGER): BOOLEAN
			-- Determines if a file descriptor is associated with a terminal
		do
			Result := posix_isatty (fildes)
		end

	abstract_read (fildes: INTEGER; buf: POINTER; nbyte: INTEGER): INTEGER
			-- Reads from a file.
		do
			Result := posix_read (fildes, buf, nbyte)
		end

	abstract_write (fildes: INTEGER; buf: POINTER; nbyte: INTEGER): INTEGER
			-- Reads from a file.
		do
			Result := posix_write (fildes, buf, nbyte)
		end


feature {NONE} -- error codes

	abstract_EWOULDBLOCK: INTEGER
			-- The process would be delayed in the I/O operation
		do
			-- For Unix we assume EAGAIN and EWOULDBLOCK are equal.
			Result := EAGAIN
		end

	abstract_EINTR: INTEGER
			-- read/write was interrupted
		do
			Result := EINTR
		end


end
