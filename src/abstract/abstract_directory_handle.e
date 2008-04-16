indexing

	description:

		"An abstract directory handle base class for Windows/POSIX."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #4 $"


deferred class

	ABSTRACT_DIRECTORY_HANDLE


inherit

	STDC_HANDLE [POINTER]
		redefine
			do_close
		end


feature {NONE} -- Initialization

	make (a_directory_name: STRING) is
			-- Open directory `a_directory_name'. `a_directory_name' must
			-- be an existing directory. Cursor is not positioned, use
			-- `forth' to move the cursor to the first entry.
		require
			directory_name_not_empty: a_directory_name /= Void and then not a_directory_name.is_empty
		local
			h: POINTER
		do
			create item.make (32)
			create directory_name.make_from_string (a_directory_name)
			h := abstract_opendir (sh.string_to_pointer (directory_name))
			sh.unfreeze_all
			if h = default_pointer then
				raise_posix_error
			else
				capacity := 1
				set_handle (h, True)
			end
		ensure
			file_is_open: raise_exception_on_error implies is_open
			owner_set: is_open implies is_owner
		end


feature -- Access

	directory_name: STDC_PATH
			-- Directory that is browsed

	item: STRING
			-- The current entry, i.e. the path name.

	max_filename_length: INTEGER is
			-- Maximum length of a file in this directory.
		deferred
		ensure
			positive_length: Result > 0
		end


feature -- Status

	after: BOOLEAN
			-- Has the directory been traversed completely?


feature -- Cursor movement

	forth is
			-- Go to next entry. Set `is_dot' and `is_dotdot'.
		require
			not_after: not after
		local
			dirent: POINTER
		do
			errno.clear
			dirent := abstract_readdir (handle)
			after := dirent = default_pointer
			if after then
				if errno.is_not_ok then
					raise_posix_error
				else
					close
				end
			else
				sh.set_string_from_pointer (item, abstract_d_name (dirent))
				is_dot :=
					item.count = 1 and then item.item (1) = '.'
				is_dotdot :=
					not is_dot and then
					(item.count = 2 and then
					 item.item (1) = '.' and then
					 item.item (2) = '.')
			end
		ensure
			after_is_closed: after = not is_open
		end


feature -- Access

	is_dot: BOOLEAN
			-- If `item' is equal to ".".

	is_dotdot: BOOLEAN
			-- If `item' is equal to "..".

	resource_usage_can_be_increased: BOOLEAN is True
			-- Can the number of allocated resources increased with `capacity'?


feature {NONE} -- Counting of allocated resource

	decrease_resource_count is
			-- Decrease number of allocated resource by `capacity'.
			-- Due to limitations of certain Eiffel implementations, this
			-- routine may not call any other object. Calling C code is safe.
		do
			my_resource_count.set_item (my_resource_count.item - 1)
		end

	increase_resource_count is
			-- Increase number of allocated resources by `capacity'.
		do
			my_resource_count.set_item (my_resource_count.item + 1)
		end

	my_resource_count: INTEGER_REF is
			-- Track opened directory handles.
			-- Implementation is currently not really safe.
		once
			create Result
		ensure
			my_resource_count_not_void: my_resource_count /= Void
		end

	resource_count: INTEGER is
			-- Currently allocated number of resources. It's a global
			-- number, counting the `capacity' of all owned resources of
			-- this type.
		do
			Result := my_resource_count.item
		end


feature {NONE} -- Low level handle functions

	do_close: BOOLEAN is
			-- Close resource. Return False if an error occurred. Error
			-- value should be in `errno'. This routine may never call
			-- another object, else it cannot be used safely in
			-- `dispose'.
			-- This routine is usely redefined to actually close or
			-- deallocate the resource in addition of resetting `handle'.
		local
			r: INTEGER
		do
			r := abstract_closedir (handle)
			Result := r = 0
			clear_handle
		end

	frozen unassigned_value: POINTER is
			-- The value that indicates that `handle' is unassigned.
		do
			Result := default_pointer
		end


feature {NONE} -- Abstract API

	abstract_closedir (a_dirp: POINTER): INTEGER is
			-- Ends directory read operation
		require
			valid_dirp: a_dirp /= default_pointer
		deferred
		end

	abstract_opendir (a_dirname: POINTER): POINTER is
			-- Opens a directory
		require
			valid_dirp: a_dirname /= default_pointer
		deferred
		end

	abstract_readdir (a_dirp: POINTER): POINTER is
			-- Reads a directory
		require
			valid_dirp: a_dirp /= default_pointer
		deferred
		end

	abstract_rewinddir (a_dirp: POINTER) is
			-- Reset the readdir pointer.
		require
			valid_dirp: a_dirp /= default_pointer
		deferred
		end

	abstract_d_name (a_dirent: POINTER): POINTER is
		require
			valid_dirp: a_dirent /= default_pointer
		deferred
		end


invariant

	item_not_void: item /= Void
	valid_is_dot: is_dot = item.is_equal (".")
	valid_is_dotdot: is_dotdot = item.is_equal ("..")

end
