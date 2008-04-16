indexing

	description: "Class that implements ABSTRACT_FILE_SYSTEM for Windows systems."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #9 $"


class

	EPX_FILE_SYSTEM


inherit

	ABSTRACT_FILE_SYSTEM
		undefine
			raise_posix_error
		end

	WINDOWS_BASE

	WAPI_DIRECT
		export
			{NONE} all
		end

	WAPI_IO
		export
			{NONE} all
		end

	WAPI_WINDOWS
		export
			{NONE} all
		end


feature -- file statistics

	status (a_path: STRING): WINDOWS_STATUS_PATH is
			-- Gets information about a file
		do
			create {WINDOWS_STATUS_PATH} Result.make (a_path)
		end

	status_may_fail (a_path: STRING): WINDOWS_STATUS_PATH is
			-- Retrieve status information for `a_path'. `a_path' may or
			-- may not exist. Check `Result'.`found' to see if statistics
			-- were retrieved.
		do
			create {WINDOWS_STATUS_PATH} Result.make_may_fail (a_path)
		end


feature -- directory browsing

	browse_directory (a_path: STRING): WINDOWS_DIRECTORY is
			-- Gets information about a directory
		do
			create Result.make (a_path)
		end


feature -- various

	is_case_sensitive: BOOLEAN is
			-- is file system case sensitive or not?
		do
			Result := False
		end

	path_separator: CHARACTER is
			-- What is the path separator?
		once
			Result := '\'
		end


feature -- file system properties

	temporary_directory: STRING is
			-- The name of the temporary directory;
			-- Name does not end with the directory separator.
		local
			buf: STDC_BUFFER
			r: INTEGER
		once
			create buf.allocate (MAX_PATH)
			r := posix_gettemppath (MAX_PATH, buf.ptr)
			if r = 0 then
				raise_posix_error
			end
			if r > MAX_PATH then
				create buf.allocate (r)
				r := posix_gettemppath (r, buf.ptr)
				if r = 0 then
					raise_posix_error
				end
			end
			Result := sh.pointer_to_string (buf.ptr)
			if Result.item (Result.count) = path_separator then
				Result.remove (Result.count)
			end
		end


feature {NONE} -- abstract C interface

	abstract_access (a_path: POINTER; a_mode: INTEGER): INTEGER is
			-- Tests for file accessibility
		do
			Result := posix_access (a_path, a_mode)
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
			-- Makes a directory
		do
			Result := posix_mkdir(a_path)
		end

	abstract_rmdir (a_path: POINTER): INTEGER is
			-- Removes a directory
		do
			Result := posix_rmdir (a_path)
		end

	abstract_F_OK: INTEGER is
		do
			Result := 0
		end

	abstract_R_OK: INTEGER is
		do
			Result := 4
		end

	abstract_W_OK: INTEGER is
		do
			Result := 2
		end

	abstract_X_OK: INTEGER is
		do
			Result := 6
		end


end
