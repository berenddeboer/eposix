indexing

	description: "Class that gets Windows stat structure through fstat call."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"

class

	WINDOWS_STATUS_FILDES


inherit

	WINDOWS_STATUS

	ABSTRACT_STATUS_FILDES
		undefine
			raise_posix_error
		end

	WAPI_WINDOWS


create {EPX_FILE_DESCRIPTOR}

	make


feature {NONE} -- abstract API

	abstract_fstat (fildes: INTEGER; a_stat: POINTER): INTEGER is
			-- Gets information about a file
			-- contains awful workaround if fildes is a pipe...
		local
			success: BOOLEAN
			error: INTEGER
		do
			success := posix_getfileinformationbyhandle (fildes, a_stat)
			if not success then
				error := posix_getlasterror
				if
					error = ERROR_NOT_SUPPORTED or else
					error = ERROR_INVALID_HANDLE then
					-- assume it's a pipe, do our dirty trick
					my_is_fifo := True
				else
					raise_windows_error
				end
			end
			Result := 0
		end


feature {NONE} -- portable API functions

	abstract_st_atime (a_stat: POINTER): INTEGER is
			-- time of last access
		do
			Result := posix_by_handle_file_information_ftlastaccesstime (a_stat)
		end

	abstract_st_ctime (a_stat: POINTER): INTEGER is
			-- time of last status change
		do
			Result := posix_by_handle_file_information_ftlastwritetime (a_stat)
		end

	abstract_st_dev (a_stat: POINTER): INTEGER is
			-- Drive number of the disk containing the file
		do
			Result := posix_by_handle_file_information_dwvolumeserialnumber (a_stat)
		end

	abstract_st_mode (a_stat: POINTER): INTEGER is
		do
			Result := posix_by_handle_file_information_dwfileattributes (a_stat)
		end

	abstract_st_mtime (a_stat: POINTER): INTEGER is
			-- time of last data modification
		do
			Result := posix_by_handle_file_information_ftlastwritetime (a_stat)
		end

	abstract_st_nlink (a_stat: POINTER): INTEGER is
			-- number of hard links
		do
			Result := posix_by_handle_file_information_nnumberoflinks (a_stat)
		end

	abstract_st_size (a_stat: POINTER): INTEGER is
			-- total size, in bytes
		do
			Result := posix_by_handle_file_information_nfilesizelow (a_stat)
		end

	abstract_stat_size: INTEGER is
			-- return size of struct stat
		do
			Result := posix_by_handle_file_information_size
		end


feature {NONE} -- test file type bits

	abstract_s_ischr (m: INTEGER): BOOLEAN is
		do
			Result := True
		end

	abstract_s_isdir (m: INTEGER): BOOLEAN is
		do
			Result := test_bits (m, FILE_ATTRIBUTE_DIRECTORY)
		end

	abstract_s_isfifo (m: INTEGER): BOOLEAN is
		do
			Result := my_is_fifo
		end

	abstract_s_isreg (m: INTEGER): BOOLEAN is
		do
			Result := not test_bits (m, FILE_ATTRIBUTE_DIRECTORY)
		end


feature {NONE} -- private trick state

	my_is_fifo: BOOLEAN


end
