indexing

	description: "Class that covers the POSIX file system code."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"


class

	POSIX_FILE_SYSTEM


inherit

	EPX_FILE_SYSTEM

	PAPI_UTIME
		export
			{NONE} all
		end

	PAPI_MMAN
		export
			{NONE} all
		end


feature -- Read/write permissions

	chmod, change_mode (a_path: STRING; a_mode: INTEGER) is
			-- Changes file mode for `a_path' to `a_mode'.
		require
			valid_path: a_path /= Void and then not a_path.is_empty
		do
			set_portable_path (a_path)
			safe_call (posix_chmod (sh.string_to_pointer (portable_path), a_mode))
			sh.unfreeze_all
		end

	permissions (a_path: STRING): POSIX_PERMISSIONS is
			-- The permissions object (a new one every time!) for the
			-- given file
		require
			valid_path: a_path /= Void and then not a_path.is_empty
		do
			Result := status (a_path).permissions
		end

	set_read_only (a_path: STRING) is
			-- Make given file read_only.
		require
			valid_path: a_path /= Void and then not a_path.is_empty
		local
			perm: POSIX_PERMISSIONS
		do
			perm := status (a_path).permissions
			perm.set_allow_owner_write (False)
			perm.apply
		end

	set_writable (a_path: STRING) is
			-- Make given `a_path' read_only.
		require
			valid_path: a_path /= Void and then not a_path.is_empty
		local
			perm: POSIX_PERMISSIONS
		do
			perm := status (a_path).permissions
			perm.set_allow_owner_write (True)
			perm.apply
		end


feature -- File times

	touch (a_path: STRING) is
			-- Sets the modification and access times of `a_path' to the
			-- current time of day.
			-- File is created if it does not exist.
		local
			fd: POSIX_FILE_DESCRIPTOR
		do
			if not is_existing (a_path) then
				create fd.create_read_write (a_path)
				fd.close
			end
			set_portable_path (a_path)
			safe_call (posix_utime (sh.string_to_pointer (portable_path), -1, -1))
			sh.unfreeze_all
		end

	utime (a_path: STRING; access_time, modification_time: POSIX_TIME) is
			-- Sets file access and modification times.
		do
			set_portable_path (a_path)
			safe_call (posix_utime (sh.string_to_pointer (portable_path), access_time.value, modification_time.value))
			sh.unfreeze_all
		end


feature -- Further directory access

	link (existing, new: STRING) is
			-- Create a hard link to a file.
		require
			different_names: not existing.is_equal (new)
		local
			cexisting,
			cnew: POINTER
			portable_new: POSIX_PATH
		do
			set_portable_path (existing)
			cexisting := sh.string_to_pointer (portable_path)
			create portable_new.make_from_string (new)
			cnew := sh.string_to_pointer (portable_new)
			safe_call (posix_link (cexisting, cnew))
			sh.unfreeze_all
		end

	unlink (a_path: STRING) is
			-- Remove a directory entry, should be a file, not a directory.
			-- It's not an error if path does not exist, but all other
			-- errors are reported.
		require
			valid_path: a_path /= Void and then not a_path.is_empty
		local
			r: INTEGER
		do
			set_portable_path (a_path)
			r := posix_unlink (sh.string_to_pointer (portable_path))
			if r /= 0 and then errno.value /= ENOENT then
				raise_posix_error
			end
			sh.unfreeze_all
		end


feature -- FIFOs

	create_fifo, mkfifo (a_path: STRING; a_mode: INTEGER) is
			-- Create a FIFO special file.
		require
			valid_path: a_path /= Void and then not a_path.is_empty
		do
			safe_call (posix_mkfifo (sh.string_to_pointer (a_path), a_mode))
			sh.unfreeze_all
		end

	make_fifo (a_path: STRING; a_mode: INTEGER) is
		obsolete "This feature has been renamed to create_fifo"
		do
			create_fifo (a_path, a_mode)
		end


feature -- Shared memory

	unlink_shared_memory_object (name: STRING) is
			-- Remove a shared memory object.
		require
			valid_name: name /= Void and then not name.is_empty
		do
			safe_call (posix_shm_unlink (sh.string_to_pointer (name)))
			sh.unfreeze_all
		end


end
