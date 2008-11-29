indexing

	description: "Class that implements memory sharing between different%
	%processes on Windows. There is no file underlying this sharing, %
	%it uses the operating-system paging file.%
	%There isn't an immediate POSIX equivalent for this, but you%
	%can use POSIX_MEMORY_MAP and POSIX_SHARED_MEMORY to achieve the%
	%same effect. Implementations of these classes for Windows are coming, %
	%but if you need Windows only, this is more efficient."

	known_bugs: "Don't enable postconditions for this class if you have multiple clients writing to shared memory without locking mechanisms."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #7 $"

class

	WINDOWS_PAGING_FILE_SHARED_MEMORY

inherit

	ABSTRACT_MEMORY_MAP
		undefine
			raise_posix_error
		redefine
			close,
			dispose
		end

	WINDOWS_BASE
		undefine
			copy,
			is_equal
		end


create

	create_read_write,
	create_read_write_with_security,
	open_read


feature -- Initialization

	create_read_write (a_name: STRING; a_size: INTEGER) is
			-- Create memory mapping without underlying file. Memory map
			-- is only accessible to processes using the current security
			-- account.
			-- If `name' is Void or empty, the mapping is anonymous.
			-- `name' ordinarily does not have any backslashes in it
			-- except "Global\" or "Local\".
		require
			closed: not is_open
			size_positive: a_size > 0
		do
			create_read_write_with_security (a_name, a_size, Void)
		ensure
			open: raise_exception_on_error implies is_open
		end

	create_read_write_with_security (a_name: STRING; a_size: INTEGER; a_security_attributes: WINDOWS_SECURITY_ATTRIBUTES) is
			-- Create memory mapping without underlying file using the
			-- given security attributes.
			-- If `name' is Void or empty, the mapping is anonymous.
			-- `name' ordinarily does not have any backslashes in it
			-- except "Global\" or "Local\".
		require
			closed: not is_open
			size_positive: a_size > 0
		local
			p_security_attributes: POINTER
		do
			capacity := 0
			if a_security_attributes /= Void then
				p_security_attributes := a_security_attributes.ptr
			end
			map_handle := posix_createfilemapping (INVALID_HANDLE_VALUE, p_security_attributes, PAGE_READWRITE, 0, a_size, sh.string_to_pointer (a_name))
			sh.unfreeze_all
			if map_handle /= 0 then
				ptr := posix_mapviewoffile (map_handle, FILE_MAP_ALL_ACCESS, 0, 0, a_size)
				if ptr /= default_pointer then
					capacity := a_size
				else
					raise_windows_error
				end
			else
				raise_windows_error
			end
		ensure
			open: raise_exception_on_error implies is_open
		end

	open_read (a_name: STRING; a_size: INTEGER) is
			-- Open a memory mapping to a named file mapping object.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
			size_positive: a_size > 0
		do
			capacity := 0
			map_handle := posix_openfilemapping (FILE_MAP_READ, False, sh.string_to_pointer (a_name))
			sh.unfreeze_all
			if map_handle /= 0 then
				ptr := posix_mapviewoffile (map_handle, FILE_MAP_READ, 0, 0, a_size)
				if ptr /= default_pointer then
					capacity := a_size
				else
					raise_windows_error
				end
			else
				raise_windows_error
			end
		ensure
			open: raise_exception_on_error implies is_open
		end


feature {NONE} -- Removal

	dispose is
		local
			b: BOOLEAN
		do
			if ptr /= default_pointer then
				b := posix_unmapviewoffile (ptr)
				b := posix_closehandle (map_handle)
			end
			precursor
		rescue
			ptr := default_pointer
			map_handle := INVALID_HANDLE_VALUE
			retry
		end


feature -- Close

	close is
		do
			safe_win_call (posix_unmapviewoffile (ptr))
			safe_win_call (posix_closehandle (map_handle))
			precursor
		end


feature {NONE} -- Implementation

	map_handle: INTEGER
			-- Actual handle to memory area


end
