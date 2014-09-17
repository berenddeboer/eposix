note

	description: "Class that covers Single Unix Specification file system code."

	author: "Berend de Boer"


class

	SUS_FILE_SYSTEM


inherit

	POSIX_FILE_SYSTEM
		redefine
			resolved_path_name,
			status,
			status_may_fail
		end

	SAPI_STDLIB

	SAPI_UNISTD


feature -- File statistics

	status (a_path: STRING): SUS_STATUS_PATH
			-- Return information about path.
		do
			create {SUS_STATUS_PATH} Result.make (a_path)
		end

	status_may_fail (a_path: STRING): SUS_STATUS_PATH
			-- Retrieve status information for `a_path'. `a_path' may or
			-- may not exist. Check `Result'.`found' to see if statistics
			-- were retrieved.
		do
			create {SUS_STATUS_PATH} Result.make_may_fail (a_path)
		end

	symbolic_link_status (a_path: STRING): SUS_STATUS
			-- Return information about path, but if it is a symbolic
			-- link, about the symbolic link instead of the referenced path
		do
			create {SUS_STATUS_LINK} Result.make (a_path)
		end


feature -- Symbolic links

	create_symbolic_link, symlink (old_path, new_path: STRING)
			-- Create a symbolic link  named `new_path' which contains the
			-- string `old_path'.
		require
			valid_old: old_path /= Void and then not old_path.is_empty
			valid_new: new_path /= Void and then not new_path.is_empty
		do
			safe_call (posix_symlink (sh.string_to_pointer (old_path),
											  sh.string_to_pointer (new_path)))
			sh.unfreeze_all
		ensure
			symbolic_link_created: symbolic_link_status (new_path).is_symbolic_link
		end


feature -- File system properties

	realpath (a_path: STRING): STRING
		obsolete" Use resolved_path_name instead."
		do
			Result := resolved_path_name (a_path)
		end

	resolved_path_name (a_path: STRING): STRING
			-- Derives from `a_path' an absolute pathname that names the
			-- same file, whose resolution does not involve ".", "..", or
			-- symbolic links.
		local
			resolved_path: POSIX_BUFFER
			p: POINTER
		do
			create resolved_path.allocate_and_clear (PATH_MAX)
			p := posix_realpath (sh.string_to_pointer (a_path), resolved_path.ptr)
			sh.unfreeze_all
			if p = default_pointer then
				raise_posix_error
			else
				Result := sh.pointer_to_string (resolved_path.ptr)
			end
		end


end
