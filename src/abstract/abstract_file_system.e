indexing

	description: "Abstract file system that should work on POSIX and Windows platforms."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #15 $"


deferred class

	ABSTRACT_FILE_SYSTEM


inherit

	STDC_FILE_SYSTEM
		redefine
			is_modifiable,
			is_readable
		end


feature -- Directory access

	chdir (a_directory: STRING) is
		obsolete "Use change_directory instead."
		do
			change_directory (a_directory)
		end

	change_directory (a_directory: STRING) is
			-- Changes the current working directory.
		require
			directory_not_empty: a_directory /= Void and then not a_directory.is_empty
		do
			set_portable_path (a_directory)
			safe_call (abstract_chdir (sh.string_to_pointer (portable_path)))
			sh.unfreeze_all
		end

	getcwd, pwd: STRING is
		obsolete "Use current_directory instead."
		do
			Result := current_directory
		end

	current_directory: STRING is
			-- The current directory
		local
			buf: STDC_BUFFER
			r: POINTER
		do
			create buf.allocate (256)
			r := abstract_getcwd (buf.ptr, buf.capacity)
			if r = default_pointer then
				if errno.value = ERANGE then
					buf.allocate (1024)
					r := abstract_getcwd (buf.ptr, buf.capacity)
					if r = default_pointer then
						buf.deallocate
						raise_posix_error
					end
				end
			end
			Result := sh.pointer_to_string (r)
			buf.deallocate
		ensure
			directory_returned: Result /= Void
		end

	make_directory, mkdir (a_directory: STRING) is
			-- Makes a directory, only accessible by owner.
		require
			directory_not_empty: a_directory /= Void and then not a_directory.is_empty
		do
			set_portable_path (a_directory)
			safe_call (abstract_mkdir (sh.string_to_pointer (portable_path)))
			sh.unfreeze_all
		end

	make_directories (a_path: STRING) is
			-- Makes a directory, only accessible by owner.
		require
			path_not_empty: a_path /= Void and then not a_path.is_empty
		local
			paths: ARRAY [STRING]
			i: INTEGER
			s: STRING
		do
			set_portable_path (a_path)
			paths := sh.split_on (portable_path, portable_path.directory_separator)
			i := paths.lower
			s := paths.item (i)
			if s.is_empty then
				s := "/"
			end
			from
				i := i + 1
			until
				not errno.is_ok or else
				i > paths.upper
			loop
				if not paths.item (i).is_empty then
					s.append_string (paths.item (i))
					if not is_directory (s) then
						make_directory (s)
					end
					s.append_character ('/')
				end
				i := i + 1
			end
		ensure
			directory_exists: errno.is_ok implies is_directory (a_path)
		end

	remove_directory, rmdir (a_directory: STRING) is
			-- Removes an empty directory. See also `force_remove_directory'.
		require
			directory_not_empty: a_directory /= Void and then not a_directory.is_empty
			directory_is_empty: True
		do
			set_portable_path (a_directory)
			safe_call (abstract_rmdir (sh.string_to_pointer (portable_path)))
			sh.unfreeze_all
		end

	force_remove_directory (a_directory: STRING) is
			-- Removes a directory, even when not empty.
			-- I suggest you do not have hard or symbolic links in `a_directory'...
		require
			directory_not_empty: a_directory /= Void and then not a_directory.is_empty
		local
			dir: ABSTRACT_DIRECTORY
			entry: STRING
			full_child_path: STRING
			is_special_file: BOOLEAN
		do
			if is_existing (a_directory) then
				create full_child_path.make (256)
				dir := browse_directory (a_directory)
				from
					dir.start
				until
					dir.exhausted
				loop
					entry := dir.item
					is_special_file :=
						entry.is_equal (".")
						or else entry.is_equal ("..")
					if not is_special_file then
						full_child_path.wipe_out
						full_child_path.append_string (a_directory)
						full_child_path.append_character (path_separator)
						full_child_path.append_string (entry)
						if status (full_child_path).is_directory then
							force_remove_directory (full_child_path)
						else
							remove_file (full_child_path)
						end
					end
					dir.forth
				end
				if dir.is_open then
					dir.close
				end
				-- directory is empty now
				remove_directory (a_directory)
			end
		end


