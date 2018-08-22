note

	description: "Class that covers a portable directory. Main use is to be %
	%able to loop (recursively) through a directory."

	author: "Berend de Boer, Marcio Marchini"


class

	ABSTRACT_DIRECTORY


inherit

	STDC_BASE

	EPX_FACTORY
		export
			{NONE} all
		end

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		end


create

	make


feature {NONE} -- Initialization

	make (a_directory_name: STRING)
			-- Initialize for browsing `a_directory_name'.
		require
			directory_name_not_empty: a_directory_name /= Void and then not a_directory_name.is_empty
		do
			create directory_name.make_from_string (a_directory_name)
			create {DS_LINKED_LIST [ABSTRACT_DIRECTORY_HANDLE]} directory_entries.make
		end


feature -- Access

	close
			-- Close directory entry (save resources now, don't wait for
			-- garbage collection). If you call start it will automatically
			-- reopen.
			-- If `forth' ends with `exhausted', close is automatically called.
		require
			not_closed: is_open
		do
			from
				directory_entries.start
			until
				directory_entries.after
			loop
				directory_entries.item_for_iteration.close
				directory_entries.forth
			end
			directory_entries.wipe_out
		ensure
			closed: not is_open
			status_cleared: my_status = Void
		end

	start
			-- Start directory traversal.
		local
			entry: EPX_DIRECTORY_HANDLE
		do
			found := False
			directory_entries.wipe_out
			create entry.make_default (directory_name)
			entry.inherit_error_handling (Current)
			entry.errno.clear
			entry.open
			if entry.errno.is_ok then
				directory_entries.put_last (entry)
				forth
			end
		end

	forth
			-- Get the next directory entry.
			-- It skips entries for which the filter returns false or bad
			-- entries (soft links pointing to unexisting files).
		require
			opened: is_open
			not_exhausted: not exhausted
		local
			optional_status: ABSTRACT_STATUS_PATH
			found_new: BOOLEAN
		do
			if not attached filter as a_filter then
				forth_recursive
				found := not exhausted
			else
				from
				until
					exhausted or else found_new
				loop
					forth_recursive
					if not exhausted then
						if a_filter.validate_directory then
							found := is_item_valid
							found_new := found
						else
							optional_status := status
							if optional_status.is_directory then
								found := True
							else
								found := is_item_valid
								found_new := found
							end
						end
					end
				end
			end
		ensure
			valid_entry_found: not exhausted = found
			found_directory_entry_only_when_specified:
				found implies
					((attached filter as a_filter and then not a_filter.validate_directory) implies
						not status.is_directory)
		end


feature -- Influence browsing

	filter: detachable ABSTRACT_PATH_FILTER
			-- Optional filter

	set_filter (a_filter: ABSTRACT_PATH_FILTER)
			-- Change the filter which determines which entries are returned.
		do
			filter := a_filter
		ensure
			filter_set: filter = a_filter
		end

	set_extension_filter (extension: STRING)
			-- Create and set filter, `extension' is like ".e".
			-- `extension' shouldn't contain any wildcards
		require
			extension_not_empty: extension /= Void and then not extension.is_empty
			directory_browsing_not_in_progress: not is_open
		local
			ext_filter: EPX_EXTENSION_FILTER
		do
			create ext_filter.make (extension)
			set_filter (ext_filter)
		ensure
			extension_filter_set: filter /= Void
		end

	recursive: BOOLEAN
			-- Enable depth first directory browsing.
			-- Recursion doesn't work well with hard or symbolic links. Use
			-- SUS_DIRECTORY instead.
			-- 2018-08-22: Eh, that class does not exist, so is this still an issue?

	set_recursive (enable: BOOLEAN)
			-- Enable recursive directory browsing.
		do
			recursive := enable
		ensure
			recursive_set: recursive = enable
		end


