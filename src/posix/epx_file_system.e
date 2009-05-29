indexing

	description: "Class that implements ABSTRACT_FILE_SYSTEM for POSIX systems."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #9 $"


class

	EPX_FILE_SYSTEM


inherit

	POSIX_BASE

	ABSTRACT_FILE_SYSTEM
		redefine
			remove_directory, rmdir,
			remove_file
		end

	PAPI_UNISTD
		export
			{NONE} all
		end

	PAPI_STAT
		export
			{NONE} all
		end


feature -- further directory access

	remove_directory, rmdir (a_directory: STRING) is
			-- Removes an empty directory, does not fail if directory
			-- does not exist
		local
			r: INTEGER
		do
			set_portable_path (a_directory)
			r := abstract_rmdir (sh.string_to_pointer (portable_path))
			sh.unfreeze_all
			if r /= 0 and then errno.value /= ENOENT then
				raise_posix_error
			end
		end

	remove_file (a_path: STRING) is
			-- calls `unlink' when `a_path' is a file, or `rmdir' when
			-- `a_path' is a directory.
			-- error when file could not be removed (and it exists)
		local
			r: INTEGER
		do
			set_portable_path (a_path)
			r := posix_remove (sh.string_to_pointer (portable_path))
			sh.unfreeze_all
			if r /= 0 and then errno.value /= ENOENT then
				raise_posix_error
			end
		end


feature -- directory browsing

	browse_directory (a_path: STRING): POSIX_DIRECTORY is
		do
			create Result.make (a_path)
		end


feature -- various queries

	is_case_sensitive: BOOLEAN is
			-- is file system case sensitive or not?
		do
			Result := True
		end

	path_separator: CHARACTER is
			-- What is the path separator?
		once
			Result := '/'
		end


feature -- file statistics

	status (a_path: STRING): POSIX_STATUS_PATH is
			-- Gets information about a file
		do
			create {POSIX_STATUS_PATH} Result.make (a_path)
		end

	status_may_fail (a_path: STRING): ABSTRACT_STATUS_PATH is
			-- Retrieve status information for `a_path'. `a_path' may or
			-- may not exist. Check `Result'.`found' to see if statistics
			-- were retrieved.
		do
			create {POSIX_STATUS_PATH} Result.make_may_fail (a_path)
		end


feature -- file system properties

	temporary_directory: STRING is
			-- the temporary directory
		local
			tmpdir,
			tmp: POSIX_ENV_VAR
		once
			create tmpdir.make ("TMPDIR")
			if tmpdir.exist then
				Result := tmpdir.value
			else
				create tmp.make ("TMP")
				if tmp.exist then
					Result := tmp.value
				end
			end
			if
				Result = Void or else
				not is_directory (Result) or else
				not is_modifiable (Result) then
				-- let's hope for the best...
				Result := "/tmp"
			end
		end


feature {NONE} -- abstract C interface

	abstract_access (a_path: POINTER; a_mode: INTEGER): INTEGER is
			-- Tests for file accessibility
		do
			Result := posix_access (a_path, a_mode)
			errno.clear
		end

	abstract_chdir (a_path: POINTER): INTEGER is
			-- Changes the current working directory
		do
			Result := posix_chdir (a_path)
		end

	abstract_getcwd (buf: POINTER; size: INTEGER): POINTER is
			-- Gets current working directory
		do
			Result := posix_getcwd (buf, size)
		end

	abstract_mkdir (a_path: POINTER): INTEGER is
			-- Makes a directory. Accessible by user and group, unless
			-- modified by umask.
		do
			Result := posix_mkdir(a_path, S_IRUSR + S_IWUSR + S_IXUSR + S_IRGRP + S_IWGRP + S_IXGRP)
		end

	abstract_rmdir (a_path: POINTER): INTEGER is
			-- Removes a directory
		do
			Result := posix_rmdir (a_path)
		end

	abstract_F_OK: INTEGER is
		do
			Result := F_OK
		end

	abstract_R_OK: INTEGER is
		do
			Result := R_OK
		end

	abstract_W_OK: INTEGER is
		do
			Result := W_OK
		end

	abstract_X_OK: INTEGER is
		do
			Result := X_OK
		end

end