feature -- File statistics

	status (a_path: STRING): ABSTRACT_STATUS_PATH is
			-- Get information about a file.
		require
			valid_path: a_path /= Void and then not a_path.is_empty
			existing_file: is_existing (a_path)
		deferred
		ensure
			status_returned: Result /= Void
		end

	status_may_fail (a_path: STRING): ABSTRACT_STATUS_PATH is
			-- Retrieve status information for `a_path'. `a_path' may or
			-- may not exist. Check `Result'.`found' to see if statistics
			-- were retrieved.
		require
			valid_path: a_path /= Void and then not a_path.is_empty
		deferred
		ensure
			status_returned: Result /= Void
		end


feature -- Directory browsing

	browse_directory (a_path: STRING): EPX_DIRECTORY is
			-- Get information about a directory.
		require
			valid_path: a_path /= Void and then not a_path.is_empty
			path_is_directory: status_may_fail (a_path).found and then status_may_fail (a_path).is_directory
		deferred
		ensure
			directory_returned: Result /= Void
		end

	find_program_in_path (a_filename: STRING; a_paths: ARRAY [STRING]): STRING is
			-- Look for `a_filename' in `a_paths', check if it is a
			-- binary and return the full path to `a_filename' when
			-- found. Return Void if not found.
		require
			filename_not_empty: a_filename /= Void and then not a_filename.is_empty
			a_paths_not_empty: a_paths /= Void and then a_paths.count > 0
		local
			i: INTEGER
			path: STRING
			s: STRING
		do
			from
				i := a_paths.lower
			variant
				a_paths.count - (i - a_paths.lower)
			until
				Result /= Void or else
				i >= a_paths.upper
			loop
				path := a_paths.item (i)
				if path = Void or else path.is_empty then
					s := a_filename.twin
				else
					create s.make (path.count + 1 + a_filename.count)
					s.append_string (path)
					if path.item (path.count) /= path_separator then
						s.append_character (path_separator)
					end
					s.append_string (a_filename)
				end
				if is_executable (s) then
					Result := s
				end
				i := i + 1
			end
		ensure
			found: Result /= Void implies is_executable (Result)
		end


feature -- Accessibility of files

	last_access_result: INTEGER
			-- value of last access test

	is_accessible, access (a_path: STRING; a_mode: INTEGER): BOOLEAN is
			-- Is `a_path' accessibility using `a_mode'?
		do
			set_portable_path (a_path)
			last_access_result := abstract_access (sh.string_to_pointer (portable_path), a_mode)
			Result := last_access_result = 0
			sh.unfreeze_all
		end

	is_directory (a_path: STRING): BOOLEAN is
			-- Does `a_path' exists and is it a directory?
		do
			Result :=
				is_existing (a_path) and then
				status (a_path).is_directory
		end

	is_existing (a_path: STRING): BOOLEAN is
			-- Is `a_path' an existing file, directory, whatever?
			-- Tests if file does exist, not if it is readable or writable by
			-- this program!
			-- Uses real user ID and real group ID instead of effective ones.
		do
			Result := is_accessible (a_path, abstract_F_OK)
		end

	is_empty (a_path: STRING): BOOLEAN is
			-- True if file exists and has a size equal to zero.
		require
			exists: is_existing (a_path)
		do
			Result := status (a_path).size = 0
		end

	is_executable (a_path: STRING): BOOLEAN is
			-- tests if file is executable by this program
		do
			Result := is_accessible (a_path, abstract_X_OK)
		end

	is_regular_file (a_path: STRING): BOOLEAN is
			-- Does `a_path' exists and is it a regular file?
		do
			Result :=
				is_existing (a_path) and then
				status (a_path).is_regular_file
		end

	is_modifiable (a_path: STRING): BOOLEAN is
			-- tests if file is readable and writable by this program
			-- uses real user ID and real group ID instead of effective ones
		do
			Result := is_accessible (a_path, abstract_R_OK + abstract_W_OK)
		end

	is_readable (a_path: STRING): BOOLEAN is
			-- Tests if `a_path' is readable by this program. `a_path'
			-- can be a file or a directory.
			-- Uses real user ID and real group ID instead of effective
			-- ones.
		do
			Result := is_accessible (a_path, abstract_R_OK)
		end

	is_writable (a_path: STRING): BOOLEAN is
			-- tests if file is writable by this program
			-- uses real user ID and real group ID instead of effective ones
		do
			Result := is_accessible (a_path, abstract_W_OK)
		end


feature -- File system properties

	is_case_sensitive: BOOLEAN is
			-- is file system case sensitive or not?
			-- This query is dedicated to jwz
		deferred
		end

	path_separator: CHARACTER is
			-- What is the path separator?
		deferred
		end


