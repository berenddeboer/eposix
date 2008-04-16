indexing

	description: "Class that covers Windows direct.h."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #2 $"

class

	WAPI_DIRECT


feature -- functions with path as argument

	posix_chdir (a_path: POINTER): INTEGER is
			-- Changes the current working directory
		require
			valid_path: a_path /= default_pointer



		external "C"

		end

	posix_chdrive (a_drive: INTEGER): INTEGER is
			-- Change current drive
		require
			valid_drive: a_drive >= 0



		external "C"

		end

	posix_getcwd (a_buf: POINTER; a_size: INTEGER): POINTER is
			-- Gets current working directory
		require
			valid_size: a_size >= 0
		external "C"
		end

	posix_getdcwd (a_drive: INTEGER; a_buf: POINTER; a_size: INTEGER): POINTER is
			-- Get current working directory for specified drive
		require
			valid_drive: a_drive >= 0
			valid_size: a_size >= 0
		external "C"
		end

	posix_getdrive: INTEGER is
			-- Gets the current disk drive.
		external "C"
		end

	posix_mkdir (a_path: POINTER): INTEGER is
			-- Makes a directory
		require
			valid_path: a_path /= default_pointer



		external "C"

		end

	posix_rmdir (a_path: POINTER): INTEGER is
			-- Removes a directory
		require
			valid_path: a_path /= default_pointer



		external "C"

		end


end -- class WAPI_DIRECT
