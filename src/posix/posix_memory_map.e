indexing

	description: "Class that covers POSIX memory mapping."

	to_do: "Perhaps enhance STDC_BUFFER that resizing is forbidden."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"

class

	POSIX_MEMORY_MAP

inherit

	ABSTRACT_MEMORY_MAP
		redefine
			close,
			dispose
		end

	POSIX_BUFFER
		undefine
			dispose,
			copy,
			is_equal
		end

	PAPI_MMAN
		export
			{NONE} all
		undefine
			copy,
			is_equal
		end


create

	make,
	make_private,
	make_shared


feature -- Initialization

	make (a_fd: POSIX_FILE_DESCRIPTOR; a_offset, a_size: INTEGER;  a_base: POINTER; a_prot, a_flags: INTEGER) is
			-- Raw interface to mmap.
			-- This function can fail on certain system (Linux for
			-- example) if a_offset is not a multiple of PAGE_SIZE.
		require
			closed: not is_open
			have_file_descriptor: a_fd /= Void
			file_descriptor_open: a_fd.is_open
			offset_not_negative: a_offset >= 0
			size_is_positive: a_size > 0
		do
			fd := a_fd
			offset := a_offset
			ptr := posix_mmap (a_base, a_size, a_prot, a_flags, fd.value, offset)
			if ptr = MAP_FAILED then
				raise_posix_error
			end
			make_from_pointer (ptr, a_size, False)
		ensure
			open: raise_exception_on_error implies is_open
		end

	make_private (a_fd: POSIX_FILE_DESCRIPTOR; a_offset, a_size: INTEGER ) is
			-- Make the given file descriptor. `a_fd' should have been opened
			-- with read/write access.
			-- This is a mapping where changes are private.
			-- `a_offset' denotes the offset from `a_fd'.
			-- This function can fail on certain system (Linux for
			-- example) if a_offset is not a multiple of PAGE_SIZE.
		require
			closed: not is_open
			have_file_descriptor: a_fd /= Void
			offset_not_negative: a_offset >= 0
			size_is_positive: a_size > 0
			open_for_reading: a_fd.is_open_read
		do
			make (a_fd, a_offset, a_size, default_pointer, PROT_READ + PROT_WRITE, MAP_PRIVATE)
		ensure
			open: raise_exception_on_error implies is_open
		end

	make_shared (a_fd: POSIX_FILE_DESCRIPTOR; a_offset, a_size: INTEGER) is
			-- Make the given file descriptor. `a_fd' should have been opened
			-- with read/write access.
			-- This is a mapping where changes are shared, i.e. the
			-- `a_offset' denotes the offset from `a_fd'.
			-- underlying object is also changed.
			-- This function can fail on certain system (Linux for
			-- example) if a_offset is not a multiple of PAGE_SIZE.
		require
			closed: not is_open
			have_file_descriptor: a_fd /= Void
			offset_not_negative: a_offset >= 0
			size_is_positive: a_size > 0
			open_for_reading: a_fd.is_open_read
			open_for_writing: a_fd.is_open_write
		do
			make (a_fd, a_offset, a_size, default_pointer, PROT_READ + PROT_WRITE, MAP_SHARED)
		ensure
			open: raise_exception_on_error implies is_open
		end


feature {NONE} -- Removal

	dispose is
		local
			r: INTEGER
		do
			if ptr /= default_pointer then
				r := posix_munmap (ptr, capacity)
			end
			precursor
		rescue
			ptr := default_pointer
			retry
		end


feature -- Unmap

	close is
			-- Remove the mapping.
		do
			safe_call (posix_munmap (ptr, capacity))
			offset := 0
			precursor
		end


feature -- Access

	fd: POSIX_FILE_DESCRIPTOR
			-- The file that is mapped.

	offset: INTEGER
			-- Offset in `fd' where mapping begins.


invariant

	offset_not_negative: offset >= 0
	have_file_descriptor: fd /= Void
	file_descriptor_open: fd.is_open

end
