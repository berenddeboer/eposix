indexing

	description: "Base filter class used with directory browsing"

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $";
	revision: "$Revision: #6 $"


deferred class

	ABSTRACT_PATH_FILTER


feature -- Validation

	validate_directory: BOOLEAN is
			-- When encountering a directory, pass it to `is_valid' for
			-- validation or recurse immediately into that directory
			-- without ever passing the directory to `is_valid'?
			-- If False a directory entry is never seen by `is_valid'.
		do
			Result := True
		end

	is_valid (a_status: ABSTRACT_STATUS; a_path_name: STRING): BOOLEAN is
			-- Is `path_name' a valid path to return?
		require
			has_status_when_needed: require_status implies a_status /= Void
			path_name_not_empty: a_path_name /= Void and not a_path_name.is_empty
		deferred
		end

	require_status: BOOLEAN is
			-- Should `is_valid' receive a valid status?
			-- Optional, because a status call can be expensive. If you
			-- do recursive browsing, a status is retrieved, passing it
			-- is much cheaper than doing another stat() call yourself.
		do
			Result := False
		end

end
