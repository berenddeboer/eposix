indexing

	description: "Class that gets windows stat structure through stat call."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #6 $"

class

	WINDOWS_STATUS_PATH


inherit

	WINDOWS_STATUS

	ABSTRACT_STATUS_PATH
		undefine
			raise_posix_error
		redefine
			set_path
		end

	WAPI_STAT
		export
			{NONE} all
		end


create {EPX_FILE_SYSTEM}

	make,
	make_may_fail


feature -- State change commands

	set_path (a_path: STRING) is
			-- Change for which filename the statistics are
			-- kept. Statistics are immediately refreshed.
		do
			-- Windows doesn't like a trailing slash.
			if
				a_path.item (a_path.count) = '\' or else
				a_path.item (a_path.count) = '/'
			then
				set_portable_path (a_path.substring (1, a_path.count - 1))
			else
				set_portable_path (a_path)
			end
			refresh
		end


feature {NONE} -- abstract API

	abstract_stat (a_path: POINTER; a_stat: POINTER): INTEGER is
			-- Gets information about a file.
		local
			ignore: BOOLEAN
			find_handle: POINTER
		do
			Result := posix_stat (a_path, a_stat)
			if Result = 0 then
				-- Bill Gates made an error in his stat. The times are
				-- corrected for daylight saving time on NT based shit.
				-- I hack around this by doing a FindFirstFile call and hope
				-- for the best.
				create find_data.allocate_and_clear (posix_win32_find_data_size)

				find_handle := posix_findfirstfile (a_path, find_data.ptr)
				if find_handle /= INVALID_PTR_HANDLE_VALUE then
					ignore := posix_findclose (find_handle)
				else
					find_data.deallocate
					find_data := Void
				end
			else
				Result := -1
			end
		end


feature {NONE} -- Implementation

	find_data: STDC_BUFFER


feature {NONE} -- abstract stat member functions

	abstract_st_atime (a_stat: POINTER): INTEGER is
			-- Time of last access.
		do
			if find_data /= Void then
				Result := posix_win32_find_data_ftlastaccesstime (find_data.ptr)
			else
				Result := posix_st_atime (a_stat)
			end
		end

	abstract_st_ctime (a_stat: POINTER): INTEGER is
			-- Time of last status change.
		do
			if find_data /= Void then
				Result := posix_win32_find_data_ftcreationtime (find_data.ptr)
			else
				Result := posix_st_ctime (a_stat)
			end
		end

	abstract_st_dev (a_stat: POINTER): INTEGER is
			-- Drive number of the disk containing the file
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
			if find_data /= Void then
				Result := posix_win32_find_data_ftlastwritetime (find_data.ptr)
			else
				Result := posix_st_mtime (a_stat)
			end
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
