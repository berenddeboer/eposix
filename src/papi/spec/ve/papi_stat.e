indexing

	description: "Class that covers Posix sys/stat.h."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

class

	PAPI_STAT


feature -- functions

	posix_chmod (a_path: POINTER; a_mode: INTEGER): INTEGER is
			-- Changes file mode



		external "C"

		end

	posix_fstat (fildes: INTEGER; a_stat: POINTER): INTEGER is
			-- Gets file status
		require
			valid_stat_buffer: a_stat /= default_pointer



		external "C"

		ensure
			-- Result = -1 implies errno.is_not_ok
		end

	posix_mkdir (path: POINTER; mode: INTEGER): INTEGER is
			-- Makes a directory



		external "C"

		end

	posix_mkfifo (a_path: POINTER; a_mode: INTEGER): INTEGER is
			-- Makes a FIFO special file



		external "C"

		end

	posix_stat (a_path: POINTER; a_stat: POINTER): INTEGER is
			-- Gets information about a file
		require
			valid_stat_buffer: a_stat /= default_pointer



		external "C"

		ensure
			-- Result = -1 implies errno.is_not_ok
		end

	posix_umask (a_mask: INTEGER): INTEGER is
			-- Turn off permission bits specified in `a_mask'
		external "C"
		ensure
			-- previous mask is returned
		end


feature -- POSIX C interface

	posix_stat_size: INTEGER is
			-- return size of struct stat
		external "C"
		end


feature -- POSIX C stat member interface

	posix_st_atime (a_stat: POINTER): INTEGER is
			-- time of last access
		external "C"
		end

	posix_st_ctime (a_stat: POINTER): INTEGER is
			-- time of last status change
		external "C"
		end

	posix_st_dev (a_stat: POINTER): INTEGER is
			-- device number
		external "C"
		end

	posix_st_gid (a_stat: POINTER): INTEGER is
		external "C"
		end

	posix_st_ino (a_stat: POINTER): INTEGER is
		external "C"
		end

	posix_st_mode (a_stat: POINTER): INTEGER is
		external "C"
		end

	posix_st_mtime (a_stat: POINTER): INTEGER is
			-- time of last data modification
		external "C"
		end

	posix_st_nlink (a_stat: POINTER): INTEGER is
			-- number of hard links
		external "C"
		end

	posix_st_size (a_stat: POINTER): INTEGER is
			-- total size, in bytes
		external "C"
		end

	posix_st_uid (a_stat: POINTER): INTEGER is
		external "C"
		end


feature -- test file type bits

	posix_s_isblk (m: INTEGER): BOOLEAN is
		external "C"
		end

	posix_s_ischr (m: INTEGER): BOOLEAN is
		external "C"
		end

	posix_s_isdir (m: INTEGER): BOOLEAN is
		external "C"
		end

	posix_s_isfifo (m: INTEGER): BOOLEAN is
		external "C"
		end

	posix_s_isreg (m: INTEGER): BOOLEAN is
		external "C"
		end


end
