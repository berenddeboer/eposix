indexing

	description: "Class that covers Posix unistd.h."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

class

	PAPI_DIRENT


feature -- C layer

	posix_pathconf (a_path: POINTER; a_name: INTEGER): INTEGER is
		external "C"
		end

	posix_closedir (a_dirp: POINTER): INTEGER is
			-- Ends directory read operation
		external "C"
		end

	posix_opendir (a_dirname: POINTER): POINTER is
			-- Opens a directory

		external "C blocking"



		end

	posix_readdir (a_dirp: POINTER): POINTER is
			-- Reads a directory

		external "C blocking"



		end

	posix_rewinddir (a_dirp: POINTER) is
			-- Resets the readdir pointer
		external "C"
		end

	posix_d_name (a_dirent: POINTER): POINTER is
		external "C"
		end


end -- class PAPI_DIRENT
