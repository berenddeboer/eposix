indexing

	description:

		"Implementation of a directory handle for POSIX."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


class

	EPX_DIRECTORY_HANDLE


inherit

	WINDOWS_BASE

	ABSTRACT_DIRECTORY_HANDLE
		undefine
			raise_posix_error
		redefine
			make
		end

	WAPI_WINDOWS
		export
			{NONE} all
		end


create {ABSTRACT_DIRECTORY}

	make


feature {NONE} -- Initialization

	make  (a_directory_name: STRING) is
		do
			create find_file_data.allocate_and_clear (posix_win32_find_data_size)
			precursor (a_directory_name)
		end


feature -- Access

	max_filename_length: INTEGER is
			-- Maximum length of a file in this directory.
		do
			Result := MAX_PATH
		end


feature {NONE} -- Abstract API internal state

	find_handle: POINTER

	find_file_data: STDC_BUFFER


feature {NONE} -- Abstract API

	abstract_closedir (a_dirp: POINTER): INTEGER is
			-- Ends directory read operation
		do
			if posix_findclose (find_handle) then
				Result := 0
			else
				Result := -1
			end
			find_handle := default_pointer
		ensure then
			handle_is_reset: find_handle = default_pointer
		end

	abstract_opendir (a_dirname: POINTER): POINTER is
			-- Opens a directory
		do
			find_handle := default_pointer
			Result := find_file_data.ptr
		end

	abstract_readdir (a_dirp: POINTER): POINTER is
			-- Reads a directory
		local
			b: BOOLEAN
		do
			if find_handle = default_pointer then
				find_handle := posix_findfirstfile (sh.string_to_pointer (directory_name + "\*.*"), a_dirp)
				if find_handle = INVALID_PTR_HANDLE_VALUE then
					Result := default_pointer
				else
					Result := find_file_data.ptr
				end
			else
				b := posix_findnextfile (find_handle, a_dirp)
				if not b then
					Result := default_pointer
				else
					Result := find_file_data.ptr
				end
			end
		ensure then
			possible_results: Result = default_pointer or else
				Result = find_file_data.ptr
		end

	abstract_rewinddir (a_dirp: POINTER) is
			-- Reset the readdir pointer.
		do
			if is_open then
				close
			end
		end

	abstract_d_name (a_dirent: POINTER): POINTER is
		do
			Result := posix_win32_find_data_filename (a_dirent)
		end


invariant

	valid_find_file_data: find_file_data /= Void
	find_file_data_enough_capacity: find_file_data.capacity >= posix_win32_find_data_size


end
