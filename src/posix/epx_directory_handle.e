indexing

	description:

		"Implementation of a directory handle for POSIX."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"


class

	EPX_DIRECTORY_HANDLE


inherit

	POSIX_BASE

	ABSTRACT_DIRECTORY_HANDLE

	PAPI_DIRENT
		export
			{NONE} all
		end


create {ABSTRACT_DIRECTORY}

	make


feature -- Access

	max_filename_length: INTEGER is
			-- maximum length of a file in this directory
		local
			r: INTEGER
		do
			r := posix_pathconf (sh.string_to_pointer (directory_name), PC_NAME_MAX)
			sh.unfreeze_all
			if r = -1 then
				raise_posix_error
			end
			Result := r
		end


feature {NONE} -- Abstract API

	abstract_closedir (a_dirp: POINTER): INTEGER is
			-- Ends directory read operation
		do
			Result := posix_closedir (a_dirp)
		end

	abstract_opendir (a_dirname: POINTER): POINTER is
			-- Opens a directory
		do
			Result := posix_opendir (a_dirname)
		end

	abstract_readdir (a_dirp: POINTER): POINTER is
			-- Reads a directory
		do
			Result := posix_readdir (a_dirp)
		end

	abstract_rewinddir (a_dirp: POINTER) is
			-- Resets the readdir pointer
		do
			posix_rewinddir (a_dirp)
		end

	abstract_d_name (a_dirent: POINTER): POINTER is
		do
			Result := posix_d_name (a_dirent)
		end


end