feature -- Access

	directory_name: STDC_PATH
			-- Directory that is browsed

	full_name: STDC_PATH
			-- Combination of `directory_name' and `item'
		require
			opened: is_open
		do
			Result := my_full_name
			Result.append_string (directory_name)
			Result.append_character (fs.path_separator)
			from
				directory_entries.start
			until
				directory_entries.after
			loop
				Result.append_string (directory_entries.item_for_iteration.item)
				directory_entries.forth
				if not directory_entries.after then
					Result.append_character (fs.path_separator)
				end
			end
		ensure
			not_void: Result /= Void
		end

	item: STRING
			-- The current entry, i.e. the path name;
			-- Even for recursive browsing, this entry is just the path
			-- name without any preceding sub directory name.
		require
			opened: is_open
		do
			Result := directory_entries.last.item
		ensure
			item_not_void: item /= Void
		end

	max_filename_length: INTEGER
			-- Maximum length of a file in the currently traversed
			-- (sub)directory
		require
			open: is_open
		do
			Result := directory_entries.last.max_filename_length
		ensure
			positive_length: Result > 0
		end

	status: ABSTRACT_STATUS_PATH
			-- The status object for `item'. Check `Result'.`found' to
			-- see if status could indeed by retrieved.
		require
			have_entry: not exhausted
		do
			if attached my_status as ms then
				Result := ms
			else
				Result := fs.status_may_fail (full_name)
				my_status := Result
			end
		ensure
			status_not_void: attached Result
		end


feature -- Status report

	after, exhausted: BOOLEAN
			-- Are there no more entries in this directory?
		do
			Result :=
				directory_entries.is_empty
		ensure
			definition: directory_entries.is_empty = exhausted
		end

	is_dot: BOOLEAN
			-- Is `item' equal to "."?
		require
			have_entry: not exhausted
		do
			Result := directory_entries.last.is_dot
		ensure
			is_dot: Result = directory_entries.last.item.is_equal (".")
		end

	is_dotdot: BOOLEAN
			-- Is `item' is equal to ".."??
		require
			have_entry: not exhausted
		do
			Result := directory_entries.last.is_dotdot
		ensure
			is_dot: Result = directory_entries.last.item.is_equal ("..")
		end

	is_open: BOOLEAN
			-- Is directory opened for traversal?
		do
			Result := not directory_entries.is_empty
		end


feature {NONE} -- directory browsing primitives

	forth_recursive
			-- Next entry in current (sub)directory if not recursive.
			-- First entry in subdirectory if current entry is a subdirectory.
		require
			opened: is_open
			not_exhausted: not exhausted
		local
			fn: STDC_PATH
			subdirectory: EPX_DIRECTORY_HANDLE
			new_entry_found: BOOLEAN
			local_status: like my_status
		do
			from
			until
				exhausted or else new_entry_found
			loop
				if
					recursive and then
					found and then
					not is_dot and then
					not is_dotdot
				then
					-- Last entry might be a directory.
					-- If so, we descend into that directory.
					fn := full_name
					if not attached my_status as my_my_status then
						local_status := fs.status_may_fail (fn)
						my_status := local_status
					else
						local_status := my_my_status
					end
					if local_status.found and then local_status.is_directory then
						create subdirectory.make (fn)
						directory_entries.put_last (subdirectory)
					end
				end
				forth_single
				if directory_entries.last.after then
					directory_entries.remove_last
					found := False
				else
					new_entry_found := True
				end
			end
		end

	forth_single
			-- Go to next entry. Set `is_dot' and `is_dotdot'.
		require
			opened: is_open
			not_exhausted: not exhausted
		do
			-- Invalidate cached status for previous entry
			my_status := Void
			directory_entries.last.forth
		ensure
			my_status_unset: my_status = Void
		end

	is_item_valid: BOOLEAN
			-- Is the current entry valid?
		local
			optional_status: ABSTRACT_STATUS_PATH
		do
			if attached filter as a_filter then
				if a_filter.require_status then
					optional_status := status
					if optional_status.found then
						Result := a_filter.is_valid (optional_status, full_name)
					end
				else
					Result := a_filter.is_valid (Void, full_name)
				end
			end
		end


feature {NONE} -- Implementation

	directory_entries: DS_LINKED_LIST [ABSTRACT_DIRECTORY_HANDLE]
			-- List of all opened directory handles.
			-- Used as a stack, but sometimes we need to traverse through
			-- the entries.

	found: BOOLEAN
			-- Was last found entry a valid entry? I.e. not the first and not
			-- filtered out?

	my_full_name: STDC_PATH
			--- Cache for full name, avoid string allocations.
			-- This cache speeds up simple directory browsing programs
			-- which output `full_name' enormously to a factor 3.
		once
			create Result.make (256)
		end

	my_status: detachable ABSTRACT_STATUS_PATH
			-- Optional status of current entry.


invariant

	directory_name_not_empty: attached directory_name and then not directory_name.is_empty
	my_status_tracks_item: attached my_status as my_my_status implies my_my_status.path.is_equal (full_name)

end
