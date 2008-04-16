indexing

	description: "Class that covers Posix stat structure."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


deferred class

	POSIX_STATUS


inherit

	EPX_STATUS

	POSIX_BASE

	PAPI_STAT


feature -- stat members

	is_block_special: BOOLEAN is
			-- True if block-special file
		do
			Result := posix_s_isblk (posix_st_mode (stat.ptr))
		end

	ino, inode: INTEGER is
		do
			Result := posix_st_ino (stat.ptr)
		end

	permissions: POSIX_PERMISSIONS is
			-- file permissions
		deferred
		ensure
			valid_result: Result /= Void
		end


feature -- direct access to the unix fields, not recommended

	unix_gid: INTEGER is
		do
			Result := posix_st_gid (stat.ptr)
		end

	unix_uid: INTEGER is
		do
			Result := posix_st_uid (stat.ptr)
		end


feature {NONE} -- portable API functions

	abstract_st_atime (a_stat: POINTER): INTEGER is
			-- time of last access
		do
			Result := posix_st_atime (a_stat)
		end

	abstract_st_ctime (a_stat: POINTER): INTEGER is
			-- time of last status change
		do
			Result := posix_st_ctime (a_stat)
		end

	abstract_st_dev (a_stat: POINTER): INTEGER is
			-- device number
		do
			Result := posix_st_dev (a_stat)
		end

	abstract_st_mode (a_stat: POINTER): INTEGER is
		do
			Result := posix_st_mode (a_stat)
		end

	abstract_st_mtime (a_stat: POINTER): INTEGER is
			-- time of last data modification
		do
			Result := posix_st_mtime (a_stat)
		end

	abstract_st_nlink (a_stat: POINTER): INTEGER is
			-- number of hard links
		do
			Result := posix_st_nlink (a_stat)
		end

	abstract_st_size (a_stat: POINTER): INTEGER is
			-- total size, in bytes
		do
			Result := posix_st_size (a_stat)
		end

	abstract_stat_size: INTEGER is
			-- return size of struct stat
		do
			Result := posix_stat_size
		end


feature {NONE} -- test file type bits

	abstract_s_ischr (m: INTEGER): BOOLEAN is
		do
			Result := posix_s_ischr (m)
		end

	abstract_s_isdir (m: INTEGER): BOOLEAN is
		do
			Result := posix_s_isdir (m)
		end

	abstract_s_isfifo (m: INTEGER): BOOLEAN is
		do
			Result := posix_s_isfifo (m)
		end

	abstract_s_isreg (m: INTEGER): BOOLEAN is
		do
			Result := posix_s_isreg (m)
		end

end