feature -- File and string

	file_content_as_string (a_file_name: STRING): STRING is
			-- Contents of `a_file_name' as a STRING
		require
			valid_path: a_file_name /= Void and then not a_file_name.is_empty
			readable: is_readable (a_file_name)
		local
			stat: ABSTRACT_STATUS_PATH
			file: EPX_FILE_DESCRIPTOR
			buffer: STDC_BUFFER
		do
			-- One big slurp...
			stat := status (a_file_name)
			if stat.size > 0 then
				create buffer.allocate (stat.size)
				create file.open_read (a_file_name)
				file.read_buffer (buffer, 0, buffer.capacity)
				Result := buffer.substring (0, file.last_read - 1)
				file.close
				buffer.deallocate
			end
		ensure
			file_to_string_void: Result /= Void
		end

	string_to_file (s, a_file_name: STRING) is
			-- Create or overwrite a file `a_file_name' and make its
			-- contents `s'.
		local
			file: EPX_FILE_DESCRIPTOR
		do
			remove_file (a_file_name)
			create file.create_write (a_file_name)
			file.put_string (s)
			file.close
		end


feature -- Path names

	resolved_path_name (a_path: STRING): STRING is
			-- Absolute pathname derived from `a_path' that names the
			-- same file, whose resolution does not involve ".", "..", or
			-- symbolic links
		require
			a_path_not_empty: a_path /= Void and then not a_path.is_empty
			path_exists: is_existing (a_path)
		local
			save_directory: STRING
			s: STRING
			path: STDC_PATH
		do
			save_directory := current_directory
			if is_directory (a_path) then
				change_directory (a_path)
				Result := current_directory
			else
				create path.make_from_string (a_path)
				path.parse (Void)
				if path.directory.is_empty then
					create Result.make (save_directory.count + 1 + a_path.count)
					Result.append_string (save_directory)
					Result.append_character ('/')
					Result.append_string (a_path)
				elseif is_directory (path.directory) then
					change_directory (path.directory)
					s := current_directory
					create Result.make (s.count + 1 + path.basename.count)
					Result.append_string (s)
					Result.append_character ('/')
					Result.append_string (path.basename)
				else
					-- need to define ENOENT!!
					--errno.set_value (ENOENT)
					errno.set_value (ERANGE)
					raise_posix_error
				end
			end
			change_directory (save_directory)
		ensure
			resolved_path_name_not_empty:
				raise_exception_on_error implies
					Result /= Void and then not Result.is_empty
			path_resolved:
				not Result.has_substring ("/../") and then
				not Result.has_substring ("/./")
			does_not_start_with_relative_component:
				Result.count > 2 implies Result.item (1) /= '.' and then Result.item (2) /= '/'
			does_not_end_with_relative_component:
				Result.count > 2 implies Result.item (Result.count) /= '/' and then Result.item (Result.count - 1) /= '.'
		rescue
			if save_directory /= Void then
				change_directory (save_directory)
			end
		end

	temporary_directory: STRING is
			-- The name of the temporary directory;
			-- Name does not end with the directory separator.
		deferred
		ensure
			directory_returned: Result /= Void
			directory_exists: is_directory (Result)
			directory_is_writable: is_modifiable (Result)
			last_char_not_separator: Result.item (Result.count) /= path_separator
		end


feature {NONE} -- Abstract C interface

	abstract_access (a_path: POINTER; a_mode: INTEGER): INTEGER is
			-- Tests for file accessibility
		require
			valid_path: a_path /= default_pointer
		deferred
		end

	abstract_chdir (a_path: POINTER): INTEGER is
			-- Changes the current working directory
		require
			valid_path: a_path /= default_pointer
		deferred
		end

	abstract_getcwd (buf: POINTER; size: INTEGER): POINTER is
			-- Gets current working directory
		require
			buf_not_nil: buf /= default_pointer
			size_positive: size > 0
		deferred
		end

	abstract_mkdir (a_path: POINTER): INTEGER is
			-- Makes a directory
		require
			valid_path: a_path /= default_pointer
		deferred
		end

	abstract_rmdir (a_path: POINTER): INTEGER is
			-- Removes a directory
		require
			valid_path: a_path /= default_pointer
		deferred
		end

	abstract_F_OK: INTEGER is
			-- existence
		deferred
		end

	abstract_R_OK: INTEGER is
			-- read permission
		deferred
		end

	abstract_W_OK: INTEGER is
			-- write permission
		deferred
		end

	abstract_X_OK: INTEGER is
			-- execute permission
		deferred
		end

end
