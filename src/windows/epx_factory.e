indexing

	description: "Factory to return appropriate classes when compiling a WINDOWS application."

	author: "Berend de Boer"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #5 $"

class

	EPX_FACTORY


inherit

	ABSTRACT_FACTORY

	WINDOWS_CONSTANTS

	WAPI_STDLIB


feature -- binary/text file open mode

	is_binary_mode: BOOLEAN is
			-- what's the current open mode?
		do
			Result := posix_fmode = O_BINARY
		end

	set_binary_mode (value: BOOLEAN) is
		do
			if value then
				posix_set_fmode (O_BINARY)
			else
				posix_set_fmode (O_TEXT)
			end
		ensure then
			mode_set: value = is_binary_mode
		end


feature -- file descriptor

	create_with_mode (a_path: STRING; flags, mode: INTEGER): ABSTRACT_FILE_DESCRIPTOR is
		do
			create {WINDOWS_FILE_DESCRIPTOR} Result.create_with_mode (a_path, flags, mode)
		end

	create_write (a_path: STRING): ABSTRACT_FILE_DESCRIPTOR is
		do
			create {WINDOWS_FILE_DESCRIPTOR} Result.create_write (a_path)
		end

	create_read_write (a_path: STRING): ABSTRACT_FILE_DESCRIPTOR is
		do
			create {WINDOWS_FILE_DESCRIPTOR} Result.create_read_write (a_path)
		end

	open (a_path: STRING; a_flags: INTEGER): ABSTRACT_FILE_DESCRIPTOR is
		do
			create {WINDOWS_FILE_DESCRIPTOR} Result.open (a_path, a_flags)
		end

	open_read (a_path: STRING): ABSTRACT_FILE_DESCRIPTOR is
		do
			create {WINDOWS_FILE_DESCRIPTOR} Result.open_read (a_path)
		end

	open_read_write (a_path: STRING): ABSTRACT_FILE_DESCRIPTOR is
		do
			create {WINDOWS_FILE_DESCRIPTOR} Result.open_read_write (a_path)
		end

	open_truncate (a_path: STRING): ABSTRACT_FILE_DESCRIPTOR is
		do
			create {WINDOWS_FILE_DESCRIPTOR} Result.open_truncate (a_path)
		end

	open_write (a_path: STRING): ABSTRACT_FILE_DESCRIPTOR is
		do
			create {WINDOWS_FILE_DESCRIPTOR} Result.open_write (a_path)
		end


feature -- pipe

	create_pipe: ABSTRACT_PIPE is
		do
			create {WINDOWS_PIPE} Result.make
		end


end
