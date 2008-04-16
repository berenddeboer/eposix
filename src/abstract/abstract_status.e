indexing

	description: "Base class that covers parts of the stat structure that%
	% are available with Windows and POSIX."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"


deferred class

	ABSTRACT_STATUS


inherit

	STDC_BASE


feature {NONE} -- Initialization

	make_stat is
			-- Make sure stat buffer is there
		do
			if stat = Void then
				create stat.allocate (abstract_stat_size)
			end
		ensure
			have_stat: stat /= Void
			stat_has_capacity: stat.capacity >= abstract_stat_size
		end


feature -- Status

	is_open: BOOLEAN is
			-- Can status be refreshed?
		deferred
		end


feature -- Change

	refresh is
			-- refresh the cached information
		require
			open: is_open
		deferred
		end


feature {NONE} -- Implementation

	stat: STDC_BUFFER
			-- Holds statistics


feature -- stat members

	atime, access_time: INTEGER is
			-- Unix time of last access.
		do
			Result := abstract_st_atime (stat.ptr)
		end

	ctime: INTEGER is
		obsolete "Use status_change_time instead."
		do
			Result := status_change_time
		end

	change_time: INTEGER is
		obsolete "Use status_change_time instead."
		do
			Result := status_change_time
		end

	device_number: INTEGER is
			-- ID of device containing the file.
			-- Windows: Drive number of the disk containing the file.
		do
			Result := abstract_st_dev (stat.ptr)
		end

	is_character_special: BOOLEAN is
			-- Is this file a character-special file?
		do
			Result := abstract_s_ischr (abstract_st_mode (stat.ptr))
		end

	is_directory: BOOLEAN is
		do
			Result := abstract_s_isdir (abstract_st_mode (stat.ptr))
		end

	is_fifo: BOOLEAN is
		do
			Result := abstract_s_isfifo (abstract_st_mode (stat.ptr))
		end

	is_regular_file: BOOLEAN is
		do
			Result := abstract_s_isreg (abstract_st_mode (stat.ptr))
		end

	mtime, modification_time: INTEGER is
			-- Unix time of last data modification.
		do
			Result := abstract_st_mtime (stat.ptr)
		end

	nlink, number_of_hard_links: INTEGER is
		do
			Result := abstract_st_nlink (stat.ptr)
		end

	size: INTEGER is
			-- Size of file in bytes.
		do
			Result := abstract_st_size (stat.ptr)
		ensure
			valid_size: size >= 0
		end

	status_change_time: INTEGER is
			-- Unix time of last status change.
			-- For example changing the permission bits will set this time.
		do
			Result := abstract_st_ctime (stat.ptr)
		end


feature -- Direct access to the individual stat fields, not recommended

	unix_mode: INTEGER is
		do
			Result := abstract_st_mode (stat.ptr)
		end


feature {NONE} -- Portable API functions

	abstract_st_atime (a_stat: POINTER): INTEGER is
			-- time of last access
		deferred
		end

	abstract_st_ctime (a_stat: POINTER): INTEGER is
			-- time of last status change
		deferred
		end

	abstract_st_dev (a_stat: POINTER): INTEGER is
			-- device number
		deferred
		end

	abstract_st_mode (a_stat: POINTER): INTEGER is
		deferred
		end

	abstract_st_mtime (a_stat: POINTER): INTEGER is
		-- time of last data modification
		deferred
		end

	abstract_st_nlink (a_stat: POINTER): INTEGER is
			-- number of hard links
		deferred
		end

	abstract_st_size (a_stat: POINTER): INTEGER is
			-- total size, in bytes
		deferred
		end

	abstract_stat_size: INTEGER is
			-- return size of struct stat
		deferred
		end


feature {NONE} -- test file type bits

	abstract_s_ischr (m: INTEGER): BOOLEAN is
		deferred
		end

	abstract_s_isdir (m: INTEGER): BOOLEAN is
		deferred
		end

	abstract_s_isfifo (m: INTEGER): BOOLEAN is
		deferred
		end

	abstract_s_isreg (m: INTEGER): BOOLEAN is
		deferred
		end


invariant

	stat_not_void:
		stat /= Void and then stat.capacity >= abstract_stat_size

end
