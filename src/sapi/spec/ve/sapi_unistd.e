indexing

	description: "Class that covers the Single Unix Spec unistd.h header."

	author: "Berend de Boer"
	date: "$Date: 2007/05/18 $"
	revision: "$Revision: #1 $"


class

	SAPI_UNISTD


inherit

	PAPI_UNISTD


feature -- File system functions

	posix_symlink (oldpath, newpath: POINTER): INTEGER is
			-- Make a new name for a file.
		require
			valid_oldpath: oldpath /= default_pointer
			valid_newpath: newpath /= default_pointer



		external "C"

		ensure
			-- Result = -1 implies errno.is_not_ok
		end


feature -- Various

	posix_gethostname(name: POINTER; namelen: INTEGER): INTEGER is
			-- The standard host name for the current machine
		require
			valid_name: name /= default_pointer
			valid_namelen: namelen > 0
		external "C"
		ensure
			-- host names are limited to 255 bytes
			-- 0 on success, -1 on error
		end


end
