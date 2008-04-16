indexing

	description: "Class that gets stat structure through stat call."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"

deferred class

	ABSTRACT_STATUS_PATH


inherit

	ABSTRACT_STATUS

	PORTABLE_PATH
		rename
			portable_path as path
		export
			{ANY} path
		end


feature {ABSTRACT_FILE_SYSTEM} -- Initializiation

	make (a_path: STRING) is
			-- Retrieve status for `a_path'. `a_path' must be an existing
			-- file.
		require
			path_not_empty: a_path /= Void and then not a_path.is_empty
		do
			make_stat
			set_path (a_path)
		end

	make_may_fail (a_path: STRING) is
			-- Retrieve status for `a_path'. Check `found' to see if
			-- there was an error retrieving the status of `a_path'.
		require
			path_not_empty: a_path /= Void and then not a_path.is_empty
		do
			make_stat
			set_path_may_fail (a_path)
		end


feature -- Status

	is_open: BOOLEAN is True
			-- Can status be refreshed?

	found: BOOLEAN
			-- Could the statistics for `path' be retrieved?


feature -- State change commands

	refresh is
			-- Refresh the cached status information.
		do
			refresh_may_fail
			if not found then
				safe_call (-1)
			end
		ensure then
			found: found
		end

	refresh_may_fail is
			-- Refresh the cached status information. Check `found' to
			-- see if retrieving the statistics was successful.
		local
			cpath: POINTER
		do
			cpath := sh.string_to_pointer (path)
			found := abstract_stat (cpath, stat.ptr) /= -1
			sh.unfreeze_all
		end

	set_filename (a_path: STRING) is
		obsolete	"use set_path instead"
		do
			set_path (a_path)
		end

	set_path (a_path: STRING) is
			-- Change for which path (file/directory) the statistics are
			-- kept. `a_path' should be an existing path.
			-- Statistics are immediately refreshed.
		require
			path_not_empty: a_path /= Void and then not a_path.is_empty
		do
			set_portable_path (a_path)
			refresh
		ensure
			found: found
		end

	set_path_may_fail (a_path: STRING) is
			-- Change for which path (file/directory) the statistics are
			-- kept. Check `found' to see if statistics could be retrieved.
			-- Statistics are immediately refreshed.
		require
			path_not_empty: a_path /= Void and then not a_path.is_empty
		do
			set_portable_path (a_path)
			refresh_may_fail
		end


feature {NONE} -- abstract API

	abstract_stat (a_path: POINTER; a_stat: POINTER): INTEGER is
			-- Gets information about a path.
		require
			valid_path: a_path /= default_pointer
			valid_stat_buffer: a_stat /= default_pointer
		deferred
		ensure
			-- Result = -1 implies errno.is_not_ok
		end


invariant

	non_empty_path: path /= Void and then not path.is_empty

end
