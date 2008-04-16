indexing

	description: "Class that covers the Standard C file system code. %
	%There was not much to cover..."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #8 $"

class

	STDC_FILE_SYSTEM


inherit

	STDC_BASE

	PORTABLE_PATH
		export
			{NONE} all
		end

	CAPI_STDIO
		export
			{NONE} all
		end


feature -- Path names

	expand_path (a_path: STRING): STDC_PATH is
			-- returns a new path
		do
			create Result.make_expand (a_path)
		end


feature -- Rename files/directories, remove files/directories

	remove_file (a_path: STRING) is
			-- Removes a file from a directory.
			-- For Standard C, it's implementation defined what
			-- remove_file does if file is opened by some process
			-- (`remove_file' fails on Windows for example).
			-- doesn't remove a directory.
		require
			valid_path: a_path /= Void and then not a_path.is_empty
		local
			r: INTEGER
		do
			set_portable_path (a_path)
			r := posix_remove (sh.string_to_pointer (portable_path))
			sh.unfreeze_all
			-- in case remove failed because the file did no longer exist,
			-- we do not want to raise an exception. That's why we check
			-- if the file still exists.
			if r = -1 and then is_readable (a_path) then
				-- if it exists, try to remove it again to set error code
				r := posix_remove (sh.string_to_pointer (portable_path))
				sh.unfreeze_all
				if r /= 0 then
					raise_posix_error
				end
			end
		end

	rename_to (current_path, new_path: STRING) is
			-- Rename a file or a directory.
			-- `new_path' should not be an existing path.
		require
			valid_current: current_path /= Void and then not current_path.is_empty
			valid_new: new_path /= Void and then not new_path.is_empty
			current_path_exists: is_readable (current_path)
			new_path_does_not_exist: not is_readable (new_path)
		local
			c_current_path,
			c_new_path: POINTER
			the_new_path: STDC_PATH
		do
			-- errno might have been set by precondition `is_readable',
			-- so make sure it is not set anymore.
			errno.clear
			set_portable_path (current_path)
			c_current_path := sh.string_to_pointer (portable_path)
			create the_new_path.make_from_string (new_path)
			c_new_path := sh.string_to_pointer (the_new_path)
			safe_call (posix_rename (c_current_path, c_new_path))
			sh.unfreeze_all
		end


feature -- Accessibility of files

	is_modifiable (a_path: STRING): BOOLEAN is
			-- Is `a_path' readable and writable by this program?
			-- Does this by attempting to open `a_path' file read/write.
		require
			valid_path: a_path /= Void and then not a_path.is_empty
		local
			file: STDC_BINARY_FILE
			oops: BOOLEAN
		do
			if oops then
				Result := False
			else
				create file.open_read_write (a_path)
				file.close
				Result := True
			end
		rescue
			oops := True
			retry
		end

	is_readable (a_path: STRING): BOOLEAN is
			-- Is `a_path' readable by this program?
			-- Does this by attempting to open `a_path' file read-only.
		require
			valid_path: a_path /= Void and then not a_path.is_empty
		local
			file: STDC_BINARY_FILE
			oops: BOOLEAN
		do
			if oops then
				Result := False
			else
				create file.open_read (a_path)
				file.close
				Result := True
			end
		rescue
			oops := True
			retry
		end


feature -- File and string

	write_string_to_file (s, a_file_name: STRING) is
			-- Write `s' to file `a_file_name'.
		require
			valid_path: a_file_name /= Void and then not a_file_name.is_empty
		local
			f: STDC_TEXT_FILE
		do
			create f.create_write (a_file_name)
			if s /= Void and then not s.is_empty then
				f.put_string (s)
			end
			f.close
		end


end
